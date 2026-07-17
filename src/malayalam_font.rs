use crate::config::FontConfig;
use crate::glyphnames::{get_glyph_name, get_unicode_for_name, parse_glyph_filename};
use log::{debug, info, warn};
use norad::{Font, Glyph};
use std::collections::HashMap;
use std::path::Path;
use svg2glif::{ConversionConfig, convert_svg_to_glyph};

pub struct MalayalamFont {
    pub font: Font,
    pub config: FontConfig,
    pub style: String,
    pub weight: u32,
    pub salts: HashMap<String, Vec<String>>,
    pub onums: HashMap<String, Vec<String>>,
    pub sups: HashMap<String, Vec<String>>,
}

impl MalayalamFont {
    pub fn new(config: FontConfig, style: String, weight: u32) -> Self {
        Self {
            font: Font::new(),
            config,
            style,
            weight,
            salts: HashMap::new(),
            onums: HashMap::new(),
            sups: HashMap::new(),
        }
    }

    pub fn build(&mut self, design_dir: &Path) -> Result<(), Box<dyn std::error::Error>> {
        info!("Building font from directory: {:?}", design_dir);

        self.add_empty_glyphs()?;
        self.process_svg_directory(design_dir)?;
        self.build_composites()?;

        Ok(())
    }

    fn add_empty_glyphs(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let empty_glyphs = vec![
            (".null", None),
            ("uni00A0", Some(0x00A0)),
            ("zwnj", Some(0x200C)),
            ("zwj", Some(0x200D)),
        ];

        let layer = self.font.default_layer_mut();
        for (name, unicode) in empty_glyphs {
            let mut glyph = Glyph::new(name);
            if let Some(cp) = unicode
                && let Some(c) = char::from_u32(cp)
            {
                glyph.codepoints = vec![c].into_iter().collect();
            }
            layer.insert_glyph(glyph);
        }

        Ok(())
    }

    fn process_svg_directory(
        &mut self,
        design_dir: &Path,
    ) -> Result<(), Box<dyn std::error::Error>> {
        let mut entries: Vec<_> = std::fs::read_dir(design_dir)?.collect();
        entries.sort_by_key(|e| e.as_ref().ok().map(|e| e.path()));

        for entry in entries {
            let entry = entry?;
            let path = entry.path();

            if path.extension().and_then(|s| s.to_str()) != Some("svg") {
                continue;
            }

            if let Err(e) = self.process_svg_file(&path) {
                warn!("Failed to process {:?}: {}", path, e);
            }
        }

        info!(
            "Processed SVG files, total glyphs: {}",
            self.font.default_layer().len()
        );
        Ok(())
    }

    fn process_svg_file(&mut self, svg_path: &Path) -> Result<(), Box<dyn std::error::Error>> {
        let filename = svg_path
            .file_stem()
            .and_then(|s| s.to_str())
            .ok_or("Invalid filename")?;

        let metadata = parse_glyph_filename(filename);
        let base_glyph_name = get_glyph_name(&metadata.name, "ml_");

        let glyph_name = if let Some(ref variant) = metadata.variant {
            format!("{}.{}", base_glyph_name, variant)
        } else {
            base_glyph_name.clone()
        };

        let unicodes = get_unicode_for_name(&metadata.name, metadata.variant.is_some());

        let mut config = ConversionConfig::new(
            self.config.units_per_em as f32,
            self.config.descender as f32,
        );

        if let Some(ref codes) = unicodes
            && let Some(&first) = codes.first()
        {
            config = config.with_unicode(format!("{:04X}", first));
        }

        config = config.with_name(glyph_name.clone());
        let mut glyph: Glyph = convert_svg_to_glyph(svg_path, &config)
            .map_err(|e| format!("Failed to convert {:?}: {}", svg_path, e))?;

        // Every SVG-sourced glyph gets a fallback "right" anchor at its
        // advance width. Composites attach through it (right-edge alignment)
        // when base and mark share no designed anchor.
        if !glyph
            .anchors
            .iter()
            .any(|a| a.name.as_ref().is_some_and(|n| n.as_str() == "right"))
        {
            glyph.anchors.push(norad::Anchor::new(
                glyph.width,
                0.0,
                Some(norad::Name::new("right")?),
                None,
                None,
            ));
        }

        if let Some(ref variant) = metadata.variant {
            match variant.as_str() {
                v if v.starts_with("alt") => {
                    self.salts
                        .entry(base_glyph_name.clone())
                        .or_default()
                        .push(glyph_name.clone());
                }
                "oldnum" => {
                    self.onums
                        .entry(base_glyph_name.clone())
                        .or_default()
                        .push(glyph_name.clone());
                }
                "sups" => {
                    self.sups
                        .entry(base_glyph_name.clone())
                        .or_default()
                        .push(glyph_name.clone());
                }
                _ => {}
            }
        }

        debug!("Processed: {} -> {}", filename, glyph_name);

        let layer = self.font.default_layer_mut();
        layer.insert_glyph(glyph);

        Ok(())
    }

    pub fn get_glyphs_from_class(&self, class_name: &str) -> Vec<String> {
        if let Some(class_def) = self.config.glyphs.classes.get(class_name) {
            return class_def.to_vec();
        }

        if let Some(class_def) = self.config.glyphs.kern.classes.get(class_name) {
            return class_def.to_vec();
        }

        vec![]
    }

    pub fn get_all_malayalam_bases(&self) -> Vec<String> {
        let mut bases = Vec::new();

        bases.extend(self.get_glyphs_from_class("ML_CONSONANTS"));
        bases.extend(self.get_glyphs_from_class("ML_REPH_CONJUNCTS"));
        bases.extend(self.get_glyphs_from_class("ML_CONS_CONJUNCTS"));
        bases.extend(self.get_glyphs_from_class("ML_LA_CONJUNCTS"));

        bases.push("്യ".to_string());

        bases
    }
}
