#!/bin/bash

# This script will refresh the current source in the current repo
# with that from the original source core framework repo.
# This is a **destructive** operation

#1. Destroy previous framework if it exists
rm -rf e2e
mkdir e2e
#2. clone core framework
git clone git@github.com:centric-automation/centric_core_framework.git e2e/
#3. Remove association with old repo
rm -rf e2e/.git
