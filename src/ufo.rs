//! Write a UFO in place, without replacing its directory.
//!
//! `norad::Font::save` deletes the UFO directory and writes all files again.
//! A file watcher (for example in Fontra) stops watching a directory that is
//! deleted, and it can read a UFO that is only partly written. Here we save to
//! a temporary directory, then copy only the changed files into the UFO and
//! remove the files that the new UFO does not have.

use std::fs;
use std::io;
use std::path::Path;

/// Save `font` to the UFO at `path`. Files that did not change are not written.
pub fn save(font: &norad::Font, path: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let tmp = path.with_extension("ufo.tmp");
    font.save(&tmp)?;
    sync_dir(&tmp, path)?;
    fs::remove_dir_all(&tmp)?;
    Ok(())
}

/// Make the directory `dst` equal to `src`. Write a file only if its content
/// changed, then remove the entries that are not in `src`.
fn sync_dir(src: &Path, dst: &Path) -> io::Result<()> {
    fs::create_dir_all(dst)?;

    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let dst_path = dst.join(entry.file_name());
        if entry.file_type()?.is_dir() {
            sync_dir(&entry.path(), &dst_path)?;
        } else {
            let content = fs::read(entry.path())?;
            if fs::read(&dst_path).ok().as_deref() != Some(content.as_slice()) {
                fs::write(&dst_path, content)?;
            }
        }
    }

    for entry in fs::read_dir(dst)? {
        let entry = entry?;
        if !src.join(entry.file_name()).exists() {
            if entry.file_type()?.is_dir() {
                fs::remove_dir_all(entry.path())?;
            } else {
                fs::remove_file(entry.path())?;
            }
        }
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time::{Duration, SystemTime};

    fn mtime(path: &Path) -> SystemTime {
        fs::metadata(path).unwrap().modified().unwrap()
    }

    #[test]
    fn sync_writes_only_changed_files_and_removes_stale_ones() {
        let root = std::env::temp_dir().join(format!("cocolata-ufo-test-{}", std::process::id()));
        let (src, dst) = (root.join("src"), root.join("dst"));
        fs::create_dir_all(src.join("glyphs")).unwrap();
        fs::create_dir_all(dst.join("glyphs")).unwrap();

        fs::write(src.join("glyphs/same.glif"), "same").unwrap();
        fs::write(dst.join("glyphs/same.glif"), "same").unwrap();
        fs::write(src.join("glyphs/changed.glif"), "new").unwrap();
        fs::write(dst.join("glyphs/changed.glif"), "old").unwrap();
        fs::write(src.join("glyphs/added.glif"), "added").unwrap();
        fs::write(dst.join("glyphs/stale.glif"), "stale").unwrap();

        // Give the unchanged file an old mtime, so that a rewrite is visible.
        let old = SystemTime::now() - Duration::from_secs(3600);
        fs::File::options()
            .write(true)
            .open(dst.join("glyphs/same.glif"))
            .unwrap()
            .set_modified(old)
            .unwrap();

        sync_dir(&src, &dst).unwrap();

        assert_eq!(mtime(&dst.join("glyphs/same.glif")), old);
        assert_eq!(
            fs::read_to_string(dst.join("glyphs/changed.glif")).unwrap(),
            "new"
        );
        assert_eq!(
            fs::read_to_string(dst.join("glyphs/added.glif")).unwrap(),
            "added"
        );
        assert!(!dst.join("glyphs/stale.glif").exists());

        fs::remove_dir_all(&root).unwrap();
    }
}
