use fontdrasil::agl::{agl_name_for_char, char_for_agl_name};
use lazy_static::lazy_static;
use std::collections::HashMap;

lazy_static! {
    // Malayalam-specific chillu normalization
    static ref CHILLU_NORMALIZE: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("ന്\u{200d}", "ൻ");
        m.insert("ര്\u{200d}", "ർ");
        m.insert("ല്\u{200d}", "ൽ");
        m.insert("ള്\u{200d}", "ൾ");
        m.insert("ണ്\u{200d}", "ൺ");
        m.insert("ഴ്\u{200d}", "ൖ");
        m.insert("ക്\u{200d}", "ൿ");
        m
    };

    // Extra glyph name mappings
    static ref EXTRA_MAPPINGS: HashMap<&'static str, u32> = {
        let mut m = HashMap::new();
        m.insert("notdef", 0);
        m.insert("uni25CC", 0x25CC);
        m.insert("onesuperior", 0x00B9);
        m.insert("twosuperior", 0x00B2);
        m.insert("threesuperior", 0x00B3);
        m.insert("foursuperior", 0x2074);
        m
    };

    // Malayalam character name mappings
    static ref MALAYALAM_NAMES: HashMap<char, &'static str> = {
        let mut m = HashMap::new();
        // Vowels
        m.insert('അ', "a");
        m.insert('ആ', "aa");
        m.insert('ഇ', "i");
        m.insert('ഈ', "ii");
        m.insert('ഉ', "u");
        m.insert('ഊ', "uu");
        m.insert('ഋ', "vocalic_r");
        m.insert('ൠ', "vocalic_rr");
        m.insert('ഌ', "vocalic_l");
        m.insert('ൡ', "vocalic_ll");
        m.insert('എ', "e");
        m.insert('ഏ', "ee");
        m.insert('ഐ', "ai");
        m.insert('ഒ', "o");
        m.insert('ഓ', "oo");
        m.insert('ഔ', "au");

        // Consonants
        m.insert('ക', "ka");
        m.insert('ഖ', "kha");
        m.insert('ഗ', "ga");
        m.insert('ഘ', "gha");
        m.insert('ങ', "nga");
        m.insert('ച', "ca");
        m.insert('ഛ', "cha");
        m.insert('ജ', "ja");
        m.insert('ഝ', "jha");
        m.insert('ഞ', "nya");
        m.insert('ട', "tta");
        m.insert('ഠ', "ttha");
        m.insert('ഡ', "dda");
        m.insert('ഢ', "ddha");
        m.insert('ണ', "nna");
        m.insert('ത', "ta");
        m.insert('ഥ', "tha");
        m.insert('ദ', "da");
        m.insert('ധ', "dha");
        m.insert('ന', "na");
        m.insert('പ', "pa");
        m.insert('ഫ', "pha");
        m.insert('ബ', "ba");
        m.insert('ഭ', "bha");
        m.insert('മ', "ma");
        m.insert('യ', "ya");
        m.insert('ര', "ra");
        m.insert('ല', "la");
        m.insert('വ', "va");
        m.insert('ശ', "sha");
        m.insert('ഷ', "ssa");
        m.insert('സ', "sa");
        m.insert('ഹ', "ha");
        m.insert('ള', "lla");
        m.insert('ഴ', "llla");
        m.insert('റ', "rra");

        // Signs
        m.insert('ം', "sign_anusvara");
        m.insert('ഃ', "sign_visarga");
        m.insert('്', "virama");
        m.insert('ാ', "sign_aa");
        m.insert('ി', "sign_i");
        m.insert('ീ', "sign_ii");
        m.insert('ു', "sign_u");
        m.insert('ൂ', "sign_uu");
        m.insert('ൃ', "sign_vocalic_r");
        m.insert('ൄ', "sign_vocalic_rr");
        m.insert('ൢ', "sign_vocalic_l");
        m.insert('ൣ', "sign_vocalic_ll");
        m.insert('െ', "sign_e");
        m.insert('േ', "sign_ee");
        m.insert('ൈ', "sign_ai");
        m.insert('ൊ', "sign_o");
        m.insert('ോ', "sign_oo");
        m.insert('ൌ', "sign_au");
        m.insert('ൗ', "au_length_mark");

        // Chillus
        m.insert('ൺ', "chillu_nna");
        m.insert('ൻ', "chillu_na");
        m.insert('ർ', "chillu_ra");
        m.insert('ൽ', "chillu_la");
        m.insert('ൾ', "chillu_lla");
        m.insert('ൿ', "chillu_ka");
        m.insert('ൖ', "chillu_llla");

        // Other marks
        m.insert('ൎ', "dot_reph");
        m.insert('ഀ', "combining_anusvara_above");
        m.insert('ഁ', "candrabindu");
        m.insert('◌', "dotted_circle");

        m
    };
}

