#!/bin/bash

git submodule foreach --recursive git reset --hard
git submodule foreach --recursive 'git fetch origin --tags && git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo "main") && git pull'
sh odoo_set_icons.sh

if ! command -v click-odoo-update &>/dev/null; then
  echo "Команда click-odoo-update не найдена. Пожалуйста, установите пакет click-odoo-contrib."
else
  click-odoo-update -c /workspaces/conf/odoo-server.conf -d prod --log-level=error
fi
