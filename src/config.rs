use serde::Deserialize;
use std::collections::HashMap;

#[derive(Debug, Deserialize, Clone)]
pub struct FontConfig {
    pub name: String,
    pub styles: Vec<String>,
    pub version: String,
    #[serde(rename = "unitsPerEm")]
    pub units_per_em: u32,
    pub ascender: f64,
    pub descender: f64,
    pub xheight: f64,
    pub mheight: i32,
    #[serde(rename = "Xheight")]
    pub cap_height: f64,
    pub source: String,
    pub author: AuthorInfo,
    pub license: LicenseInfo,
    pub manufacturer: ManufacturerInfo,
    pub glyphs: GlyphConfig,
    #[serde(default)]
    pub sources: Option<String>,
    #[serde(default)]
    pub build: Option<String>,
    #[serde(default)]
    pub proofs: Option<String>,
    #[serde(default)]
    pub tests: Option<String>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct AuthorInfo {
    pub name: String,
    pub email: String,
    pub url: String,
}

#[derive(Debug, Deserialize, Clone)]
pub struct LicenseInfo {
    pub text: String,
    pub url: String,
}

#[derive(Debug, Deserialize, Clone)]
pub struct ManufacturerInfo {
    pub name: String,
    pub url: String,
}

#[derive(Debug, Deserialize, Clone)]
pub struct GlyphConfig {
    pub classes: HashMap<String, GlyphClass>,
    pub kern: KernConfig,
    #[serde(default)]
    pub calts: HashMap<String, Vec<Vec<String>>>,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(untagged)]
pub enum GlyphClass {
    String(String),
    List(Vec<String>),
}

impl GlyphClass {
    pub fn to_vec(&self) -> Vec<String> {
        match self {
            GlyphClass::String(s) => s.chars().map(|c| c.to_string()).collect(),
            GlyphClass::List(v) => v.clone(),
        }
    }
}

#[derive(Debug, Deserialize, Clone)]
pub struct KernConfig {
    pub classes: HashMap<String, GlyphClass>,
    pub latin: Vec<KernRule>,
    pub malayalam: Vec<KernRule>,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(untagged)]
pub enum KernRule {
    // [lhs, rhs, value]
    Triple(KernSide, KernSide, i32),
}

#[derive(Debug, Deserialize, Clone)]
#[serde(untagged)]
pub enum KernSide {
    String(String),
    List(Vec<String>),
}

impl KernSide {
    pub fn to_vec(&self) -> Vec<String> {
        match self {
            KernSide::String(s) => vec![s.clone()],
            KernSide::List(v) => v.clone(),
        }
    }
}