pub fn get_glyph_name(text: &str, prefix: &str) -> String {
    if text.is_empty() {
        return text.to_string();
    }

    let parts: Vec<&str> = text.split('_').collect();
    let base = parts[0];
    let ext = if parts.len() > 1 {
        format!("_{}", parts[1..].join("_"))
    } else {
        String::new()
    };

    if base == "notdef" {
        return ".notdef".to_string();
    }

    // Get first character
    let first_char = match base.chars().next() {
        Some(c) => c,
        None => return text.to_string(),
    };
    let codepoint = first_char as u32;

    // Special case: ZWJ
    if codepoint == 0x200D {
        return "zwj".to_string();
    }

    // Malayalam range: U+0D00 to U+0D7F
    if (0x0D00..=0x0D7F).contains(&codepoint) {
        if base.chars().count() > 1 {
            // Multi-char Malayalam, normalize chillus
            let normalized = CHILLU_NORMALIZE.get(base).unwrap_or(&base);
            let parts: Vec<String> = normalized.chars().map(name_from_unicode_char).collect();
            return format!("{}{}{}", prefix, parts.join("_"), ext);
        } else {
            return format!("{}{}{}", prefix, name_from_unicode_char(first_char), ext);
        }
    }

    // Single character - use AGL
    if base.chars().count() == 1 {
        if let Some(name) = agl_name_for_char(first_char) {
            return format!("{}{}", name, ext);
        }
        // Check extra mappings
        if let Some(_cp) = EXTRA_MAPPINGS.get(base) {
            return format!("{}{}", base, ext);
        }
        // Fallback to uniXXXX format
        return format!("uni{:04X}{}", codepoint, ext);
    }

    // Multi-char or already a glyph name
    format!("{}{}", base, ext)
}

fn name_from_unicode_char(c: char) -> String {
    if let Some(name) = MALAYALAM_NAMES.get(&c) {
        name.to_string()
    } else {
        format!("u{:04X}", c as u32)
    }
}

#[derive(Debug, Clone)]
pub struct GlyphMetadata {
    pub name: String,
    pub variant: Option<String>,
}

pub fn parse_glyph_filename(filename: &str) -> GlyphMetadata {
    let parts: Vec<&str> = filename.split('.').collect();
    let mut meta = GlyphMetadata {
        name: parts[0].to_string(),
        variant: None,
    };

    if parts.len() > 1 {
        let variant = parts[1];
        if [
            "alt1", "alt2", "alt3", "narrow", "wide", "oldnum", "sups", "alt",
        ]
        .contains(&variant)
        {
            meta.variant = Some(variant.to_string());
        }
    }

    meta
}

pub fn get_unicode_for_name(name: &str, has_variant: bool) -> Option<Vec<u32>> {
    if has_variant {
        return None;
    }

    if name.chars().count() == 1 {
        return Some(vec![name.chars().next().unwrap() as u32]);
    }

    if let Some(c) = char_for_agl_name(name) {
        return Some(vec![c as u32]);
    }

    // Check extra mappings
    if let Some(cp) = EXTRA_MAPPINGS.get(name)
        && *cp != 0 {
            return Some(vec![*cp]);
        }

    None
}
