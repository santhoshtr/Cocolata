use crate::glyphnames::get_glyph_name;
use crate::malayalam_font::MalayalamFont;
use minijinja::{Environment, value::Serde};
use norad::Glyph;
use std::collections::{BTreeMap, HashMap};
use std::path::Path;

/// Handles OpenType feature generation for Malayalam fonts.
/// Works with an already-built UFO font to generate feature code.
pub struct MalayalamFeatures<'a> {
    pub font: &'a MalayalamFont,
}

impl<'a> MalayalamFeatures<'a> {
    pub fn new(font: &'a MalayalamFont) -> Self {
        Self { font }
    }

    /// Prepare all data needed for Jinja2 templates
    pub fn prepare_template_data(&self) -> FeaturesData {
        FeaturesData {
            glyph_classes: self.prepare_glyph_classes(),
            gdef: self.prepare_gdef_data(),
            mark_classes: self.prepare_mark_classes(),
            ligatures: self.prepare_ligature_data(),
            chillus: self.prepare_chillu_data(),
            conjuncts: self.prepare_conjunct_data(),
            cons_signs: self.prepare_cons_signs_data(),
            cons_signs_order_rules: self.prepare_cons_signs_order_rules(),
            reph: self.prepare_reph_data(),
            reph_conjuncts: self.prepare_reph_conjuncts_data(),
            vowel_sign_rules: self.prepare_vowel_sign_rules(),
            top_anchors: self.prepare_top_anchors(),
            bottom_anchors: self.prepare_bottom_anchors(),
            aam_rules: self.prepare_aam_rules(),
            calt_rules: self.prepare_calt_rules(),
            salts: self.font.salts.clone(),
            sups: self.font.sups.clone(),
            onums: self.font.onums.clone(),
            aalts: self.prepare_aalt_data(),
        }
    }

    /// Prepare glyph classes for templates
    fn prepare_glyph_classes(&self) -> BTreeMap<String, Vec<String>> {
        let mut classes = BTreeMap::new();

        for gclass in self.font.config.glyphs.classes.keys() {
            let glyph_names: Vec<String> = self
                .font
                .get_glyphs_from_class(gclass)
                .iter()
                .map(|g| get_glyph_name(g, "ml_"))
                .filter(|g| self.font.font.default_layer().contains_glyph(g))
                .collect();

            classes.insert(gclass.clone(), glyph_names);
        }

        classes
    }

    /// Prepare GDEF table data
    fn prepare_gdef_data(&self) -> GdefData {
        let mut bases = Vec::new();
        let mut ligatures = Vec::new();
        let marks = vec![
            "acutecmb",
            "brevecmb",
            "caroncmb",
            "cedillacmb",
            "circumflexcmb",
            "commaaccent",
            "commaturnedabovecmb",
            "dieresiscmb",
            "dotaccentcmb",
            "gravecmb",
            "hungarumlautcmb",
            "macroncmb",
            "ml_virama",
            "ml_candrabindu",
            "ml_circular_virama",
            "ml_combining_anusvara_above",
            "ml_vertical_bar_virama",
            "ml_dot_reph",
            "ogonekcmb",
            "ringcmb",
            "tildecmb",
        ];

        // Bases: consonants and Latin letters
        let base_classes = ["ML_CONSONANTS", "LC_ALL", "UC_ALL"];
        for class_name in &base_classes {
            for glyph in self.font.get_glyphs_from_class(class_name) {
                let glyph_name = get_glyph_name(&glyph, "ml_");
                if self.font.font.default_layer().contains_glyph(&glyph_name) {
                    bases.push(glyph_name);
                }
            }
        }

        // Ligatures: conjuncts and Latin extras
        let lig_classes = [
            "ML_REPH_CONJUNCTS",
            "ML_CONS_CONJUNCTS",
            "ML_LA_CONJUNCTS",
            "LATIN_EXTRA",
        ];
        for class_name in &lig_classes {
            for glyph in self.font.get_glyphs_from_class(class_name) {
                let glyph_name = get_glyph_name(&glyph, "ml_");
                if self.font.font.default_layer().contains_glyph(&glyph_name) {
                    ligatures.push(glyph_name);
                }
            }
        }

        let marks: Vec<String> = marks
            .iter()
            .filter(|m| self.font.font.default_layer().contains_glyph(m))
            .map(|s| s.to_string())
            .collect();

        GdefData {
            bases,
            ligatures,
            marks,
        }
    }

