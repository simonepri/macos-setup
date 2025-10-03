#!/usr/bin/env bash

# Exit on error
set -e


read -p "Confirm no system update is pending then press enter to continue."$'\n' NEW_HOST_NAME

# Check and install any remaining software updates.
printf "Checking for software updates...\n"

softwareupdate --install --all
softwareupdate --install-rosetta