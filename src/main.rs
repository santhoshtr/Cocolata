use clap::{Parser, Subcommand};
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
mod postprocess;
mod report;
mod variable_font;

use features::MalayalamFeatures;
use malayalam_font::MalayalamFont;
use variable_font::MalayalamVariableFont;

#[derive(Parser)]
#[command(name = "font-builder")]
#[command(about = "Build Malayalam fonts from SVG sources", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Build master UFOs from SVG sources
    Build {
        #[arg(short, long, default_value = "config.yaml")]
        config: PathBuf,

        #[arg(short, long)]
        designspace: PathBuf,

        #[arg(short, long)]
        style: Option<String>,

        /// Build as variable font (processes all sources and merges features)
        #[arg(long, default_value_t = true)]
        variable: bool,
    },

    /// Print the styles list (space-separated) from config.yaml
    Styles {
        #[arg(short, long, default_value = "config.yaml")]
        config: PathBuf,
    },

    /// Post-process a compiled variable TTF: add prep, strip AAT tables, build STAT
    Postprocess {
        #[arg(short, long, default_value = "config.yaml")]
        config: PathBuf,

        /// Path to the compiled variable .ttf (modified in place)
        font: PathBuf,
    },

    /// Compress a TTF into a WOFF2 webfont
    Woff2 {
        /// Input .ttf
        input: PathBuf,
        /// Output .woff2
        output: PathBuf,
    },

    /// Print a vertical-metrics report (a la font-line) for one or more fonts
    Report {
        /// Font files to report on
        #[arg(required = true)]
        fonts: Vec<PathBuf>,
    },
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    let cli = Cli::parse();

    match cli.command {
        Command::Build {
            config,
            designspace,
            style,
            variable,
        } => {
            println!("Loading config from {:?}...", config);
            let config_str = std::fs::read_to_string(&config)?;
            let config: config::FontConfig = serde_yaml::from_str(&config_str)?;

            println!("Loading designspace from {:?}...", designspace);
            let designspace = DesignSpaceDocument::load(&designspace)?;

            if variable {
                build_variable_font(config, &designspace)?;
            } else {
                build_static_fonts(config, &designspace, style.as_deref())?;
            }
        }

        Command::Styles { config } => {
            let config_str = std::fs::read_to_string(&config)?;
            let config: config::FontConfig = serde_yaml::from_str(&config_str)?;
            println!("{}", config.styles.join(" "));
        }

        Command::Postprocess { config, font } => {
            let config_str = std::fs::read_to_string(&config)?;
            let config: config::FontConfig = serde_yaml::from_str(&config_str)?;
            let family = config.name.clone();
            postprocess::postprocess(&font, &family, &config)?;
        }

        Command::Woff2 { input, output } => {
            let ttf = std::fs::read(&input)?;
            let woff2 = ttf2woff2::encode(&ttf, ttf2woff2::BrotliQuality::from(11u8))?;
            std::fs::write(&output, woff2)?;
        }

        Command::Report { fonts } => {
            report::report(&fonts)?;
        }
    }

    Ok(())
}

fn build_variable_font(
    config: config::FontConfig,
    designspace: &DesignSpaceDocument,
) -> Result<(), Box<dyn std::error::Error>> {
    info!("Building variable font...");

    let mut var_font = MalayalamVariableFont::new(config, designspace)?;

    // Map styles to design directories
    let design_dirs: HashMap<String, PathBuf> = var_font
        .masters
        .iter()
        .map(|master| {
            let design_dir = PathBuf::from(format!("sources/svgs/{}", master.style));
            (master.style.clone(), design_dir)
        })
        .collect();

    let output_dir = PathBuf::from("sources/ufo");
    std::fs::create_dir_all(&output_dir)?;

    // Build all masters and write unified features
    var_font.build_masters(&design_dirs, &output_dir)?;

    info!("✓ Variable font masters built successfully!");
    info!("  Total masters: {}", var_font.master_fonts.len());

    Ok(())
}

fn build_static_fonts(
    config: config::FontConfig,
    designspace: &DesignSpaceDocument,
    style_filter: Option<&str>,
) -> Result<(), Box<dyn std::error::Error>> {
    info!("Building static fonts...");

    // Filter masters based on style argument
    let masters = variable_font::masters_from_designspace(&config, designspace)?;
    let masters_to_build: Vec<_> = if let Some(style) = style_filter {
        masters.iter().filter(|m| m.style == style).collect()
    } else {
        masters.iter().collect()
    };

    if masters_to_build.is_empty() {
        if let Some(style) = style_filter {
            eprintln!("Error: No source found for style '{}'", style);
        } else {
            eprintln!("Error: No sources found in designspace");
        }
        return Ok(());
    }

    for master in masters_to_build {
        let style = master.style.clone();
        let weight = master.weight();

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
