use std::collections::BTreeMap;

use crate::config::KernSide;
use crate::glyphnames::get_glyph_name;
use crate::malayalam_font::MalayalamFont;
use log::debug;
use norad::Name;

impl MalayalamFont {
    pub fn build_kern(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        // Clone the rules to avoid borrowing issues
        let latin_rules = self.config.glyphs.kern.latin.clone();
        let malayalam_rules = self.config.glyphs.kern.malayalam.clone();

        for rule in &latin_rules {
            if let Err(e) = self.add_kern_rule(rule) {
                debug!("Failed to add Latin kern rule: {}", e);
            }
        }

        for rule in &malayalam_rules {
            if let Err(e) = self.add_kern_rule(rule) {
                debug!("Failed to add Malayalam kern rule: {}", e);
            }
        }

        Ok(())
    }

    fn add_kern_rule(
        &mut self,
        rule: &crate::config::KernRule,
    ) -> Result<(), Box<dyn std::error::Error>> {
        let (lhs_def, rhs_def, value) = match rule {
            crate::config::KernRule::Triple(l, r, v) => (l, r, v),
        };

        let lhs_items = self.expand_kern_side(lhs_def)?;
        let rhs_items = self.expand_kern_side(rhs_def)?;

        for lhs in &lhs_items {
            for rhs in &rhs_items {
                let mut val = BTreeMap::new();
                val.insert(Name::new(rhs.as_str())?, *value as f64);

                self.font.kerning.insert(Name::new(lhs.as_str())?, val);
            }
        }

        Ok(())
    }

    fn expand_kern_side(&self, side: &KernSide) -> Result<Vec<String>, Box<dyn std::error::Error>> {
        let items = side.to_vec();
        let mut result = Vec::new();

        for item in items {
            if item.starts_with("1.") || item.starts_with("2.") {
                result.push(format!("public.kern{}", item));
            } else {
                let first_char = item.chars().next().unwrap_or(' ');
                let codepoint = first_char as u32;

                let prefix = if (0x0D00..=0x0D7F).contains(&codepoint) {
                    "ml_"
                } else {
                    "ml_"
                };

                let glyph_name = get_glyph_name(&item, prefix);

                if self.font.default_layer().contains_glyph(&glyph_name) {
                    result.push(glyph_name);
                }
            }
        }

        Ok(result)
    }
}
