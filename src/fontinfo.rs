use crate::malayalam_font::MalayalamFont;
use chrono::{Datelike, Utc};
use log::info;
use norad::{
    Guideline, Name,
    fontinfo::{GaspBehavior, GaspRangeRecord, Os2FamilyClass, Os2Panose},
};

impl MalayalamFont {
    pub fn set_font_info(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let info = &mut self.font.font_info;

        info.units_per_em = Some(self.config.units_per_em.into());
        info.ascender = Some(self.config.ascender);
        info.descender = Some(-self.config.descender);
        info.x_height = Some(self.config.xheight);
        info.cap_height = Some(self.config.cap_height);

        info.family_name = Some(self.config.name.clone());
        info.style_name = Some(self.style.clone());

        let (_, year) = Utc::now().year_ce();
        info.copyright = Some(format!(
            "Copyright {} The {} Project Authors ({})",
            year, self.config.name, self.config.source
        ));

        info.open_type_name_designer = Some(format!(
            "{} ({})",
            self.config.author.name, self.config.author.email
        ));
        info.open_type_name_designer_url = Some(self.config.author.url.clone());
        info.open_type_name_license = Some(self.config.license.text.clone());
        info.open_type_name_license_url = Some(self.config.license.url.clone());
        info.open_type_name_manufacturer = Some(self.config.manufacturer.name.clone());
        info.open_type_os2_vendor_id = Some(self.config.manufacturer.name.clone());
        info.open_type_name_manufacturer_url = Some(self.config.manufacturer.url.clone());

        info.open_type_os2_weight_class = Some(self.weight);
        info.open_type_os2_width_class = Some(match self.style.as_str() {
            "Expanded" => norad::fontinfo::Os2WidthClass::Expanded,
            "Condensed" => norad::fontinfo::Os2WidthClass::Condensed,
            _ => norad::fontinfo::Os2WidthClass::Normal,
        });

        let typo_ascender = (self.config.ascender * 1.25) as i32;
        let typo_descender = -((self.config.descender * 1.25) as i32);

        info.open_type_os2_typo_ascender = Some(typo_ascender);
        info.open_type_os2_typo_descender = Some(typo_descender);
        info.open_type_os2_typo_line_gap = Some(0);

        info.open_type_os2_win_ascent = Some(1032);
        info.open_type_os2_win_descent = Some(617);

        info.open_type_os2_selection = Some(vec![7]);

        info.open_type_os2_type = Some(vec![]);
        info.open_type_os2_code_page_ranges = Some(vec![0, 1]);
        info.open_type_os2_unicode_ranges = Some(vec![0, 1, 2, 3, 23]);
        info.open_type_os2_panose = Some(Os2Panose {
            // Panose family type.
            family_type: 0,
            // Panose serif style.
            serif_style: 0,
            // Panose weight.
            weight: 8,
            // Panose proportion.
            proportion: 3,
            // Panose contrast.
            contrast: 0,
            // Panose stroke variation.
            stroke_variation: 0,
            // Panose arm style.
            arm_style: 0,
            // Panose letterform.
            letterform: 0,
            // Panose midline.
            midline: 0,
            // Panose x-height.
            x_height: self.config.xheight as u32,
        });
        info.open_type_os2_family_class = Some(Os2FamilyClass {
            class_id: 0,
            subclass_id: 0,
        });

        info.open_type_hhea_ascender = Some(typo_ascender);
        info.open_type_hhea_descender = Some(typo_descender);
        info.open_type_hhea_line_gap = Some(0);

        info.postscript_blue_values = Some(vec![
            -20.,
            0.,
            self.config.xheight,
            self.config.xheight + 15.,
            self.config.cap_height,
            self.config.cap_height + 15.,
            self.config.ascender,
            self.config.ascender + 15.,
        ]);

        info.postscript_other_blues = Some(vec![
            (-self.config.descender),
            -self.config.descender + 12_f64,
        ]);

        info.postscript_slant_angle = Some(0.0);
        info.postscript_underline_position = Some(-200.);
        info.postscript_underline_thickness = Some(50.);

        info.guidelines = Some(vec![
            Guideline::new(
                norad::Line::Horizontal(self.config.xheight),
                Some(Name::new("xheight")?),
                None,
                None,
            ),
            Guideline::new(
                norad::Line::Horizontal(self.config.cap_height),
                Some(Name::new("capHeight")?),
                None,
                None,
            ),
            Guideline::new(
                norad::Line::Horizontal(self.config.xheight / 2.),
                Some(Name::new("mid")?),
                None,
                None,
            ),
        ]);

        info.open_type_gasp_range_records = Some(vec![GaspRangeRecord {
            range_max_ppem: 65535,
            range_gasp_behavior: vec![
                GaspBehavior::Gridfit,
                GaspBehavior::DoGray,
                GaspBehavior::SymmetricGridfit,
                GaspBehavior::SymmetricSmoothing,
            ],
        }]);

        info!("Font info set for {} {}", self.config.name, self.style);
        Ok(())
    }

    pub fn update_font_version(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let version_parts: Vec<&str> = self.config.version.split('.').collect();
        let major = version_parts[0].parse::<i32>()?;
        let minor = version_parts.get(1).unwrap_or(&"0").parse::<i32>()?;

        let info = &mut self.font.font_info;
        info.version_major = Some(major);
        info.version_minor = Some((minor * 1000) as u32);

        let now = Utc::now();
        info.open_type_name_version = Some(format!("Version {}.{:03}", major, minor));

        let ps_family = self.config.name.replace(" ", "");
        let ps_style = self.style.replace(" ", "");
        info.open_type_name_unique_id = Some(format!("{}-{}:{}", ps_family, ps_style, now.year()));

        info.open_type_head_created = Some(now.format("%Y/%m/%d %H:%M:%S").to_string());

        Ok(())
    }

    pub fn set_glyph_order(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let mut glyph_names: Vec<String> = self
            .font
            .default_layer()
            .iter()
            .map(|g| g.name().to_string())
            .collect();

        glyph_names.sort();

        self.font.lib.insert(
            "public.glyphOrder".to_string(),
            plist::Value::Array(glyph_names.into_iter().map(plist::Value::String).collect()),
        );

        Ok(())
    }
}
