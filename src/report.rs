//! Vertical-metrics report, a Rust port of `font-line report`
//! (https://github.com/source-foundry/font-line).
//!
//! Prints the head/OS-2/hhea vertical metrics, the ascent-to-descent and delta
//! calculations, baseline-to-baseline distances, the USE_TYPO_METRICS bit, and
//! the per-em ratios.

use std::path::Path;

use fontations::read::tables::os2::SelectionFlags;
use fontations::read::{FontRef, TableProvider};
use fontations::skrifa::instance::{Location, Size};
use fontations::skrifa::string::StringId;
use fontations::skrifa::{GlyphId, MetadataProvider};
use sha1::{Digest, Sha1};

pub fn report(fonts: &[std::path::PathBuf]) -> Result<(), Box<dyn std::error::Error>> {
    for path in fonts {
        println!("{}", font_report(path)?);
    }
    Ok(())
}

fn font_report(path: &Path) -> Result<String, Box<dyn std::error::Error>> {
    let data = std::fs::read(path)?;
    let sha1 = {
        let mut hasher = Sha1::new();
        hasher.update(&data);
        hasher
            .finalize()
            .iter()
            .map(|b| format!("{b:02x}"))
            .collect::<String>()
    };

    let font = FontRef::new(&data)?;
    let head = font.head()?;
    let hhea = font.hhea()?;
    let os2 = font.os2()?;

    let upm = head.units_per_em() as i32;
    let ymax = head.y_max() as i32;
    let ymin = head.y_min() as i32;

    let typo_asc = os2.s_typo_ascender() as i32;
    let typo_desc = os2.s_typo_descender() as i32;
    let typo_lg = os2.s_typo_line_gap() as i32;
    let win_asc = os2.us_win_ascent() as i32;
    let win_desc = os2.us_win_descent() as i32;
    let hhea_asc = hhea.ascender().to_i16() as i32;
    let hhea_desc = hhea.descender().to_i16() as i32;
    let hhea_lg = hhea.line_gap().to_i16() as i32;

    let cap_height = os2
        .s_cap_height()
        .map(|v| v.to_string())
        .unwrap_or_else(|| "---- (OS/2 table does not contain sCapHeight record)".to_string());
    let x_height = os2
        .sx_height()
        .map(|v| v.to_string())
        .unwrap_or_else(|| "---- (OS/2 table does not contain sxHeight record)".to_string());

    let version = font
        .name()?
        .name_record()
        .iter()
        .find(|r| r.name_id() == StringId::VERSION_STRING)
        .and_then(|r| r.string(font.name().ok()?.string_data()).ok())
        .map(|s| s.chars().collect::<String>())
        .unwrap_or_default();

    // Calculated values (match font-line/metrics.py)
    let typo_total_height = typo_asc + typo_desc.abs();
    let win_total_height = win_asc + win_desc;
    let hhea_total_height = hhea_asc + hhea_desc.abs();

    let hhea_btb = hhea_total_height + hhea_lg;
    let typo_btb = typo_total_height + typo_lg;
    let win_external_leading = (hhea_lg - ((win_asc + win_desc) - (hhea_asc - hhea_desc))).max(0);
    let win_btb = win_asc + win_desc + win_external_leading;

    let use_typo_metrics = os2
        .fs_selection()
        .contains(SelectionFlags::USE_TYPO_METRICS);

    let (highest, lowest) = glyph_extremes(&font);

    let rule = ":".repeat(50);
    let mut r: Vec<String> = Vec::new();
    r.push(format!("=== {} ===", path.display()));
    r.push(version);
    r.push(format!("SHA1: {sha1}"));
    r.push(String::new());

    r.push(rule.clone());
    r.push("  Metrics".to_string());
    r.push(rule.clone());
    r.push(format!("[head] Units per Em:   {upm}"));
    r.push(format!("[head] yMax:           {ymax}"));
    r.push(format!("[head] yMin:          {ymin}"));
    r.push(format!(
        "[glyf] Max ascent:     {} ({} @ {})",
        highest.y, highest.glyph, highest.location
    ));
    r.push(format!(
        "[glyf] Max descent:   {} ({} @ {})",
        lowest.y, lowest.glyph, lowest.location
    ));
    r.push(format!("[OS/2] CapHeight:      {cap_height}"));
    r.push(format!("[OS/2] xHeight:        {x_height}"));
    r.push(format!("[OS/2] TypoAscender:   {typo_asc}"));
    r.push(format!("[OS/2] TypoDescender: {typo_desc}"));
    r.push(format!("[OS/2] WinAscent:      {win_asc}"));
    r.push(format!("[OS/2] WinDescent:     {win_desc}"));
    r.push(format!("[hhea] Ascent:         {hhea_asc}"));
    r.push(format!("[hhea] Descent:       {hhea_desc}"));
    r.push(String::new());
    r.push(format!("[hhea] LineGap:        {hhea_lg}"));
    r.push(format!("[OS/2] TypoLineGap:    {typo_lg}"));
    r.push(String::new());

    r.push(rule.clone());
    r.push("  Ascent to Descent Calculations".to_string());
    r.push(rule.clone());
    r.push(format!(
        "[hhea] Ascent to Descent:              {hhea_total_height}"
    ));
    r.push(format!(
        "[OS/2] TypoAscender to TypoDescender:  {typo_total_height}"
    ));
    r.push(format!(
        "[OS/2] WinAscent to WinDescent:        {win_total_height}"
    ));
    r.push(String::new());

    r.push(rule.clone());
    r.push("  Delta Values".to_string());
    r.push(rule.clone());
    r.push(format!(
        "[hhea] Ascent to [OS/2] TypoAscender:       {}",
        hhea_asc - typo_asc
    ));
    r.push(format!(
        "[hhea] Descent to [OS/2] TypoDescender:     {}",
        typo_desc - hhea_desc
    ));
    r.push(format!(
        "[OS/2] WinAscent to [OS/2] TypoAscender:    {}",
        win_asc - typo_asc
    ));
    r.push(format!(
        "[OS/2] WinDescent to [OS/2] TypoDescender:  {}",
        win_desc + typo_desc
    ));
    r.push(String::new());

    r.push(rule.clone());
    r.push("  Baseline to Baseline Distances".to_string());
    r.push(rule.clone());
    r.push(format!("hhea metrics: {hhea_btb}"));
    r.push(format!("typo metrics: {typo_btb}"));
    r.push(format!("win metrics:  {win_btb}"));
    r.push(String::new());
    r.push(format!(
        "[OS/2] fsSelection USE_TYPO_METRICS bit set: {}",
        if use_typo_metrics { "True" } else { "False" }
    ));
    r.push(String::new());

    r.push(rule.clone());
    r.push("  Ratios".to_string());
    r.push(rule.clone());
    r.push(format!(
        "hhea metrics / UPM:  {:.2}",
        hhea_btb as f64 / upm as f64
    ));
    r.push(format!(
        "typo metrics / UPM:  {:.2}",
        typo_btb as f64 / upm as f64
    ));
    r.push(format!(
        "win metrics  / UPM:  {:.2}",
        win_btb as f64 / upm as f64
    ));

    Ok(r.join("\n"))
}

