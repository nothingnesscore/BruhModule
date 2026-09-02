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
"$MODDIR/system/bin/bruh_mount" mount
