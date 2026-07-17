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

    // Extra glyph name -> codepoint mappings for names outside AGL
    // (mirrors AGL2UV_EXTRA of the earlier Python pipeline)
    static ref EXTRA_MAPPINGS: HashMap<&'static str, u32> = {
        let mut m = HashMap::new();
        m.insert("notdef", 0);
        m.insert("uni25CC", 0x25CC);
        m.insert("onesuperior", 0x00B9);
        m.insert("twosuperior", 0x00B2);
        m.insert("threesuperior", 0x00B3);
        m.insert("foursuperior", 0x2074);
        m.insert("quotedblbasereversed", 0x2E42);
        m.insert("Acaron", 0x01CD);
        m.insert("acaron", 0x01CE);
        m.insert("Lcedilla", 0x013B);
        m.insert("lcedilla", 0x013C);
        m.insert("Kcedilla", 0x0136);
        m.insert("kcedilla", 0x0137);
        m.insert("Ncedilla", 0x0145);
        m.insert("Gcedilla", 0x0122);
        m.insert("gcedilla", 0x0123);
        m.insert("ncedilla", 0x0146);
        m.insert("Rcedilla", 0x0156);
        m.insert("rcedilla", 0x0157);
        m.insert("ringcmb", 0x030A);
        m.insert("tildecmb", 0x0303);
        m.insert("hungarumlautcmb", 0x030B);
        m.insert("cedillacmb", 0x0327);
        m.insert("acutecmb", 0x0301);
        m.insert("ogonekcmb", 0x0328);
        m.insert("dieresiscmb", 0x0308);
        m.insert("dotaccentcmb", 0x0307);
        m.insert("circumflexcmb", 0x0302);
        m.insert("commaturnedabovecmb", 0x0312);
        m.insert("caroncmb", 0x030C);
        m.insert("brevecmb", 0x0306);
        m.insert("macroncmb", 0x0304);
        m.insert("gravecmb", 0x0300);
        m.insert("commaturnedmod", 0x02BB);
        m.insert("commaaccent", 0x0326);
        m.insert("scommaaccent", 0x0219);
        m.insert("Scommaaccent", 0x0218);
        m.insert("Tcommaaccent", 0x021A);
        m.insert("tcommaaccent", 0x021B);
        m.insert("dotlessj", 0x0237);
        m.insert("jcaron", 0x01F0);
        m
    };

    // Codepoint -> glyph name overrides applied before the uniXXXX fallback
    // (mirrors UV2AGL_EXTRA of the earlier Python pipeline)
    static ref REVERSE_EXTRA_MAPPINGS: HashMap<u32, &'static str> = {
        let mut m = HashMap::new();
        m.insert(0x0326, "commaaccent");
        m.insert(0x0328, "ogonekcmb");
        m
    };

    // Malayalam character name mappings for the whole U+0D00..U+0D7F block.
    // Names follow the Unicode character name with the MALAYALAM/LETTER/VOWEL
    // words stripped (the convention of the earlier Python pipeline), so e.g.
    // U+0D02 MALAYALAM SIGN ANUSVARA is "anusvara" while U+0D3E MALAYALAM
    // VOWEL SIGN AA keeps its SIGN word as "sign_aa".
    static ref MALAYALAM_NAMES: HashMap<char, &'static str> = {
        let mut m = HashMap::new();
        m.insert('\u{0D00}', "combining_anusvara_above");
        m.insert('\u{0D01}', "candrabindu");
        m.insert('\u{0D02}', "anusvara");
        m.insert('\u{0D03}', "visarga");
        m.insert('\u{0D04}', "vedic_anusvara");
        m.insert('\u{0D05}', "a");
        m.insert('\u{0D06}', "aa");
        m.insert('\u{0D07}', "i");
        m.insert('\u{0D08}', "ii");
        m.insert('\u{0D09}', "u");
        m.insert('\u{0D0A}', "uu");
        m.insert('\u{0D0B}', "vocalic_r");
        m.insert('\u{0D0C}', "vocalic_l");
        m.insert('\u{0D0E}', "e");
        m.insert('\u{0D0F}', "ee");
        m.insert('\u{0D10}', "ai");
        m.insert('\u{0D12}', "o");
        m.insert('\u{0D13}', "oo");
        m.insert('\u{0D14}', "au");
        m.insert('\u{0D15}', "ka");
        m.insert('\u{0D16}', "kha");
        m.insert('\u{0D17}', "ga");
        m.insert('\u{0D18}', "gha");
        m.insert('\u{0D19}', "nga");
        m.insert('\u{0D1A}', "ca");
        m.insert('\u{0D1B}', "cha");
        m.insert('\u{0D1C}', "ja");
        m.insert('\u{0D1D}', "jha");
        m.insert('\u{0D1E}', "nya");
        m.insert('\u{0D1F}', "tta");
        m.insert('\u{0D20}', "ttha");
        m.insert('\u{0D21}', "dda");
        m.insert('\u{0D22}', "ddha");
        m.insert('\u{0D23}', "nna");
        m.insert('\u{0D24}', "ta");
        m.insert('\u{0D25}', "tha");
        m.insert('\u{0D26}', "da");
        m.insert('\u{0D27}', "dha");
        m.insert('\u{0D28}', "na");
        m.insert('\u{0D29}', "nnna");
        m.insert('\u{0D2A}', "pa");
        m.insert('\u{0D2B}', "pha");
        m.insert('\u{0D2C}', "ba");
        m.insert('\u{0D2D}', "bha");
        m.insert('\u{0D2E}', "ma");
        m.insert('\u{0D2F}', "ya");
        m.insert('\u{0D30}', "ra");
        m.insert('\u{0D31}', "rra");
        m.insert('\u{0D32}', "la");
        m.insert('\u{0D33}', "lla");
        m.insert('\u{0D34}', "llla");
        m.insert('\u{0D35}', "va");
        m.insert('\u{0D36}', "sha");
        m.insert('\u{0D37}', "ssa");
        m.insert('\u{0D38}', "sa");
        m.insert('\u{0D39}', "ha");
        m.insert('\u{0D3A}', "ttta");
        m.insert('\u{0D3B}', "vertical_bar_virama");
        m.insert('\u{0D3C}', "circular_virama");
        m.insert('\u{0D3D}', "avagraha");
        m.insert('\u{0D3E}', "sign_aa");
        m.insert('\u{0D3F}', "sign_i");
        m.insert('\u{0D40}', "sign_ii");
        m.insert('\u{0D41}', "sign_u");
        m.insert('\u{0D42}', "sign_uu");
        m.insert('\u{0D43}', "sign_vocalic_r");
        m.insert('\u{0D44}', "sign_vocalic_rr");
        m.insert('\u{0D46}', "sign_e");
        m.insert('\u{0D47}', "sign_ee");
        m.insert('\u{0D48}', "sign_ai");
        m.insert('\u{0D4A}', "sign_o");
        m.insert('\u{0D4B}', "sign_oo");
        m.insert('\u{0D4C}', "sign_au");
        m.insert('\u{0D4D}', "virama");
        m.insert('\u{0D4E}', "dot_reph");
        m.insert('\u{0D4F}', "para");
        m.insert('\u{0D54}', "chillu_m");
        m.insert('\u{0D55}', "chillu_y");
        m.insert('\u{0D56}', "chillu_lll");
        m.insert('\u{0D57}', "au_length_mark");
        m.insert('\u{0D58}', "fraction_one_one_hundred_and_sixtieth");
        m.insert('\u{0D59}', "fraction_one_fortieth");
        m.insert('\u{0D5A}', "fraction_three_eightieths");
        m.insert('\u{0D5B}', "fraction_one_twentieth");
        m.insert('\u{0D5C}', "fraction_one_tenth");
        m.insert('\u{0D5D}', "fraction_three_twentieths");
        m.insert('\u{0D5E}', "fraction_one_fifth");
        m.insert('\u{0D5F}', "archaic_ii");
        m.insert('\u{0D60}', "vocalic_rr");
        m.insert('\u{0D61}', "vocalic_ll");
        m.insert('\u{0D62}', "sign_vocalic_l");
        m.insert('\u{0D63}', "sign_vocalic_ll");
        m.insert('\u{0D66}', "digit_zero");
        m.insert('\u{0D67}', "digit_one");
        m.insert('\u{0D68}', "digit_two");
        m.insert('\u{0D69}', "digit_three");
        m.insert('\u{0D6A}', "digit_four");
        m.insert('\u{0D6B}', "digit_five");
        m.insert('\u{0D6C}', "digit_six");
        m.insert('\u{0D6D}', "digit_seven");
        m.insert('\u{0D6E}', "digit_eight");
        m.insert('\u{0D6F}', "digit_nine");
        m.insert('\u{0D70}', "number_ten");
        m.insert('\u{0D71}', "number_one_hundred");
        m.insert('\u{0D72}', "number_one_thousand");
        m.insert('\u{0D73}', "fraction_one_quarter");
        m.insert('\u{0D74}', "fraction_one_half");
        m.insert('\u{0D75}', "fraction_three_quarters");
        m.insert('\u{0D76}', "fraction_one_sixteenth");
        m.insert('\u{0D77}', "fraction_one_eighth");
        m.insert('\u{0D78}', "fraction_three_sixteenths");
        m.insert('\u{0D79}', "date_mark");
        m.insert('\u{0D7A}', "chillu_nn");
        m.insert('\u{0D7B}', "chillu_n");
        m.insert('\u{0D7C}', "chillu_rr");
        m.insert('\u{0D7D}', "chillu_l");
        m.insert('\u{0D7E}', "chillu_ll");
        m.insert('\u{0D7F}', "chillu_k");
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
        if let Some(name) = REVERSE_EXTRA_MAPPINGS.get(&codepoint) {
            return format!("{}{}", name, ext);
        }
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn malayalam_names_follow_unicode_convention() {
        assert_eq!(get_glyph_name("ം", "ml_"), "ml_anusvara");
        assert_eq!(get_glyph_name("ൻ", "ml_"), "ml_chillu_n");
        assert_eq!(get_glyph_name("ക്ക", "ml_"), "ml_ka_virama_ka");
        assert_eq!(get_glyph_name("ന്\u{200d}", "ml_"), "ml_chillu_n");
        assert_eq!(get_glyph_name("൦", "ml_"), "ml_digit_zero");
        assert_eq!(get_glyph_name("൏", "ml_"), "ml_para");
    }

    #[test]
    fn composite_names_resolve_to_unicode() {
        assert_eq!(get_unicode_for_name("ccedilla", false), Some(vec![0x00E7]));
        assert_eq!(get_unicode_for_name("aogonek", false), Some(vec![0x0105]));
        assert_eq!(
            get_unicode_for_name("hcircumflex", false),
            Some(vec![0x0125])
        );
        assert_eq!(get_unicode_for_name("acaron", false), Some(vec![0x01CE]));
        assert_eq!(
            get_unicode_for_name("scommaaccent", false),
            Some(vec![0x0219])
        );
        assert_eq!(get_unicode_for_name("acutecmb", false), Some(vec![0x0301]));
    }
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
        && *cp != 0
    {
        return Some(vec![*cp]);
    }

    None
}
