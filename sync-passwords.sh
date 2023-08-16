#!/bin/bash
# sync-pass.sh

set -euf -o pipefail

APPNAME="SYNC-PASS"
CONF="${CRON_CONF:-$XDG_CONFIG_HOME/cron/sync-pass.sh}"
if [ -f "$CONF" ]; then
  source $CONF
else
  echo "CONF not found, using defaults"
fi
PASS_STORE_DIR="${PASS_STORE:-$HOME/.password-store/}"

logger "$APPNAME - Syncing passwords to git"

