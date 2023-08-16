#!/bin/bash
# sync-pass.sh

set -euf -o pipefail

APPNAME="SYNC-PASS"
CONF="${CRON_CONF:-$XDG_CONFIG_HOME/cron/sync-pass.sh}"
if [ -f "$CONF" ]; then
  logger "$APPNAME - CONF found"
  source $CONF
else
  logger "$APPNAME - CONF not found, using defaults"
fi
PASS_STORE_DIR="${PASS_STORE_DIR:-$HOME/.password-store/}"
logger "$APPNAME - Pass store path: $PASS_STORE_DIR"
GIT="git -C $PASS_STORE_DIR"

logger "$APPNAME - Syncing passwords to git"

NUM_PASS=$($GIT status --short | wc -l)
if [ $NUM_PASS -gt 0 ]; then
  logger "$APPNAME - Adding $NUM_PASS new passwords"
  $GIT add -A
  DATE=$(date --utc '+%Y-%m-%dT%H:%M:%S (%Z)')
  $GIT commit -m "$DATE"
  logger "$APPNAME - Committed $NUM_PASS (message: $DATE)"
  $GIT push
  logger "$APPNAME - Pushed to $($GIT remote get-url origin)"
else
  logger "$APPNAME - No new passwords found"
fi
