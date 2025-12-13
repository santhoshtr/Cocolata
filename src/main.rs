use clap::Parser;
use norad::designspace::DesignSpaceDocument;
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

use features::MalayalamFeatures;
use malayalam_font::MalayalamFont;

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

    // Filter sources based on style argument
    let sources_to_build: Vec<_> = if let Some(ref style) = args.style {
        designspace
            .sources
            .iter()
            .filter(|source| source.stylename.as_deref() == Some(style.as_str()))
            .collect()
    } else {
        designspace.sources.iter().collect()
    };

    if sources_to_build.is_empty() {
        if let Some(ref style) = args.style {
            eprintln!("Error: No source found for style '{}'", style);
        } else {
            eprintln!("Error: No sources found in designspace");
        }
        return Ok(());
    }

    for source in sources_to_build {
        let style = source.stylename.as_deref().unwrap_or("Regular").to_string();

        // Get weight from the axis location
        // Look for dimension with name "weight" and use its xvalue
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
        font.font.save(&output)?;

        // Generate and write features
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
