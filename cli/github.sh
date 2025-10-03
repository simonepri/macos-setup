#!/usr/bin/env bash

printf "Installing github...\n"
brew install gh

gh auth login
