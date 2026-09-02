use resetprop::PropSystem;
use tracing::{debug, trace, warn};

pub(super) fn enforce_stealth(sys: &PropSystem, props: &[(&str, &str)]) {
    let (mut spoofed, mut skipped) = (0u32, 0u32);
    for &(name, value) in props {
        match sys.get(name) {
            Some(current) if current != value => {
                trace!(prop = name, from = current, to = value, "stealth");
                let _ = sys.set_stealth(name, value);
                spoofed += 1;
            }
            Some(_) => skipped += 1,
            None => skipped += 1,
        }
    }
    debug!(spoofed, skipped, "enforce_stealth");
}

pub(super) fn nuke_props(sys: &PropSystem, names: &[&str]) {
    let (mut nuked, mut absent) = (0u32, 0u32);
    for &name in names {
        if sys.get(name).is_none() {
            absent += 1;
            continue;
        }
        trace!(prop = name, "nuke");
        let result = if name.starts_with("persist.") {
            sys.nuke_persist(name)
        } else {
            sys.nuke(name)
        };
        match result {
            Ok(true) => nuked += 1,
            Ok(false) => absent += 1,
            Err(e) => {
                warn!(prop = name, err = %e, "nuke failed, falling back to hexpatch");
                let _ = sys.hexpatch_delete(name);
                nuked += 1;
            }
        }
    }
    if nuked > 0 {
        debug!(nuked, absent, "nuke_props");
    }
}