/// The y value of a glyph extreme, with the glyph and the location.
struct GlyphExtreme {
    y: f32,
    glyph: String,
    location: String,
}

/// Find the glyph that goes highest and the glyph that goes lowest, at the
/// default location and at all named instances. `head` gives only the
/// default location. Glyph points move linearly between masters, so the
/// extremes are at master locations; in this font they are the instances.
fn glyph_extremes(font: &FontRef) -> (GlyphExtreme, GlyphExtreme) {
    let axes = font.axes();
    let label = |coords: Vec<f32>| {
        let label = axes
            .iter()
            .zip(coords)
            .map(|(axis, value)| format!("{}={value}", axis.tag()))
            .collect::<Vec<_>>()
            .join(",");
        if label.is_empty() {
            "default".to_string()
        } else {
            label
        }
    };

    let mut locations = vec![(
        label(axes.iter().map(|a| a.default_value()).collect()),
        Location::default(),
    )];
    for instance in font.named_instances().iter() {
        locations.push((label(instance.user_coords().collect()), instance.location()));
    }

    let names = font.glyph_names();
    let extreme = |y: f32, gid: GlyphId, location: &str| GlyphExtreme {
        y,
        glyph: names
            .get(gid)
            .map(|n| n.to_string())
            .unwrap_or_else(|| gid.to_string()),
        location: location.to_string(),
    };
    let mut highest = extreme(f32::MIN, GlyphId::NOTDEF, "");
    let mut lowest = extreme(f32::MAX, GlyphId::NOTDEF, "");
    for (location_label, location) in &locations {
        let metrics = font.glyph_metrics(Size::unscaled(), location);
        for gid in 0..metrics.glyph_count() {
            let gid = GlyphId::new(gid);
            let Some(bounds) = metrics.bounds(gid) else {
                continue;
            };
            if bounds.y_max > highest.y {
                highest = extreme(bounds.y_max, gid, location_label);
            }
            if bounds.y_min < lowest.y {
                lowest = extreme(bounds.y_min, gid, location_label);
            }
        }
    }
    (highest, lowest)
}
