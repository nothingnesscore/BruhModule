#!/system/bin/sh
LOCK_DIR="/dev/bruhmount_single_instance"
rmdir "$LOCK_DIR" 2>/dev/null
