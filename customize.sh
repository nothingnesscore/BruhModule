#!/system/bin/sh
# SPDX-License-Identifier: GPL-3.0-only

ui_print "- Installing BruhModule (Universal Meta Mount)"
ui_print "- Device Architecture: $ARCH"

if [ "$ARCH" != "arm64" ]; then
  abort "! Unsupported architecture: $ARCH (supported: arm64)"
fi

if [ "$KSU" = "true" ]; then
  ui_print "- KernelSU detected. Metamodule mode enabled."
elif [ "$APATCH" = "true" ]; then
  ui_print "- APatch detected. Metamodule mode enabled."
else
  ui_print "- Magisk detected. Classic post-fs-data mode enabled."
fi

ui_print "- Setting up permissions..."
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/system/bin/bruh_mount" 0 0 0755
set_perm "$MODPATH/metamount.sh" 0 0 0755
set_perm "$MODPATH/metainstall.sh" 0 0 0755
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/boot-completed.sh" 0 0 0755

ui_print "- Installation complete"
