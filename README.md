<div align="center">
  <h1>🚀 BruhModule</h1>
  <h3><i>The Ultimate Universal Meta Mount Engine for Android</i></h3>
  <p>Clean VFS • Per-Module Strategies • SUSFS v2.3.0 Integration • Liquid Glass UI</p>
</div>

---

## 🌟 What is BruhModule?

**BruhModule** is a next-generation "Meta Module" designed to be the single overarching engine that handles mounting for all your other modules. It combines the absolute best concepts from the top mounting engines in the community into one beautifully crafted, ultra-secure solution.

Whether you need deep-level hiding using native VFS, standard OverlayFS, or Magic Mount, BruhModule intelligently routes and protects your files.

## ✨ Key Features

- 🛡️ **Clean VFS Support**: Mounts files using a character device hook (`/dev/zeromount`), leaving **zero traces** in `/proc/mounts`.
- 🔀 **Per-Module Technology**: Assign different mount strategies (VFS, Overlay, Magic) on a *per-module* basis. Mix and match without conflicts!
- 👻 **Native SUSFS v2.3.0 Support**: Automatically detects and leverages KernelSU SUSFS features.
  - Automatically spoofs `kstat` (inode, device, timestamps).
  - Automatically records and hides `mnt_id`.
  - Path hiding and unicode bypass filtering built-in.
- 🔮 **Liquid Glass WebUI (Coming Soon)**: A beautiful, frosted-glass interface to configure strategies per-module right from your SU manager.

## 🤝 Credits & Inspiration

BruhModule stands on the shoulders of giants. We would like to express our deepest gratitude to the creators and maintainers of the following projects, whose ideas and code inspired this engine:

*   [**ZeroMount**](https://github.com/Enginex0/zeromount) - For pioneering the `/dev/zeromount` clean VFS approach.
*   [**Hybrid Mount**](https://github.com/Hybrid-Mount/meta-hybrid_mount) - For the brilliant per-module routing strategy.
*   [**NoMount**](https://github.com/NoMount) - For the clean VFS implementation concepts.
*   [**simonpunk / susfs4ksu**](https://gitlab.com/simonpunk/susfs4ksu) - For the incredible SUSFS kernel patch framework.
*   **Magic Mount / Mountify / OverlayFS Mount** - For standardizing userspace overlay mechanics.

*A huge thank you to all the developers in the Android rooting community!*

## 📦 Installation

1. Ensure you have a kernel with **SUSFS v2.3.0** and `CONFIG_SECCOMP` enabled.
2. Download the latest `BruhModule-beta.zip` from the [Releases](https://github.com/nothingnesscore/BruhModule/releases) tab.
3. Flash in KernelSU / Magisk / APatch.
4. Reboot and enjoy the magic!

---
<div align="center">
  <i>Crafted with ❤️ for the Android Community by nothingnesscore</i>
</div>
