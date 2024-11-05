#!/bin/bash

if ! command -v click-odoo-update &>/dev/null; then
  cd /workspaces/simbioz_repo || exit 0
  pip install -e . click-odoo-contrib
fi
