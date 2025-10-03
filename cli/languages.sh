#!/usr/bin/env bash

# Exit on error
set -e

printf "Installing shellcheck...\n"
mise use --global shellcheck

printf "Installing Node.js...\n"
mise use --global nodejs

printf "Installing Python...\n"
mise use --global python

printf "Installing Golang...\n"
mise use --global golang

printf "Installing Rust...\n"
mise use --global rust

printf "Installing Java...\n"
mise use --global java
mise use --global gradle

printf "Installing Ruby...\n"
brew install libyaml
mise use --global ruby

printf "Installing gcc GNU Compiler Collection...\n"
brew install gcc