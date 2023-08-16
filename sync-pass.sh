#!/bin/bash
# sync-pass.sh

set -euf -o pipefail

APPNAME="SYNC-PASS"
CONF="${CRON_CONF:-$HOME/.config/cron/sync-pass.sh}"
if [ -f "$CONF" ]; then
  logger "$APPNAME - CONF found"
  source $CONF
else
  logger "$APPNAME - CONF not found, using defaults"
fi
PASS_STORE_DIR="${PASS_STORE_DIR:-$HOME/.password-store/}"
logger "$APPNAME - Pass store path: $PASS_STORE_DIR"
GIT="git -C $PASS_STORE_DIR"

NUM_CHANGES=$($GIT rev-list --count origin/main...main)
if [ $NUM_CHANGES -gt 0 ]; then
  $GIT push
  logger "$APPNAME - Pushed $NUM_CHANGES changes to $($GIT remote get-url origin)"
else
  logger "$APPNAME - No new passwords found"
fi
