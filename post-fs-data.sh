#!/system/bin/sh
MODDIR=${0%/*}
# Execute the backend daemon in background
nohup $MODDIR/system/bin/bruh_mount > $MODDIR/daemon.log 2>&1 &
