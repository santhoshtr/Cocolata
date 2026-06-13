//! Post-process a compiled variable font: add a `prep` program for better
//! Windows rendering, strip unwanted AAT tables, and build the STAT table.
//!
//! All three mutations are applied in a single read/write cycle.

use std::collections::HashMap;
use std::path::Path;

use fontations::read::{FontRef, TableProvider};
use fontations::types::{Fixed, NameId, Tag};
use fontations::write::FontBuilder;
use fontations::write::tables::name::{Name, NameRecord};
use fontations::write::tables::stat::{AxisRecord, AxisValue, AxisValueTableFlags, Stat};

use crate::config::FontConfig;

/// `prep` program optimised for unhinted fonts, improving rendering on Windows.
/// Assembly: `PUSHW[] 511 SCANCTRL[] PUSHB[] 4 SCANTYPE[]`.
const PREP_PROGRAM: [u8; 7] = [0xB8, 0x01, 0xFF, 0x85, 0xB0, 0x04, 0x8D];

/// AAT-only tables that should not ship in an OpenType font.
const UNWANTED_TABLES: [&[u8; 4]; 23] = [
    b"EBSC", b"Zaph", b"acnt", b"ankr", b"bdat", b"bhed", b"bloc", b"bmap", b"bsln", b"fdsc",
    b"feat", b"fond", b"gcid", b"just", b"kerx", b"lcar", b"ltag", b"mort", b"morx", b"opbd",
    b"prop", b"trak", b"xref",
];

/// Windows / Unicode BMP / US-English — the platform we emit STAT name records for.
const WIN_PLATFORM: u16 = 3;
const WIN_ENCODING: u16 = 1;
const WIN_LANGUAGE: u16 = 0x0409;

pub fn postprocess(
    font_path: &Path,
    family: &str,
    config: &FontConfig,
) -> Result<(), Box<dyn std::error::Error>> {
    let var_config = config
        .variablefonts
        .get(family)
        .ok_or_else(|| format!("No variablefonts config for family '{family}'"))?;

    let data = std::fs::read(font_path)?;
    let font = FontRef::new(&data)?;

    // Collect existing name records (preserved verbatim) and build the STAT table,
    // allocating any new name records it needs.
    let mut names = NameTableBuilder::new(&font)?;
    let stat = build_stat(&var_config.stat, &mut names)?;
    let name = Name::new(names.into_records());

    // Rebuild the font: replaced tables first, then every other table except the
    // unwanted AAT set.
    let mut builder = FontBuilder::new();
    builder.add_table(&name)?;
    builder.add_table(&stat)?;
    builder.add_raw(Tag::new(b"prep"), &PREP_PROGRAM[..]);

    let unwanted: Vec<Tag> = UNWANTED_TABLES.iter().map(|t| Tag::new(t)).collect();
    for record in font.table_directory.table_records() {
        let tag = record.tag.get();
        if unwanted.contains(&tag) || builder.contains(tag) {
            continue;
        }
        if let Some(table) = font.table_data(tag) {
            builder.add_raw(tag, table);
        }
    }

    std::fs::write(font_path, builder.build())?;
    Ok(())
}

fn build_stat(
    stat: &crate::config::StatConfig,
    names: &mut NameTableBuilder,
) -> Result<Stat, Box<dyn std::error::Error>> {
    let mut design_axes = Vec::new();
    let mut axis_values = Vec::new();

    for (axis_index, axis) in stat.axes.iter().enumerate() {
        let axis_index = axis_index as u16;
        let axis_name_id = names.id_for(&axis.name);
        design_axes.push(AxisRecord::new(
            Tag::new_checked(axis.tag.as_bytes())?,
            axis_name_id,
            axis_index,
        ));

        for value in &axis.values {
            let value_name_id = names.id_for(&value.name);
            let flags = value
                .flags
                .map(AxisValueTableFlags::from_bits_truncate)
                .unwrap_or_else(AxisValueTableFlags::empty);
            let av = match value.linked_value {
                Some(linked) => AxisValue::format_3(
                    axis_index,
                    flags,
                    value_name_id,
                    Fixed::from_f64(value.value),
                    Fixed::from_f64(linked),
                ),
                None => AxisValue::format_1(
                    axis_index,
                    flags,
                    value_name_id,
                    Fixed::from_f64(value.value),
                ),
            };
            axis_values.push(av);
        }
    }

    // NameId 2 (subfamily) is fontTools' default elided fallback name.
    Ok(Stat::new(design_axes, axis_values, NameId::new(2)))
}

/// Builds an extended `name` table, reusing existing Windows entries by string and
/// allocating fresh name IDs (above the current maximum) for new STAT names.
struct NameTableBuilder {
    records: Vec<NameRecord>,
    win_lookup: HashMap<String, NameId>,
    next_id: u16,
}

impl NameTableBuilder {
    fn new(font: &FontRef) -> Result<Self, Box<dyn std::error::Error>> {
        let name = font.name()?;
        let string_data = name.string_data();
        let mut records = Vec::new();
        let mut win_lookup = HashMap::new();
        let mut max_id = 255u16;

        for r in name.name_record().iter() {
            let string = r
                .string(string_data)
                .map(|s| s.chars().collect::<String>())
                .unwrap_or_default();
            max_id = max_id.max(r.name_id().to_u16());
            if r.platform_id() == WIN_PLATFORM
                && r.encoding_id() == WIN_ENCODING
                && r.language_id() == WIN_LANGUAGE
            {
                win_lookup.entry(string.clone()).or_insert(r.name_id());
            }
            records.push(NameRecord::new(
                r.platform_id(),
                r.encoding_id(),
                r.language_id(),
                r.name_id(),
                string.into(),
            ));
        }

        Ok(Self {
            records,
            win_lookup,
            next_id: max_id + 1,
        })
    }

    /// Returns the name ID for `string`, reusing an existing Windows record when
    /// present, otherwise appending a new one.
    fn id_for(&mut self, string: &str) -> NameId {
        if let Some(id) = self.win_lookup.get(string) {
            return *id;
        }

        let id = NameId::new(self.next_id);
        self.next_id += 1;
        self.win_lookup.insert(string.to_string(), id);
        self.records.push(NameRecord::new(
            WIN_PLATFORM,
            WIN_ENCODING,
            WIN_LANGUAGE,
            id,
            string.to_string().into(),
        ));
        id
    }

    fn into_records(self) -> Vec<NameRecord> {
        self.records
    }
}
