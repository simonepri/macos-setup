#!/usr/bin/env bash

# Exit on error
set -e

bash system-settings.sh
bash system-updates.sh

bash terminal.sh
bash brew.sh
bash mas.sh
bash mise.sh
