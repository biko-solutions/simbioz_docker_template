#!/bin/bash
if ! command -v click-odoo-update &>/dev/null; then
  echo "Команда click-odoo-update не найдена. Пожалуйста, установите пакет click-odoo-contrib."
else
  click-odoo-update -c /workspaces/conf/odoo-server.conf -d prod --log-level=error
fi