#!/system/bin/sh
# SPDX-License-Identifier: GPL-3.0-only

if [ "$KSU" = "true" ]; then
  export KSU_HAS_METAMODULE="true"
  export KSU_METAMODULE="bruhmodule"
fi

if [ "$APATCH" = "true" ]; then
  export APATCH_HAS_METAMODULE="true"
  export APATCH_METAMODULE="bruhmodule"
fi

export BRUH_MOUNT="true"

MANAGED_PARTITIONS="odm product system_ext vendor mi_ext my_bigball my_carrier my_company my_engineering my_heytap my_manifest my_preload my_product my_region my_reserve my_stock oem optics prism"

ui_print "- BruhModule metainstall"

handle_partition() {
  :
}

mark_replace() {
  replace_target="$1"
  mkdir -p "$replace_target" || return 1
  setfattr -n trusted.overlay.opaque -v y "$replace_target"
}

install_module

for partition in $MANAGED_PARTITIONS; do
  if [ -e "$MODPATH/$partition" ] || [ -L "$MODPATH/$partition" ]; then
    continue
  fi

  if [ ! -d "$MODPATH/system/$partition" ]; then
    continue
  fi

  if [ -d "/$partition" ] && [ -L "/system/$partition" ]; then
    ln -sf "./system/$partition" "$MODPATH/$partition"
    ui_print "- linked /$partition for OverlayFS/Magic Mount"
  fi
done

if [ -d "$MODPATH/system" ] && [ -z "$(ls -A "$MODPATH/system" 2>/dev/null)" ]; then
  rmdir "$MODPATH/system" 2>/dev/null
  ui_print "- removed empty /system directory"
fi

ui_print "- installation partition layout ready"
