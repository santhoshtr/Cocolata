use crate::config::FontConfig;
use crate::features::{AnchorData, FeaturesData, MalayalamFeatures};
use crate::malayalam_font::MalayalamFont;
use log::{info, warn};
use minijinja::{Environment, context};
use norad::designspace::DesignSpaceDocument;
use std::collections::HashMap;
use std::path::{Path, PathBuf};

pub struct MalayalamVariableFont {
    pub config: FontConfig,
    pub weights: Vec<u32>,
    pub master_fonts: HashMap<u32, MalayalamFont>,
    pub feature_data_by_weight: HashMap<u32, FeaturesData>,
    pub weight_to_style: HashMap<u32, String>,
}

impl MalayalamVariableFont {
    pub fn new(config: FontConfig, designspace: &DesignSpaceDocument) -> Self {
        let mut weights = Vec::new();
        let mut weight_to_style = HashMap::new();

        // Extract weights and styles from designspace sources
        for source in &designspace.sources {
            if let Some(style) = &source.stylename {
                let weight = source
                    .location
                    .iter()
                    .find(|dim| dim.name.to_lowercase() == "weight")
                    .and_then(|dim| dim.xvalue)
                    .unwrap_or(400.0) as u32;

                if !weights.contains(&weight) {
                    weights.push(weight);
                    weight_to_style.insert(weight, style.clone());
                }
            }
        }

        weights.sort();

        Self {
            config,
            weights,
            master_fonts: HashMap::new(),
            feature_data_by_weight: HashMap::new(),
            weight_to_style,
        }
    }

    pub fn build_masters(
        &mut self,
        design_dirs: &HashMap<String, PathBuf>,
        output_dir: &Path,
    ) -> Result<(), Box<dyn std::error::Error>> {
        info!("Building master fonts for variable font...");

        for weight in &self.weights {
            let style = self
                .weight_to_style
                .get(weight)
                .ok_or(format!("No style found for weight {}", weight))?;

            info!("Building master for weight {} ({})...", weight, style);

            let design_dir = design_dirs
                .get(style)
                .ok_or(format!("No design directory for style {}", style))?;

            let mut font = MalayalamFont::new(self.config.clone(), style.clone(), *weight);
            font.build(design_dir)?;
            font.set_font_info()?;
            font.update_font_version()?;
            font.build_glyph_groups()?;
            font.build_kern()?;
            font.set_glyph_order()?;
            // Save the master UFO
            let output_path = output_dir.join(format!("{}-{}.ufo", self.config.name, style));

            if let Err(e) = font.write_glyphs(&output_path.join("glyphs")) {
                info!("write_glyphs failed: {}, falling back to font.save()", e);
                font.font.save(&output_path)?;
            }

            info!("✓ Master {} built successfully!", style);

            // Store the font instance
            self.master_fonts.insert(*weight, font);
        }

        // After building all masters, write unified features
        self.write_unified_features(output_dir)?;

        Ok(())
    }

    pub fn collect_feature_data(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        info!("Collecting feature data from all masters...");

        for (weight, font) in &self.master_fonts {
            let ml_features = MalayalamFeatures::new(font);
            self.feature_data_by_weight
                .insert(*weight, ml_features.prepare_template_data());
        }

        Ok(())
    }

    fn merge_top_anchors(
        &self,
        anchors_by_weight: &HashMap<u32, Vec<AnchorData>>,
    ) -> Vec<AnchorData> {
        // Group anchors by their base glyphs and class_name
        let mut anchor_groups: HashMap<(Vec<String>, String), HashMap<u32, (i32, i32)>> =
            HashMap::new();

        for (weight, anchors) in anchors_by_weight {
            for anchor in anchors {
                let mut bases_key = anchor.bases.clone();
                bases_key.sort();
                let key = (bases_key.clone(), anchor.class_name.clone());

                let positions = anchor_groups.entry(key).or_default();
                positions.insert(*weight, (anchor.x, anchor.y));
            }
        }

        // Convert to merged format
        let mut merged_anchors = Vec::new();
        for ((bases, class_name), positions) in anchor_groups {
            // Extract first bases from the sorted key for output
            let output_bases = if let Some((_, first_anchors)) = anchors_by_weight.iter().next() {
                first_anchors
                    .iter()
                    .find(|a| {
                        let mut a_bases = a.bases.clone();
                        a_bases.sort();
                        a_bases == bases && a.class_name == class_name
                    })
                    .map(|a| a.bases.clone())
                    .unwrap_or(bases.clone())
            } else {
                bases
            };

            let x_values: HashMap<u32, i32> =
                positions.iter().map(|(w, (x, _))| (*w, *x)).collect();
            let y_values: HashMap<u32, i32> =
                positions.iter().map(|(w, (_, y))| (*w, *y)).collect();

            merged_anchors.push(AnchorData {
                bases: output_bases,
                x: 0, // Will be ignored when anchor is Some
                y: 0, // Will be ignored when anchor is Some
                class_name,
                anchor: Some(self.format_variable_anchor(&x_values, &y_values)),
            });
        }

        merged_anchors
    }

