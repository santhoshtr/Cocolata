use crate::glyphnames::get_glyph_name;
use crate::malayalam_font::MalayalamFont;
use log::debug;
use norad::Name;

impl MalayalamFont {
    pub fn build_glyph_groups(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        for (class_name, class_def) in &self.config.glyphs.kern.classes {
            let glyph_names = self.expand_class_to_glyph_names(class_def)?;

            let existing_glyphs: Vec<Name> = glyph_names
                .into_iter()
                .filter(|name| self.font.default_layer().contains_glyph(name))
                .map(|name| Name::new(name.as_str()).unwrap())
                .collect();

            if !existing_glyphs.is_empty() {
                let group_name = Name::new(format!("public.kern{}", class_name).as_str())?;
                debug!(
                    "Creating group {} with {} glyphs",
                    group_name,
                    existing_glyphs.len()
                );
                self.font.groups.insert(group_name, existing_glyphs);
            }
        }

        Ok(())
    }

    fn expand_class_to_glyph_names(
        &self,
        class_def: &crate::config::GlyphClass,
    ) -> Result<Vec<String>, Box<dyn std::error::Error>> {
        let items = class_def.to_vec();
        let mut glyph_names = Vec::new();

        for item in items {
            let first_char = item.chars().next().unwrap_or(' ');
            let codepoint = first_char as u32;

            let prefix = if (0x0D00..=0x0D7F).contains(&codepoint) {
                "ml_"
            } else {
                "ml_"
            };

            let glyph_name = get_glyph_name(&item, prefix);
            glyph_names.push(glyph_name);
        }

        Ok(glyph_names)
    }
}
