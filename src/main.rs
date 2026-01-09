use clap::Parser;
use norad::designspace::DesignSpaceDocument;
use std::collections::HashMap;
use std::path::PathBuf;

use log::info;
mod composite;
mod config;
mod features;
mod fontinfo;
mod glyphnames;
mod groups;
mod kerning;
mod malayalam_font;
mod variable_font;

use features::MalayalamFeatures;
use malayalam_font::MalayalamFont;
use variable_font::MalayalamVariableFont;

#[derive(Parser)]
#[command(name = "font-builder")]
#[command(about = "Build Malayalam fonts from SVG sources", long_about = None)]
struct Cli {
    #[arg(short, long, default_value = "config.yaml")]
    config: PathBuf,

    #[arg(short, long)]
    designspace: PathBuf,

    #[arg(short, long)]
    style: Option<String>,

    /// Build as variable font (processes all sources and merges features)
    #[arg(long, default_value_t = true)]
    variable: bool,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    let args = Cli::parse();

    println!("Loading config from {:?}...", args.config);

    let config_str = std::fs::read_to_string(&args.config)?;
    let config: config::FontConfig = serde_yaml::from_str(&config_str)?;

    // Load designspace
    println!("Loading designspace from {:?}...", args.designspace);
    let designspace = DesignSpaceDocument::load(&args.designspace)?;

    if args.variable {
        // Build as variable font - process all sources with unified features
        build_variable_font(config, &designspace)?;
    } else {
        // Build as static font(s) - process individual sources
        build_static_fonts(config, &designspace, args.style.as_deref())?;
    }

    Ok(())
}

fn build_variable_font(
    config: config::FontConfig,
    designspace: &DesignSpaceDocument,
) -> Result<(), Box<dyn std::error::Error>> {
    info!("Building variable font...");

    let mut var_font = MalayalamVariableFont::new(config.clone(), designspace);

    // Map styles to design directories
    let mut design_dirs = HashMap::new();
    for source in &designspace.sources {
        if let Some(ref style) = source.stylename {
            let design_dir = PathBuf::from(format!("sources/svgs/{}", style));
            design_dirs.insert(style.clone(), design_dir);
        }
    }

    let output_dir = PathBuf::from("sources/ufo");
    std::fs::create_dir_all(&output_dir)?;

    // Build all masters and write unified features
    var_font.build_masters(&design_dirs, &output_dir)?;

    info!("✓ Variable font masters built successfully!");
    info!("  Total masters: {}", var_font.master_fonts.len());
    info!("  Weights: {:?}", var_font.weights);

    Ok(())
}

fn build_static_fonts(
    config: config::FontConfig,
    designspace: &DesignSpaceDocument,
    style_filter: Option<&str>,
) -> Result<(), Box<dyn std::error::Error>> {
    info!("Building static fonts...");

    // Filter sources based on style argument
    let sources_to_build: Vec<_> = if let Some(style) = style_filter {
        designspace
            .sources
            .iter()
            .filter(|source| source.stylename.as_deref() == Some(style))
            .collect()
    } else {
        designspace.sources.iter().collect()
    };

    if sources_to_build.is_empty() {
        if let Some(style) = style_filter {
            eprintln!("Error: No source found for style '{}'", style);
        } else {
            eprintln!("Error: No sources found in designspace");
        }
        return Ok(());
    }

    for source in sources_to_build {
        let style = source.stylename.as_deref().unwrap_or("Regular").to_string();

        // Get weight from the axis location
        let weight = source
            .location
            .iter()
            .find(|dim| dim.name.to_lowercase() == "weight")
            .and_then(|dim| dim.xvalue)
            .unwrap_or(400.0) as u32;

        let design_dir = PathBuf::from(format!("sources/svgs/{}", style));
        let output = PathBuf::from(format!("sources/ufo/{}-{}.ufo", config.name, style));

        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }

        println!("Building {} {} (weight: {})", config.name, style, weight);

        let mut font = MalayalamFont::new(config.clone(), style.clone(), weight);
        font.build(&design_dir)?;
        font.set_font_info()?;
        font.update_font_version()?;
        font.build_glyph_groups()?;
        font.build_kern()?;
        font.set_glyph_order()?;

        if let Err(e) = font.write_glyphs(&output.join("glyphs")) {
            info!("write_glyphs failed: {}, falling back to font.save()", e);
            font.font.save(&output)?;
        }

        // Generate and write features for static font
        let features = MalayalamFeatures::new(&font);
        let features_path = output.join("features.fea");
        features.write_features(Some(&features_path))?;

        info!("✓ Font {:?} built successfully!", output);
        info!("  Design directory: {:?}", design_dir);
        info!("  Total glyphs: {}", font.font.default_layer().len());
        info!("  Groups: {}", font.font.groups.len());
        info!("  Kerning pairs: {}", font.font.kerning.len());
        info!("  Stylistic alternates: {}", font.salts.len());
    }

    Ok(())
}