    /// Prepare mark class definitions. Positions come from each mark glyph's
    /// own anchor ("vc" for top marks, "bottom" for bottom marks), with the
    /// same fallbacks the anchor collection uses for base glyphs.
    fn prepare_mark_classes(&self) -> Vec<MarkClass> {
        let mut mark_classes =
            self.collect_mark_class("ML_TOP_MARKS", "vc", "vc_vc", |g| g.width / 2.0);
        // The "vc" anchor sets only the horizontal position. Top marks are
        // drawn at their final height, so they must not move vertically.
        for mark_class in &mut mark_classes {
            mark_class.y = 0;
        }
        mark_classes.extend(self.collect_mark_class(
            "ML_BOTTOM_MARKS",
            "bottom",
            "bottom_bottom",
            |g| g.width,
        ));
        mark_classes
    }

    fn collect_mark_class(
        &self,
        class_name: &str,
        anchor_name: &str,
        fea_class: &str,
        default_x: impl Fn(&Glyph) -> f64,
    ) -> Vec<MarkClass> {
        let mut marks = self.font.get_glyphs_from_class(class_name);
        marks.sort();

        let mut result = Vec::new();
        for mark in marks {
            let glyph_name = get_glyph_name(&mark, "ml_");
            let Some(glyph) = self.font.font.default_layer().get_glyph(&glyph_name) else {
                continue;
            };

            let (x, y) = glyph
                .anchors
                .iter()
                .find(|a| a.name.as_ref().is_some_and(|n| n.as_str() == anchor_name))
                .map(|a| (a.x, a.y))
                .unwrap_or((default_x(glyph), 0.0));

            result.push(MarkClass {
                glyph: glyph_name,
                x: x as i32,
                y: y as i32,
                class_name: fea_class.to_string(),
                anchor: None,
            });
        }

        result
    }

    /// Prepare ligature data
    fn prepare_ligature_data(&self) -> LigatureData {
        let ligatures = self.font.get_glyphs_from_class("LATIN_LIGATURES");
        let mut components_map = HashMap::new();
        components_map.insert("heart", vec!["less", "three"]);

        let mut latin_ligs = Vec::new();

        for ligature in ligatures {
            let components: Vec<String> = if let Some(parts) = components_map.get(ligature.as_str())
            {
                parts.iter().map(|p| get_glyph_name(p, "ml_")).collect()
            } else {
                ligature
                    .chars()
                    .map(|c| get_glyph_name(&c.to_string(), "ml_"))
                    .collect()
            };

            latin_ligs.push(LigatureRule {
                input: components,
                output: get_glyph_name(&ligature, "ml_"),
            });
        }

        LigatureData { latin: latin_ligs }
    }

    /// Prepare chillu data
    fn prepare_chillu_data(&self) -> Vec<SubstitutionRule> {
        let chillus = [
            "ന്\u{200d}",
            "ര്\u{200d}",
            "ല്\u{200d}",
            "ള്\u{200d}",
            "ണ്\u{200d}",
            "ഴ്\u{200d}",
            "ക്\u{200d}",
        ];

        chillus
            .iter()
            .map(|chillu| SubstitutionRule {
                input: chillu
                    .chars()
                    .map(|c| get_glyph_name(&c.to_string(), "ml_"))
                    .collect(),
                output: get_glyph_name(chillu, "ml_"),
            })
            .collect()
    }

    /// Prepare consonant signs data
    fn prepare_cons_signs_data(&self) -> Vec<SubstitutionRule> {
        let cons_signs = ["്യ", "്വ"];

        cons_signs
            .iter()
            .map(|cons_sign| SubstitutionRule {
                input: cons_sign
                    .chars()
                    .map(|c| get_glyph_name(&c.to_string(), "ml_"))
                    .collect(),
                output: get_glyph_name(cons_sign, "ml_"),
            })
            .collect()
    }

    /// Prepare consonant signs order fix rules
    fn prepare_cons_signs_order_rules(&self) -> Vec<OrderRule> {
        vec![
            OrderRule {
                pattern: "ml_ya ml_virama_ra'".to_string(),
            },
            OrderRule {
                pattern: "ml_virama_ya ml_virama_ra'".to_string(),
            },
            OrderRule {
                pattern: "ml_virama_va ml_virama_ra'".to_string(),
            },
        ]
    }

