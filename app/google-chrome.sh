#!/usr/bin/env bash

printf "Installing Google Chrome...\n"
brew install --cask google-chrome

# Disable annoying swipe navigation
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

