#!/bin/bash

DROPDATABASE=$1
DBNAME=$2

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

MODULES=""

drop_database() {
  if [[ "${DROPDATABASE}" == "yes" ]]; then
    echo -e "${GREEN}=== DROPPING DATABASE ===${NC}"
    click-odoo-dropdb -c /workspaces/conf/odoo-server.conf --if-exists ${DBNAME}
  fi
}

if [[ -z "${DBNAME}" ]]; then
  echo -e "${RED}Database name is not set${NC}"
  exit 1
fi

if [[ -z "${MODULES}" ]]; then
  echo -e "${RED}The module list is not provided${NC}"
  exit 1
fi

drop_database

echo -e "${GREEN}=== INITIALIZING DATABASE ===${NC}"

unbuffer python3 odoo-bin --config=/workspaces/conf/odoo-server.conf \
  --database=${DBNAME} --init=${MODULES} \
  --stop-after-init --log-level=error

result=$?

if [ $result -ne 0 ]; then
  echo -e "${RED}=== INITIALIZATION FAILED ===${NC}"
  exit $result
fi

echo -e "${GREEN}=== LET'S TEST ===${NC}"

unbuffer python3 odoo-bin --config=/workspaces/conf/odoo-server.conf \
  --database=${DBNAME} --init=${MODULES} \
  --test-enable \
  --stop-after-init --log-level=info 2>&1 | grep -Ei "odoo.*tests|ERROR"

drop_database