    /// Prepare reph data
    fn prepare_reph_data(&self) -> SubstitutionRule {
        let reph = "്ര";
        SubstitutionRule {
            input: reph
                .chars()
                .map(|c| get_glyph_name(&c.to_string(), "ml_"))
                .collect(),
            output: get_glyph_name(reph, "ml_"),
        }
    }

    /// Prepare reph conjuncts data
    fn prepare_reph_conjuncts_data(&self) -> Vec<SubstitutionRule> {
        let reph = "്ര";
        let reph_glyph_name = get_glyph_name(reph, "ml_");
        let mut reph_conjuncts = Vec::new();

        let reph_conjuncts_glyphs = self.font.get_glyphs_from_class("ML_REPH_CONJUNCTS");

        for ligature in reph_conjuncts_glyphs {
            let base_ligature = ligature.replace(reph, "");
            let ligature_glyph_name = get_glyph_name(&ligature, "ml_");

            if !self
                .font
                .font
                .default_layer()
                .contains_glyph(&ligature_glyph_name)
            {
                continue;
            }

            reph_conjuncts.push(SubstitutionRule {
                input: vec![
                    reph_glyph_name.clone(),
                    get_glyph_name(&base_ligature, "ml_"),
                ],
                output: ligature_glyph_name,
            });
        }

        reph_conjuncts
    }

    /// Prepare vowel sign substitution rules
    fn prepare_vowel_sign_rules(&self) -> Vec<SubstitutionRule> {
        let mut rules = Vec::new();
        let vowel_signs = self
            .font
            .config
            .glyphs
            .classes
            .get("ML_VOWEL_SIGNS_CONJOINING")
            .map(|v| v.to_vec())
            .unwrap_or_default();

        // Cache class lookups
        let mut ligatures = Vec::new();
        ligatures.extend(self.font.get_glyphs_from_class("ML_CONSONANTS"));
        ligatures.extend(self.font.get_glyphs_from_class("ML_REPH_CONJUNCTS"));
        ligatures.extend(self.font.get_glyphs_from_class("ML_CONS_CONJUNCTS"));
        ligatures.extend(self.font.get_glyphs_from_class("ML_LA_CONJUNCTS"));
        ligatures.push("്യ".to_string());
        ligatures.sort();

        for ligature in ligatures {
            let ligature_glyph_name = get_glyph_name(&ligature, "ml_");
            if !self
                .font
                .font
                .default_layer()
                .contains_glyph(&ligature_glyph_name)
            {
                continue;
            }

            for vowel_sign in &vowel_signs {
                let vowel_sign_name = get_glyph_name(vowel_sign, "_");
                let replacement_ligature = format!("{}{}", ligature_glyph_name, vowel_sign_name);

                if !self
                    .font
                    .font
                    .default_layer()
                    .contains_glyph(&replacement_ligature)
                {
                    continue;
                }

                rules.push(SubstitutionRule {
                    input: vec![
                        ligature_glyph_name.clone(),
                        get_glyph_name(vowel_sign, "ml_"),
                    ],
                    output: replacement_ligature,
                });
            }
        }

        rules
    }

    /// Prepare aam sign rules
    fn prepare_aam_rules(&self) -> Vec<SubstitutionRule> {
        vec![SubstitutionRule {
            input: vec![
                get_glyph_name("◌", "ml_"),
                get_glyph_name("ാ", "ml_"),
                get_glyph_name("ം", "ml_"),
            ],
            output: get_glyph_name("ാം", "ml_"),
        }]
    }

    /// Prepare contextual alternates rules
    fn prepare_calt_rules(&self) -> BTreeMap<String, Vec<CaltRule>> {
        let mut calt_rules = BTreeMap::new();

        let calts = &self.font.config.glyphs.calts;

        for (script, calt_defs) in calts {
            let mut rules = Vec::new();
            for calt_def in calt_defs {
                if calt_def.len() >= 3 {
                    rules.push(CaltRule {
                        precontext: get_glyph_name(&calt_def[0], "ml_"),
                        base: get_glyph_name(&calt_def[1], "ml_"),
                        replacement: format!(
                            "{}.{}",
                            get_glyph_name(&calt_def[1], "ml_"),
                            calt_def[2]
                        ),
                    });
                }
            }
            calt_rules.insert(script.clone(), rules);
        }

        calt_rules
    }

