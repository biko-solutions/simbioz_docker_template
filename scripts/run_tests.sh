#!/bin/bash

unbuffer python3 odoo-bin --config=/workspaces/conf/odoo-server.conf \
  --database=tests --init={PUT_YOUR_MODULES_HERE} \
  --test-tags='/{PUT_YOUR_MODULES_HERE}' \
  --stop-after-init --log-level=info 2>&1 | checklog-odoo
