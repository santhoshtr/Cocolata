use clap::Parser;
use std::path::PathBuf;

mod composite;
mod config;
mod fontinfo;
mod glyphnames;
mod groups;
mod kerning;
mod malayalam_font;

use malayalam_font::MalayalamFont;

#[derive(Parser)]
#[command(name = "font-builder")]
#[command(about = "Build Malayalam fonts from SVG sources", long_about = None)]
struct Cli {
    #[arg(short, long, default_value = "config.yaml")]
    config: PathBuf,

    #[arg(short, long)]
    style: Option<String>,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    let args = Cli::parse();

    println!("Loading config from {:?}...", args.config);

    let config_str = std::fs::read_to_string(&args.config)?;
    let config: config::FontConfig = serde_yaml::from_str(&config_str)?;

    let styles_to_build = if let Some(style) = args.style {
        vec![style]
    } else {
        config.styles.clone()
    };

    for style in styles_to_build {
        let weight = match style.as_str() {
            "Thin" => 100,
            "ExtraLight" => 200,
            "Light" => 300,
            "Regular" => 400,
            "Medium" => 500,
            "SemiBold" => 600,
            "Bold" => 700,
            "ExtraBold" => 800,
            "Black" => 900,
            _ => 400,
        };

        let design_dir = PathBuf::from(format!("sources/svgs/{}", style));
        let output = PathBuf::from(format!("sources/ufo/{}-{}.ufo", config.name, style));

        if let Some(parent) = output.parent() {
            std::fs::create_dir_all(parent)?;
        }

        println!("\nBuilding {} {} (weight: {})", config.name, style, weight);

        let mut font = MalayalamFont::new(config.clone(), style.clone(), weight);
        font.build(&design_dir)?;
        font.set_font_info()?;
        font.update_font_version()?;
        font.build_glyph_groups()?;
        font.build_kern()?;
        font.set_glyph_order()?;
        font.font.save(&output)?;

        println!("✓ Font {:?} built successfully!", output);
        println!("  Design directory: {:?}", design_dir);
        println!("  Total glyphs: {}", font.font.default_layer().len());
        println!("  Groups: {}", font.font.groups.len());
        println!("  Kerning pairs: {}", font.font.kerning.len());
        println!("  Stylistic alternates: {}", font.salts.len());
    }

    Ok(())
}
