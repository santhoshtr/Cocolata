use crate::glyphnames::{get_glyph_name, get_unicode_for_name};
use crate::malayalam_font::MalayalamFont;
use log::{debug, warn};
use norad::{AffineTransform, Component, Glyph};

impl MalayalamFont {
    pub fn build_composites(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        self.build_space()?;
        self.build_latin_diacritics()?;
        self.build_malayalam_la_conjuncts()?;
        self.build_malayalam_u_signs()?;
        Ok(())
    }

    fn build_space(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let i_width = match self.font.default_layer().get_glyph("i") {
            Some(g) => g.width,
            None => {
                warn!("Glyph 'i' not found; using width 500 for space");
                500.0
            }
        };

        let mut space = Glyph::new("space");
        space.width = i_width * 1.5;
        space.codepoints = vec![' '].into_iter().collect();

        let layer = self.font.default_layer_mut();
        layer.insert_glyph(space);

        // NBSP width must be same as space width
        if let Some(nbsp) = layer.get_glyph_mut("uni00A0") {
            nbsp.width = i_width * 1.5;
        }

        Ok(())
    }

    fn build_latin_diacritics(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let diacritics = vec![
            "\u{02c6}", "\u{00b4}", "\u{00b8}", "˚", "¯", "`", "ˇ", "¨", "˙", "\u{02dc}",
            "\u{02d8}", "\u{02db}", "\u{02dd}", "\u{0326}",
        ];

        let lc_all = self.get_glyphs_from_class("LC_ALL");
        let uc_all = self.get_glyphs_from_class("UC_ALL");
        let latin_extra: Vec<String> = self.get_glyphs_from_class("LATIN_EXTRA");

        for diacritic in diacritics {
            let diacritic_name = get_glyph_name(diacritic, "ml_");

            if !self.font.default_layer().contains_glyph(&diacritic_name) {
                continue;
            }

            for base in lc_all.iter().chain(uc_all.iter()) {
                let mut base_name = get_glyph_name(base, "ml_");
                let items = [base_name.clone(), diacritic_name.clone()];

                let composite_glyph_name = items.join("");

                let composite_unicode = get_unicode_for_name(&composite_glyph_name, false)
                    .and_then(|codes| codes.first().copied());

                if composite_unicode.is_none() {
                    continue;
                }

                if let Some(unicode) = composite_unicode
                    && let Some(c) = char::from_u32(unicode)
                    && !latin_extra.contains(&c.to_string())
                {
                    continue;
                }

                if base == "i" || base == "j" {
                    base_name = format!("dotless{}", base_name);
                }

                let mut actual_diacritic = diacritic_name.clone();

                if base_name == "t" && diacritic_name == "caron" {
                    actual_diacritic = "caroncmbalt".to_string();
                }
                if base_name == "L" && diacritic_name == "cedilla" {
                    actual_diacritic = "commaaccent".to_string();
                }
                if base_name == "L" && diacritic_name == "caron" {
                    actual_diacritic = "caroncmbalt".to_string();
                }
                if base_name == "l" && diacritic_name == "caron" {
                    actual_diacritic = "caroncmbalt".to_string();
                }
                if base_name == "n" && diacritic_name == "cedilla" {
                    actual_diacritic = "commaaccent".to_string();
                }
                if base_name == "g" && diacritic_name == "cedilla" {
                    actual_diacritic = "commaturnedmod".to_string();
                }

                if !self.font.default_layer().contains_glyph(&base_name) {
                    continue;
                }

                let components = vec![base_name, actual_diacritic];

                if let Some(unicode) = composite_unicode {
                    debug!(
                        "Building composite {} ({:04X}) from {:?}",
                        composite_glyph_name, unicode, components
                    );
                    if let Err(e) =
                        self.build_composite_glyph(&composite_glyph_name, Some(unicode), components)
                    {
                        debug!("Failed to build {}: {}", composite_glyph_name, e);
                    }
                }
            }
        }

        Ok(())
    }

    fn build_malayalam_la_conjuncts(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let consonants = self.get_glyphs_from_class("ML_CONSONANTS");
        let la_sign = "്ല";
        let la_conjuncts: Vec<String> = self.get_glyphs_from_class("ML_LA_CONJUNCTS");

        for consonant in consonants {
            let conjunct = format!("{}{}", consonant, la_sign);

            if !la_conjuncts.contains(&conjunct) {
                continue;
            }

            let base_name = get_glyph_name(&consonant, "ml_");
            let la_sign_name = get_glyph_name(la_sign, "ml_");
            let conjunct_name = get_glyph_name(&conjunct, "ml_");

            if self.font.default_layer().contains_glyph(&conjunct_name) {
                continue;
            }

            debug!(
                "Building LA conjunct {} from {} + {}",
                conjunct_name, base_name, la_sign_name
            );

            if let Err(e) =
                self.build_composite_glyph(&conjunct_name, None, vec![base_name, la_sign_name])
            {
                debug!("Failed to build {}: {}", conjunct_name, e);
            }
        }

        Ok(())
    }