    /// Prepare conjunct data
    fn prepare_conjunct_data(&self) -> ConjunctData {
        let mut prevent_stack_contexts = HashMap::new();
        prevent_stack_contexts.insert("ഷ്ട", vec!["്ട"]);
        prevent_stack_contexts.insert("ഷ്പ", vec!["്ര"]);
        prevent_stack_contexts.insert("സ്പ", vec!["്ര"]);
        prevent_stack_contexts.insert("യ്ത", vec!["്ത"]);
        prevent_stack_contexts.insert("സ്ക", vec!["്ക", "്ര"]);
        prevent_stack_contexts.insert("സ്ത", vec!["്ത"]);
        prevent_stack_contexts.insert("പ്ത", vec!["്ത"]);
        prevent_stack_contexts.insert("സ്ന", vec!["്ന"]);
        prevent_stack_contexts.insert("ശ്ന", vec!["്ന"]);
        prevent_stack_contexts.insert("ല്പ", vec!["്പ"]);

        let mut basic_conjuncts = Vec::new();
        let mut conditional_conjuncts = Vec::new();
        let mut chaining_rules = Vec::new();

        // Cache class lookup
        let cons_conjuncts = self.font.get_glyphs_from_class("ML_CONS_CONJUNCTS");

        for conjunct in cons_conjuncts {
            let conjunct_glyph_name = get_glyph_name(&conjunct, "ml_");
            if !self
                .font
                .font
                .default_layer()
                .contains_glyph(&conjunct_glyph_name)
            {
                continue;
            }

            let conjunct_data = SubstitutionRule {
                input: conjunct
                    .chars()
                    .map(|c| get_glyph_name(&c.to_string(), "ml_"))
                    .collect(),
                output: conjunct_glyph_name.clone(),
            };

            if let Some(post_stack_conjs) = prevent_stack_contexts.get(conjunct.as_str()) {
                conditional_conjuncts.push(conjunct_data);

                let marked_glyphs: Vec<String> = conjunct
                    .chars()
                    .map(|c| format!("{}'", get_glyph_name(&c.to_string(), "ml_")))
                    .collect();

                // One ignore rule per preventing context
                let ignore_patterns: Vec<String> = post_stack_conjs
                    .iter()
                    .map(|post_stack_conj| {
                        let mut ignore_parts = marked_glyphs.clone();
                        ignore_parts.extend(
                            post_stack_conj
                                .chars()
                                .map(|c| get_glyph_name(&c.to_string(), "ml_")),
                        );
                        ignore_parts.join(" ")
                    })
                    .collect();

                // The lookup applies at the first glyph of the conjunct, where
                // the ligature substitution starts matching.
                let pattern = format!(
                    "{} lookup conditional_stack_lookup {}",
                    marked_glyphs[0],
                    marked_glyphs[1..].join(" ")
                );

                chaining_rules.push(ChainingRule {
                    ignore_patterns,
                    pattern,
                });
            } else {
                basic_conjuncts.push(conjunct_data);
            }
        }

        // LA conjuncts
        let mut la_conjuncts = Vec::new();
        let la_conjuncts_glyphs = self.font.get_glyphs_from_class("ML_LA_CONJUNCTS");

        for conjunct in la_conjuncts_glyphs {
            let conjunct_glyph_name = get_glyph_name(&conjunct, "ml_");
            if self
                .font
                .font
                .default_layer()
                .contains_glyph(&conjunct_glyph_name)
            {
                la_conjuncts.push(SubstitutionRule {
                    input: conjunct
                        .chars()
                        .map(|c| get_glyph_name(&c.to_string(), "ml_"))
                        .collect(),
                    output: conjunct_glyph_name,
                });
            }
        }

        // Fixup rules for vowel signs
        let mut fixup_rules = Vec::new();
        let mut split_rules = Vec::new();
        let vowel_signs = self
            .font
            .config
            .glyphs
            .classes
            .get("ML_VOWEL_SIGNS_CONJOINING")
            .map(|v| v.to_vec())
            .unwrap_or_default();

        // Cache class lookups
        let mut all_conjuncts = Vec::new();
        all_conjuncts.extend(self.font.get_glyphs_from_class("ML_CONS_CONJUNCTS"));
        all_conjuncts.extend(self.font.get_glyphs_from_class("ML_LA_CONJUNCTS"));
        all_conjuncts.sort();

        // Pre-cache vowel sign names
        let vowel_sign_names: Vec<String> = vowel_signs
            .iter()
            .map(|vs| get_glyph_name(vs, "ml_"))
            .collect();

        for ligature in all_conjuncts {
            let ligature_glyph_name = get_glyph_name(&ligature, "ml_");
            if !self
                .font
                .font
                .default_layer()
                .contains_glyph(&ligature_glyph_name)
            {
                continue;
            }

            let mut missing_vowels = Vec::new();
            let mut missing_vowel_names = Vec::new();
            for (i, vowel_sign) in vowel_signs.iter().enumerate() {
                let ligature_vowel = format!("{}{}", ligature, vowel_sign);
                let replacement_ligature_glyphname = get_glyph_name(&ligature_vowel, "ml_");
                if !self
                    .font
                    .font
                    .default_layer()
                    .contains_glyph(&replacement_ligature_glyphname)
                {
                    missing_vowels.push(vowel_sign.clone());
                    missing_vowel_names.push(vowel_sign_names[i].clone());
                }
            }

            if !missing_vowels.is_empty() {
                // Find the largest trailing sequence that supports the first
                // missing vowel; the ligature splits in front of it.
                let mut parts = Vec::new();
                let mut seq = String::new();
                let mut largest_seq = seq.clone();
                let first_missing_vowel = &missing_vowels[0];

                for c in ligature.chars().rev() {
                    seq = format!("{}{}", c, seq);
                    let test_glyph =
                        get_glyph_name(&format!("{}{}", seq, first_missing_vowel), "ml_");
                    if self.font.font.default_layer().contains_glyph(&test_glyph) {
                        largest_seq = seq.clone();
                    }
                }

                // Create split rule
                let ligature_chars: Vec<char> = ligature.chars().collect();

                for c in ligature_chars
                    .iter()
                    .take(ligature.chars().count() - largest_seq.chars().count())
                {
                    parts.push(c.to_string());
                }
                if !largest_seq.is_empty() {
                    parts.push(largest_seq);
                }

                split_rules.push(SplitRule {
                    input: ligature_glyph_name.clone(),
                    output: parts.iter().map(|p| get_glyph_name(p, "ml_")).collect(),
                });

                // When every conjoining vowel sign is missing, reference the
                // class instead of listing all its members.
                let context = if missing_vowels.len() == vowel_signs.len() {
                    "@ML_VOWEL_SIGNS_CONJOINING".to_string()
                } else {
                    format!("[{}]", missing_vowel_names.join(" "))
                };

                fixup_rules.push(FixupRule {
                    input: get_glyph_name(&ligature, "ml_"),
                    context,
                });
            }
        }

        ConjunctData {
            basic: basic_conjuncts,
            conditional: conditional_conjuncts,
            chaining_rules,
            la_conjuncts,
            fixup_rules,
            split_rules,
        }
    }

