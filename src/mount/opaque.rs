use std::ffi::CString;
use std::fs;
use std::path::Path;

use anyhow::{bail, Context, Result};
use tracing::{debug, warn};

pub fn mark_opaque_dirs(module_system_dir: &Path, lower_dir: &Path) -> Result<()> {
    mark_opaque_recursive(module_system_dir, module_system_dir, lower_dir)
}

fn mark_opaque_recursive(base: &Path, current: &Path, lower_dir: &Path) -> Result<()> {
    let entries = match fs::read_dir(current) {
        Ok(entries) => entries,
        Err(_) => return Ok(()),
    };

    for entry in entries.filter_map(|e| e.ok()) {
        let path = entry.path();
        if !path.is_dir() {
            continue;
        }
        if path.join(".replace").exists() {
            if let Ok(rel) = path.strip_prefix(base) {
                let staging_dir = lower_dir.join(rel);
                if staging_dir.is_dir() {
                    if let Err(e) = set_opaque_xattr(&staging_dir) {
                        warn!(
                            dir = %staging_dir.display(),
                            error = %e,
                            "failed to set overlay.opaque"
                        );
                    } else {
                        debug!(dir = %staging_dir.display(), "set overlay.opaque");
                    }
                }
            }
        }
        mark_opaque_recursive(base, &path, lower_dir)?;
    }

    Ok(())
}

// ovl_is_opaquedir() checks trusted.overlay.opaque on both upper and lower layers
fn set_opaque_xattr(dir: &Path) -> Result<()> {
    let c_path = CString::new(dir.to_str().context("non-UTF8 path")?)
        .context("path contains NUL")?;
    let c_name = CString::new("trusted.overlay.opaque").unwrap();
    let val = b"y";

    let ret = unsafe {
        libc::lsetxattr(
            c_path.as_ptr(),
            c_name.as_ptr(),
            val.as_ptr() as *const libc::c_void,
            val.len(),
            0,
        )
    };
    if ret != 0 {
        bail!(
            "lsetxattr on {}: {}",
            dir.display(),
            std::io::Error::last_os_error()
        );
    }
    Ok(())
}
