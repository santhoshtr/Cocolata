use crate::config::FontConfig;
use crate::features::{AnchorData, FeaturesData, MalayalamFeatures, MarkClass};
use crate::malayalam_font::MalayalamFont;
use log::{info, warn};
use minijinja::{Environment, value::Serde};
use norad::designspace::{DesignSpaceDocument, Source};
use std::collections::HashMap;
use std::path::{Path, PathBuf};

/// One designspace source: its style key and full axis location.
pub struct Master {
    /// Hyphenated style identifier (e.g. "Thin-Display"). Matches the
    /// config.yaml styles list, the sources/svgs/<style> directories and the
    /// UFO filenames.
    pub style: String,
    /// (axis tag, userspace value) for every designspace axis, in axis order.
    pub location: Vec<(String, f64)>,
}

impl Master {
    /// Location in FEA variable-value syntax: "wght=400,wdth=100,slnt=0,opsz=12"
    fn fea_location(&self) -> String {
        self.location
            .iter()
            .map(|(tag, value)| format!("{}={}", tag, value))
            .collect::<Vec<_>>()
            .join(",")
    }

    pub fn weight(&self) -> u32 {
        self.location
            .iter()
            .find(|(tag, _)| tag == "wght")
            .map(|(_, value)| *value as u32)
            .unwrap_or(400)
    }
}

/// Style key of a designspace source: the UFO filename stem without the family
/// prefix ("Malini-Thin-Display.ufo" -> "Thin-Display"). The stylename
/// attribute is unsuitable as a key: it can contain spaces while the SVG
/// directories and config styles are hyphenated.
pub fn style_key(family: &str, source: &Source) -> Result<String, String> {
    let stem = Path::new(&source.filename)
        .file_stem()
        .and_then(|s| s.to_str())
        .ok_or_else(|| format!("Invalid source filename {:?}", source.filename))?;

    stem.strip_prefix(&format!("{}-", family))
        .map(str::to_string)
        .ok_or_else(|| {
            format!(
                "Source filename {:?} does not follow the {}-<Style>.ufo convention",
                source.filename, family
            )
        })
}

pub fn masters_from_designspace(
    config: &FontConfig,
    designspace: &DesignSpaceDocument,
) -> Result<Vec<Master>, Box<dyn std::error::Error>> {
    let mut masters: Vec<Master> = Vec::new();

    for source in &designspace.sources {
        let style = style_key(&config.name, source)?;
        if masters.iter().any(|m| m.style == style) {
            return Err(format!("Duplicate master style '{}' in designspace", style).into());
        }

        // Full location in designspace axis order; missing dimensions take the
        // axis default.
        let location = designspace
            .axes
            .iter()
            .map(|axis| {
                let value = source
                    .location
                    .iter()
                    .find(|dim| dim.name == axis.name)
                    .and_then(|dim| dim.xvalue)
                    .unwrap_or(axis.default);
                (axis.tag.clone(), value)
            })
            .collect();

        masters.push(Master { style, location });
    }

    if masters.is_empty() {
        return Err("No sources found in designspace".into());
    }

    Ok(masters)
}

/// Per-master (x, y) positions keyed by master style
type PositionsByMaster = HashMap<String, (i32, i32)>;

pub struct MalayalamVariableFont {
    pub config: FontConfig,
    pub masters: Vec<Master>,
    /// Style of the master at the default location of every axis. Its feature
    /// data is the base for all non-GPOS (GSUB, GDEF, classes) sections.
    pub default_style: String,
    pub master_fonts: HashMap<String, MalayalamFont>,
    pub feature_data: HashMap<String, FeaturesData>,
}

impl MalayalamVariableFont {
    pub fn new(
        config: FontConfig,
        designspace: &DesignSpaceDocument,
    ) -> Result<Self, Box<dyn std::error::Error>> {
        let masters = masters_from_designspace(&config, designspace)?;

        let defaults: Vec<(String, f64)> = designspace
            .axes
            .iter()
            .map(|axis| (axis.tag.clone(), axis.default))
            .collect();

        let default_style = match masters.iter().find(|m| m.location == defaults) {
            Some(master) => master.style.clone(),
            None => {
                let fallback = masters[0].style.clone();
                warn!(
                    "No master at the designspace default location; using '{}' as base",
                    fallback
                );
                fallback
            }
        };

        Ok(Self {
            config,
            masters,
            default_style,
            master_fonts: HashMap::new(),
            feature_data: HashMap::new(),
        })
    }

    pub fn build_masters(
        &mut self,
        design_dirs: &HashMap<String, PathBuf>,
        output_dir: &Path,
    ) -> Result<(), Box<dyn std::error::Error>> {
        info!("Building master fonts for variable font...");

        for master in &self.masters {
            info!("Building master {}...", master.style);

            let design_dir = design_dirs
                .get(&master.style)
                .ok_or(format!("No design directory for style {}", master.style))?;

            let mut font =
                MalayalamFont::new(self.config.clone(), master.style.clone(), master.weight());
            font.build(design_dir)?;
            font.set_font_info()?;
            font.update_font_version()?;
            font.build_glyph_groups()?;
            font.build_kern()?;
            font.set_glyph_order()?;
            // Save the master UFO
            let output_path = output_dir.join(format!("{}-{}.ufo", self.config.name, master.style));
            font.font.save(&output_path)?;

            info!("✓ Master {} built successfully!", master.style);

            self.master_fonts.insert(master.style.clone(), font);
        }

        // After building all masters, write unified features
        self.write_unified_features(output_dir)?;

        Ok(())
    }

