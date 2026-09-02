#!/system/bin/sh
MODDIR="${0%/*}"

# KernelSU automatically executes metamount.sh for metamodules
# AFTER post-fs-data. So we skip mounting here to avoid double-mounting
# if we are running under KernelSU.
if [ -n "$KSU" ]; then
    # We just exit and wait for metamount.sh to be called by KSU.
    exit 0
fi

# On Magisk and APatch, we must trigger the mount manually in post-fs-data.
EXTERNAL=$(cat /data/adb/bruh_mount/flags/external_susfs 2>/dev/null || echo none)
if [ "$EXTERNAL" != "none" ]; then
    "$MODDIR/bin/bruh_mount" bridge reconcile "$EXTERNAL" 2>/dev/null
fi

"$MODDIR/bin/bruh_mount" mount
