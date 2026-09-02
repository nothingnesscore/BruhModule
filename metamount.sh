#!/system/bin/sh
MODDIR="${0%/*}"

LOCK_DIR="/dev/bruhmount_single_instance"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  echo "Bruh Mount already ran during this boot"
  exit 0
fi

# Execute the mount pipeline
EXTERNAL=$(cat /data/adb/bruh_mount/flags/external_susfs 2>/dev/null || echo none)
if [ "$EXTERNAL" != "none" ]; then
    "$MODDIR/bin/bruh_mount" bridge reconcile "$EXTERNAL" 2>/dev/null
fi

"$MODDIR/bin/bruh_mount" mount
STATUS=$?

# Notify KSU kernel that metamodule mounting is complete
if [ "$STATUS" -eq 0 ] && [ -x /data/adb/ksud ]; then
  /data/adb/ksud kernel notify-module-mounted
fi

exit "$STATUS"
