#!/bin/bash

git submodule foreach --recursive git reset --hard
git submodule foreach --recursive 'git fetch origin --tags && git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo "main") && git pull'
sh odoo_set_icons.sh