    /// Prepare access-all-alternates data: every glyph with stylistic
    /// alternates gets an aalt rule listing them all.
    fn prepare_aalt_data(&self) -> Vec<AaltRule> {
        self.font
            .salts
            .iter()
            .map(|(base, alts)| AaltRule {
                base: base.clone(),
                alts: alts.clone(),
            })
            .collect()
    }

    /// Prepare top anchor positioning data
    fn prepare_top_anchors(&self) -> Vec<AnchorData> {
        let visual_center_anchor_name = "vc";

        // Cache class lookups
        let top_marks = self.font.get_glyphs_from_class("ML_TOP_MARKS");
        let top_mark_glyphs: Vec<String> =
            top_marks.iter().map(|c| get_glyph_name(c, "ml_")).collect();

        let mut letters_with_marks = Vec::new();
        letters_with_marks.extend(self.font.get_glyphs_from_class("ML_CONSONANTS"));
        letters_with_marks.extend(self.font.get_glyphs_from_class("ML_REPH_CONJUNCTS"));
        letters_with_marks.extend(self.font.get_glyphs_from_class("ML_CONS_CONJUNCTS"));
        letters_with_marks.extend(self.font.get_glyphs_from_class("ML_LA_CONJUNCTS"));
        letters_with_marks.extend(top_marks);
        letters_with_marks.push("\u{25cc}".to_string()); // Dotted circle
        letters_with_marks.sort();

        let mut anchors: HashMap<String, HashMap<String, (i32, i32)>> = HashMap::new();
        let vowel_signs = self
            .font
            .config
            .glyphs
            .classes
            .get("ML_VOWEL_SIGNS_CONJOINING")
            .map(|v| v.to_vec())
            .unwrap_or_default();

        for letter in &letters_with_marks {
            let glyph_name = get_glyph_name(letter, "ml_");
            if !self.font.font.default_layer().contains_glyph(&glyph_name) {
                continue;
            }

            if let Some(glyph) = self.font.font.default_layer().get_glyph(&glyph_name) {
                for anchor in &glyph.anchors {
                    if let Some(name) = &anchor.name
                        && name.as_str() == visual_center_anchor_name
                    {
                        let mut anchor_map = HashMap::new();
                        anchor_map.insert(
                            visual_center_anchor_name.to_string(),
                            (anchor.x as i32, anchor.y as i32),
                        );
                        anchors.insert(glyph.name().to_string(), anchor_map);
                    }
                }

                if !anchors.contains_key(glyph.name().as_str()) {
                    let mut anchor_map = HashMap::new();
                    anchor_map.insert(
                        visual_center_anchor_name.to_string(),
                        ((glyph.width / 2.0) as i32, 0),
                    );
                    anchors.insert(glyph.name().to_string(), anchor_map);
                }
            }
        }

        let mut top_bases: HashMap<String, (i32, i32)> = HashMap::new();
        let mut top_marks_map: HashMap<String, (i32, i32)> = HashMap::new();

        for (glyphname, anchors_dict) in anchors {
            for (anchorname, position) in anchors_dict {
                if anchorname == visual_center_anchor_name {
                    if top_mark_glyphs.contains(&glyphname) {
                        top_marks_map.insert(glyphname.clone(), position);
                    } else {
                        top_bases.insert(glyphname.clone(), position);
                    }
                }
            }
        }

        let mut template_data = Vec::new();

        for letter in letters_with_marks {
            let glyph_name = get_glyph_name(&letter, "ml_");
            if !self.font.font.default_layer().contains_glyph(&glyph_name) {
                continue;
            }

            if let Some(anchor) = top_bases.get(&glyph_name) {
                let base_set = self.get_base_set(&glyph_name, &vowel_signs);
                // Only x: the y of a base "vc" anchor is not a real height.
                template_data.push(AnchorData {
                    bases: base_set,
                    x: anchor.0,
                    y: 0,
                    class_name: "vc_vc".to_string(),
                    anchor: None,
                });
            }
        }

        template_data
    }