    pub fn collect_feature_data(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        info!("Collecting feature data from all masters...");

        for (style, font) in &self.master_fonts {
            let ml_features = MalayalamFeatures::new(font);
            self.feature_data
                .insert(style.clone(), ml_features.prepare_template_data());
        }

        Ok(())
    }

    /// Merge per-master anchors into variable anchors located at each master's
    /// full axis position.
    fn merge_anchors(
        &self,
        anchors_by_master: &HashMap<String, Vec<AnchorData>>,
    ) -> Vec<AnchorData> {
        // Group anchor positions by (base glyphs, mark class)
        let mut anchor_groups: HashMap<(Vec<String>, String), PositionsByMaster> = HashMap::new();

        for (style, anchors) in anchors_by_master {
            for anchor in anchors {
                let mut bases_key = anchor.bases.clone();
                bases_key.sort();
                let key = (bases_key, anchor.class_name.clone());

                let positions = anchor_groups.entry(key).or_default();
                positions.insert(style.clone(), (anchor.x, anchor.y));
            }
        }

        let default_anchors = anchors_by_master.get(&self.default_style);

        let mut merged_anchors = Vec::new();
        for ((bases, class_name), positions) in anchor_groups {
            // Preserve the base-glyph order the default master produced; the
            // group key had to be sorted to be comparable across masters.
            let output_bases = default_anchors
                .and_then(|anchors| {
                    anchors
                        .iter()
                        .find(|a| {
                            let mut a_bases = a.bases.clone();
                            a_bases.sort();
                            a_bases == bases && a.class_name == class_name
                        })
                        .map(|a| a.bases.clone())
                })
                .unwrap_or(bases);

            merged_anchors.push(AnchorData {
                bases: output_bases,
                x: 0, // Ignored when anchor is Some
                y: 0, // Ignored when anchor is Some
                class_name,
                anchor: Some(self.format_variable_anchor(&positions)),
            });
        }

        // HashMap grouping is unordered; sort for deterministic output.
        merged_anchors.sort_by(|a, b| (&a.class_name, &a.bases).cmp(&(&b.class_name, &b.bases)));

        merged_anchors
    }

    /// Merge per-master mark class positions into variable anchors, the same
    /// way base anchors are merged.
    fn merge_mark_classes(
        &self,
        marks_by_master: &HashMap<String, Vec<MarkClass>>,
    ) -> Vec<MarkClass> {
        let mut groups: HashMap<(String, String), PositionsByMaster> = HashMap::new();

        for (style, marks) in marks_by_master {
            for mark in marks {
                groups
                    .entry((mark.glyph.clone(), mark.class_name.clone()))
                    .or_default()
                    .insert(style.clone(), (mark.x, mark.y));
            }
        }

        let mut merged: Vec<MarkClass> = groups
            .into_iter()
            .map(|((glyph, class_name), positions)| MarkClass {
                glyph,
                class_name,
                x: 0, // Ignored when anchor is Some
                y: 0, // Ignored when anchor is Some
                anchor: Some(self.format_variable_anchor(&positions)),
            })
            .collect();

        // HashMap grouping is unordered; sort for deterministic output.
        merged.sort_by(|a, b| (&a.class_name, &a.glyph).cmp(&(&b.class_name, &b.glyph)));

        merged
    }

    fn format_variable_anchor(&self, positions: &PositionsByMaster) -> String {
        // Masters in designspace order; skip masters lacking this anchor.
        let located: Vec<(&Master, (i32, i32))> = self
            .masters
            .iter()
            .filter_map(|m| positions.get(&m.style).map(|pos| (m, *pos)))
            .collect();

        let x_parts: Vec<String> = located
            .iter()
            .map(|(m, (x, _))| format!("{}:{}", m.fea_location(), x))
            .collect();

        let y_parts: Vec<String> = located
            .iter()
            .map(|(m, (_, y))| format!("{}:{}", m.fea_location(), y))
            .collect();

        format!("<anchor ({}) ({})>", x_parts.join(" "), y_parts.join(" "))
    }

    fn merge_gpos_data(&self) -> Result<FeaturesData, Box<dyn std::error::Error>> {
        info!("Merging GPOS anchor data across masters...");

        let top_anchors_by_master: HashMap<String, Vec<AnchorData>> = self
            .feature_data
            .iter()
            .map(|(style, data)| (style.clone(), data.top_anchors.clone()))
            .collect();

        let bottom_anchors_by_master: HashMap<String, Vec<AnchorData>> = self
            .feature_data
            .iter()
            .map(|(style, data)| (style.clone(), data.bottom_anchors.clone()))
            .collect();

        let marks_by_master: HashMap<String, Vec<MarkClass>> = self
            .feature_data
            .iter()
            .map(|(style, data)| (style.clone(), data.mark_classes.clone()))
            .collect();

        let mut base_data = self
            .feature_data
            .get(&self.default_style)
            .ok_or(format!("No feature data for master {}", self.default_style))?
            .clone();

        // Replace GPOS data with merged versions
        base_data.top_anchors = self.merge_anchors(&top_anchors_by_master);
        base_data.bottom_anchors = self.merge_anchors(&bottom_anchors_by_master);
        base_data.mark_classes = self.merge_mark_classes(&marks_by_master);

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
        let features_code = template.render(Serde(&template_data))?;
        // Write this feature file to each Master UFO directory
        for master in &self.masters {
            let ufo_dir = output_dir.join(format!("{}-{}.ufo", self.config.name, master.style));
            let features_path = ufo_dir.join("features.fea");

            std::fs::write(&features_path, &features_code)
                .map_err(|e| format!("Failed to write features to {:?}: {}", features_path, e))?;

            info!("✓ Features written to {}", master.style);
        }

        Ok(())
    }
}
