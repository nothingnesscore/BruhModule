#!/system/bin/sh
MODDIR="${0%/*}"
"$MODDIR/system/bin/bruh_mount" mount
STATUS=$?
if [ "$STATUS" -eq 0 ] && [ -x /data/adb/ksud ]; then
  /data/adb/ksud kernel notify-module-mounted
fi
exit "$STATUS"