    fn get_base_set(&self, base_glyph_name: &str, vowel_signs: &[String]) -> Vec<String> {
        let mut base_set = vec![base_glyph_name.to_string()];

        for vowel_sign in vowel_signs {
            let letter_with_vowel =
                format!("{}{}", base_glyph_name, get_glyph_name(vowel_sign, "_"));
            if self
                .font
                .font
                .default_layer()
                .contains_glyph(&letter_with_vowel)
            {
                base_set.push(letter_with_vowel);
            }
        }

        base_set
    }

    /// Prepare bottom anchor positioning data
    fn prepare_bottom_anchors(&self) -> Vec<AnchorData> {
        let bbvm_anchor_name = "bottom";

        // Cache class lookups
        let consonants = self.font.get_glyphs_from_class("ML_CONSONANTS");
        let bottom_marks = self.font.get_glyphs_from_class("ML_BOTTOM_MARKS");
        let mut letters_with_marks = Vec::new();
        letters_with_marks.extend(consonants);
        letters_with_marks.extend(bottom_marks);
        letters_with_marks.sort();

        let mut anchors: HashMap<String, HashMap<String, (i32, i32)>> = HashMap::new();

        for letter in &letters_with_marks {
            let glyph_name = get_glyph_name(letter, "ml_");
            if !self.font.font.default_layer().contains_glyph(&glyph_name) {
                continue;
            }

            if let Some(glyph) = self.font.font.default_layer().get_glyph(&glyph_name) {
                for anchor in &glyph.anchors {
                    if let Some(name) = &anchor.name
                        && name.as_str() == bbvm_anchor_name
                    {
                        let mut anchor_map = HashMap::new();
                        anchor_map.insert(
                            bbvm_anchor_name.to_string(),
                            (anchor.x as i32, anchor.y as i32),
                        );
                        anchors.insert(glyph.name().to_string(), anchor_map);
                    }
                }

                if !anchors.contains_key(glyph.name().as_str()) {
                    let mut anchor_map = HashMap::new();
                    anchor_map.insert(bbvm_anchor_name.to_string(), (glyph.width as i32, 0));
                    anchors.insert(glyph.name().to_string(), anchor_map);
                }
            }
        }

        let mut template_data = Vec::new();

        for letter in letters_with_marks {
            let glyph_name = get_glyph_name(&letter, "ml_");
            if !self.font.font.default_layer().contains_glyph(&glyph_name) {
                continue;
            }

            if let Some(anchor_dict) = anchors.get(&glyph_name)
                && let Some(anchor) = anchor_dict.get(bbvm_anchor_name)
            {
                template_data.push(AnchorData {
                    bases: vec![glyph_name],
                    x: anchor.0,
                    y: anchor.1,
                    class_name: "bottom_bottom".to_string(),
                    anchor: None,
                });
            }
        }

        template_data
    }