    fn merge_bottom_anchors(
        &self,
        anchors_by_weight: &HashMap<u32, Vec<AnchorData>>,
    ) -> Vec<AnchorData> {
        // Group anchors by their base glyphs and class_name
        let mut anchor_groups: HashMap<(Vec<String>, String), HashMap<u32, (i32, i32)>> =
            HashMap::new();

        for (weight, anchors) in anchors_by_weight {
            for anchor in anchors {
                let mut bases_key = anchor.bases.clone();
                bases_key.sort();
                let key = (bases_key.clone(), anchor.class_name.clone());

                let positions = anchor_groups.entry(key).or_default();
                positions.insert(*weight, (anchor.x, anchor.y));
            }
        }

        // Convert to merged format
        let mut merged_anchors = Vec::new();
        for ((bases, class_name), positions) in anchor_groups {
            // Extract first bases from the sorted key for output
            let output_bases = if let Some((_, first_anchors)) = anchors_by_weight.iter().next() {
                first_anchors
                    .iter()
                    .find(|a| {
                        let mut a_bases = a.bases.clone();
                        a_bases.sort();
                        a_bases == bases && a.class_name == class_name
                    })
                    .map(|a| a.bases.clone())
                    .unwrap_or(bases.clone())
            } else {
                bases
            };

            let x_values: HashMap<u32, i32> =
                positions.iter().map(|(w, (x, _))| (*w, *x)).collect();
            let y_values: HashMap<u32, i32> =
                positions.iter().map(|(w, (_, y))| (*w, *y)).collect();

            merged_anchors.push(AnchorData {
                bases: output_bases,
                x: 0, // Will be ignored when anchor is Some
                y: 0, // Will be ignored when anchor is Some
                class_name,
                anchor: Some(self.format_variable_anchor(&x_values, &y_values)),
            });
        }

        merged_anchors
    }

    fn format_variable_anchor(
        &self,
        x_values: &HashMap<u32, i32>,
        y_values: &HashMap<u32, i32>,
    ) -> String {
        // Sort by weight
        let mut sorted_weights: Vec<u32> = x_values.keys().copied().collect();
        sorted_weights.sort();

        // Build x coordinates part
        let x_parts: Vec<String> = sorted_weights
            .iter()
            .map(|weight| format!("wght={}.0:{}", weight, x_values[weight]))
            .collect();

        // Build y coordinates part
        let y_parts: Vec<String> = sorted_weights
            .iter()
            .map(|weight| format!("wght={}.0:{}", weight, y_values[weight]))
            .collect();

        format!("<anchor ({}) ({})>", x_parts.join(" "), y_parts.join(" "))
    }

    fn merge_gpos_data(&self) -> Result<FeaturesData, Box<dyn std::error::Error>> {
        info!("Merging GPOS anchor data across weights...");

        // Collect top anchors by weight
        let top_anchors_by_weight: HashMap<u32, Vec<AnchorData>> = self
            .feature_data_by_weight
            .iter()
            .map(|(w, data)| (*w, data.top_anchors.clone()))
            .collect();

        // Collect bottom anchors by weight
        let bottom_anchors_by_weight: HashMap<u32, Vec<AnchorData>> = self
            .feature_data_by_weight
            .iter()
            .map(|(w, data)| (*w, data.bottom_anchors.clone()))
            .collect();

        // Merge anchors
        let merged_top_anchors = self.merge_top_anchors(&top_anchors_by_weight);
        let merged_bottom_anchors = self.merge_bottom_anchors(&bottom_anchors_by_weight);

        // Use Regular weight (400) as base for non-GPOS features
        let base_weight = if self.feature_data_by_weight.contains_key(&400) {
            400
        } else {
            *self.weights.first().ok_or("No weights available")?
        };

        if base_weight != 400 {
            warn!(
                "Regular weight (400) not found, using weight {} as base",
                base_weight
            );
        }

        let mut base_data = self
            .feature_data_by_weight
            .get(&base_weight)
            .ok_or(format!("No feature data for weight {}", base_weight))?
            .clone();

        // Replace GPOS data with merged versions
        base_data.top_anchors = merged_top_anchors;
        base_data.bottom_anchors = merged_bottom_anchors;

        Ok(base_data)
    }

    pub fn write_unified_features(
        &mut self,
        output_dir: &Path,
    ) -> Result<(), Box<dyn std::error::Error>> {
        info!("Writing unified features to all masters...");

        // Collect feature data from all masters
        self.collect_feature_data()?;

        // Prepare merged template data
        let template_data = self.merge_gpos_data()?;

        // Set up minijinja environment
        let template_content = include_str!("templates/features.fea.j2");
        let mut env = Environment::new();
        env.add_template("features.fea.j2", template_content)?;

        let template = env.get_template("features.fea.j2")?;

        // Render the template
        let features_code = template.render(context! {
            glyph_classes => template_data.glyph_classes,
            gdef => template_data.gdef,
            mark_classes => template_data.mark_classes,
            ligatures => template_data.ligatures,
            chillus => template_data.chillus,
            conjuncts => template_data.conjuncts,
            cons_signs => template_data.cons_signs,
            cons_signs_order_rules => template_data.cons_signs_order_rules,
            reph => template_data.reph,
            reph_conjuncts => template_data.reph_conjuncts,
            vowel_sign_rules => template_data.vowel_sign_rules,
            top_anchors => template_data.top_anchors,
            bottom_anchors => template_data.bottom_anchors,
            aam_rules => template_data.aam_rules,
            calt_rules => template_data.calt_rules,
            salts => template_data.salts,
            sups => template_data.sups,
            aalts => template_data.aalts,
        })?;

        // Write this feature file to each Master UFO directory
        for weight in &self.weights {
            let style = self
                .weight_to_style
                .get(weight)
                .ok_or(format!("No style found for weight {}", weight))?;

            let ufo_dir = output_dir.join(format!("{}-{}.ufo", self.config.name, style));
            let features_path = ufo_dir.join("features.fea");

            std::fs::write(&features_path, &features_code)
                .map_err(|e| format!("Failed to write features to {:?}: {}", features_path, e))?;

            info!("✓ Features written to {}", style);
        }

        Ok(())
    }
}