    fn build_malayalam_u_signs(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let bases = self.get_all_malayalam_bases();
        let prevent_conjuncts: Vec<String> = self
            .get_glyphs_from_class("ML_PREVENT_CONJUNCTS")
            .iter()
            .map(|s| get_glyph_name(s, "ml_"))
            .collect();

        for base in bases {
            let base_name = get_glyph_name(&base, "ml_");

            let u_form = format!("{}ു", base);
            let u_form_name = get_glyph_name(&u_form, "ml_");

            if !self.font.default_layer().contains_glyph(&u_form_name)
                && !prevent_conjuncts.contains(&u_form_name)
            {
                debug!(
                    "Building U form {} from {} + u_drop_sign",
                    u_form_name, base_name
                );
                if let Err(e) = self.build_composite_glyph(
                    &u_form_name,
                    None,
                    vec![base_name.clone(), "u_drop_sign".to_string()],
                ) {
                    debug!("Failed to build {}: {}", u_form_name, e);
                } else if let Some(alts) = self.salts.get(&base_name)
                    && let Some(alt_base) = alts.first()
                {
                    let u_form_name_alt = u_form_name.replace(&base_name, alt_base);
                    if let Err(e) = self.build_composite_glyph(
                        &u_form_name_alt,
                        None,
                        vec![alt_base.clone(), "u_drop_sign".to_string()],
                    ) {
                        debug!("Failed to build {}: {}", u_form_name_alt, e);
                    } else {
                        self.salts
                            .entry(u_form_name.clone())
                            .or_default()
                            .push(u_form_name_alt);
                    }
                }
            }

            let uu_form = format!("{}ൂ", base);
            let uu_form_name = get_glyph_name(&uu_form, "ml_");

            if !self.font.default_layer().contains_glyph(&uu_form_name)
                && !prevent_conjuncts.contains(&uu_form_name)
            {
                debug!(
                    "Building UU form {} from {} + uu_drop_sign",
                    uu_form_name, base_name
                );
                if let Err(e) = self.build_composite_glyph(
                    &uu_form_name,
                    None,
                    vec![base_name.clone(), "uu_drop_sign".to_string()],
                ) {
                    debug!("Failed to build {}: {}", uu_form_name, e);
                } else if let Some(alts) = self.salts.get(&base_name)
                    && let Some(alt_base) = alts.first()
                {
                    let uu_form_name_alt = uu_form_name.replace(&base_name, alt_base);
                    if let Err(e) = self.build_composite_glyph(
                        &uu_form_name_alt,
                        None,
                        vec![alt_base.clone(), "uu_drop_sign".to_string()],
                    ) {
                        debug!("Failed to build {}: {}", uu_form_name_alt, e);
                    } else {
                        self.salts
                            .entry(uu_form_name.clone())
                            .or_default()
                            .push(uu_form_name_alt);
                    }
                }
            }
        }

        Ok(())
    }

    pub fn build_composite_glyph(
        &mut self,
        name: &str,
        unicode: Option<u32>,
        components: Vec<String>,
    ) -> Result<(), Box<dyn std::error::Error>> {
        let mut composite = Glyph::new(name);

        if let Some(cp) = unicode
            && let Some(c) = char::from_u32(cp)
        {
            composite.codepoints = vec![c].into_iter().collect();
        }

        let base_name = &components[0];
        let base_glyph = self
            .font
            .default_layer()
            .get_glyph(base_name)
            .ok_or(format!("Base glyph {} not found", base_name))?
            .clone();

        composite.width = base_glyph.width;

        let base_component = Component::new(
            norad::Name::new(base_name)?,
            AffineTransform::default(),
            None,
        );
        composite.components.push(base_component);

        let mut current_base = base_glyph;

        for component_name in &components[1..] {
            let component_glyph = self
                .font
                .default_layer()
                .get_glyph(component_name)
                .ok_or(format!("Component {} not found", component_name))?
                .clone();

            if let Some((_anchor_name, base_anchor, mark_anchor)) =
                self.find_common_anchor(&current_base, &component_glyph)
            {
                let x_offset = base_anchor.x - mark_anchor.x;
                let y_offset = base_anchor.y - mark_anchor.y;

                let transform = AffineTransform {
                    x_scale: 1.0,
                    xy_scale: 0.0,
                    yx_scale: 0.0,
                    y_scale: 1.0,
                    x_offset,
                    y_offset,
                };

                let component = Component::new(norad::Name::new(component_name)?, transform, None);
                composite.components.push(component);

                current_base = component_glyph;
            } else {
                warn!(
                    "No common anchor found for {} + {}, skipping composite {}",
                    current_base.name(),
                    component_name,
                    name
                );
                return Ok(());
            }
        }

        composite.lib.insert(
            "public.markColor".to_string(),
            plist::Value::String("0.92, 0.93, 0.94, 1.0".to_string()),
        );

        let layer = self.font.default_layer_mut();
        layer.insert_glyph(composite);

        Ok(())
    }

    fn find_common_anchor<'a>(
        &self,
        base: &'a Glyph,
        mark: &'a Glyph,
    ) -> Option<(String, &'a norad::Anchor, &'a norad::Anchor)> {
        for base_anchor in &base.anchors {
            if let Some(base_name) = &base_anchor.name {
                for mark_anchor in &mark.anchors {
                    if let Some(mark_name) = &mark_anchor.name
                        && base_name == mark_name
                    {
                        return Some((base_name.to_string(), base_anchor, mark_anchor));
                    }
                }
            }
        }
        None
    }
}
