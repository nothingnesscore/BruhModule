#!/system/bin/sh
MODDIR="${0%/*}"

LOCK_DIR="/dev/bruhmount_single_instance"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  echo "Bruh Mount already ran during this boot"
  exit 0
fi

# Execute the mount pipeline
"$MODDIR/system/bin/bruh_mount" mount
STATUS=$?

# Notify KSU kernel that metamodule mounting is complete
if [ "$STATUS" -eq 0 ] && [ -x /data/adb/ksud ]; then
  /data/adb/ksud kernel notify-module-mounted
fi

exit "$STATUS"
