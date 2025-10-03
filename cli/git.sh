#!/usr/bin/env bash

# Exit on error
set -e

printf "Installing git...\n"
brew install git
brew install pre-commit

# Setup Git configuration.
printf "Configuring git...\n"

if ! git config user.name >/dev/null; then
  read -p "What is your git name?"$'\n' GIT_NAME
  git config --global user.name "$GIT_NAME"
fi

if ! git config user.email >/dev/null; then
  read -p "What is your git email?"$'\n' GIT_EMAIL
  git config --global user.email "$GIT_EMAIL"
fi

# Squelch git 2.x warning message when pushing
if ! git config push.default >/dev/null; then
  git config --global push.default simple
fi

# Enable git colours
git config --global color.ui auto