    /// Build OpenType features using Jinja2 templates and write to font or file
    pub fn write_features(
        &self,
        output_path: Option<&Path>,
    ) -> Result<String, Box<dyn std::error::Error>> {
        // Prepare data for templates
        let template_data = self.prepare_template_data();

        // Set up minijinja environment
        let template_content = include_str!("templates/features.fea.j2");
        let mut env = Environment::new();
        env.add_template("features.fea.j2", template_content)?;

        let template = env.get_template("features.fea.j2")?;

        // Render the template
        let features_code = template.render(Serde(&template_data))?;

        if let Some(path) = output_path {
            std::fs::write(path, &features_code)
                .map_err(|e| format!("Failed to write features file to {:?}: {}", path, e))?;
        }

        Ok(features_code)
    }
}

// Main data structure for template rendering
#[derive(Debug, Clone, serde::Serialize)]
pub struct FeaturesData {
    pub glyph_classes: BTreeMap<String, Vec<String>>,
    pub gdef: GdefData,
    pub mark_classes: Vec<MarkClass>,
    pub ligatures: LigatureData,
    pub chillus: Vec<SubstitutionRule>,
    pub conjuncts: ConjunctData,
    pub cons_signs: Vec<SubstitutionRule>,
    pub cons_signs_order_rules: Vec<OrderRule>,
    pub reph: SubstitutionRule,
    pub reph_conjuncts: Vec<SubstitutionRule>,
    pub vowel_sign_rules: Vec<SubstitutionRule>,
    pub top_anchors: Vec<AnchorData>,
    pub bottom_anchors: Vec<AnchorData>,
    pub aam_rules: Vec<SubstitutionRule>,
    pub calt_rules: BTreeMap<String, Vec<CaltRule>>,
    pub salts: BTreeMap<String, Vec<String>>,
    pub sups: BTreeMap<String, Vec<String>>,
    pub onums: BTreeMap<String, Vec<String>>,
    pub aalts: Vec<AaltRule>,
}

// Data structures for template rendering
#[derive(Debug, Clone, serde::Serialize)]
pub struct GdefData {
    pub bases: Vec<String>,
    pub ligatures: Vec<String>,
    pub marks: Vec<String>,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct MarkClass {
    pub glyph: String,
    pub x: i32,
    pub y: i32,
    pub class_name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub anchor: Option<String>,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct LigatureData {
    pub latin: Vec<LigatureRule>,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct LigatureRule {
    pub input: Vec<String>,
    pub output: String,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct SubstitutionRule {
    pub input: Vec<String>,
    pub output: String,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct OrderRule {
    pub pattern: String,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct ChainingRule {
    pub ignore_patterns: Vec<String>,
    pub pattern: String,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct FixupRule {
    pub input: String,
    pub context: String,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct SplitRule {
    pub input: String,
    pub output: Vec<String>,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct ConjunctData {
    pub basic: Vec<SubstitutionRule>,
    pub conditional: Vec<SubstitutionRule>,
    pub chaining_rules: Vec<ChainingRule>,
    pub la_conjuncts: Vec<SubstitutionRule>,
    pub fixup_rules: Vec<FixupRule>,
    pub split_rules: Vec<SplitRule>,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct CaltRule {
    pub precontext: String,
    pub base: String,
    pub replacement: String,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct AaltRule {
    pub base: String,
    pub alts: Vec<String>,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct AnchorData {
    pub bases: Vec<String>,
    pub x: i32,
    pub y: i32,
    pub class_name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub anchor: Option<String>,
}
