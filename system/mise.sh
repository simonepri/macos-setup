#!/usr/bin/env bash

# Exit on error
set -e

printf "Installing mise...\n"
brew install mise

echo '# mise
eval "$(mise activate zsh)"
' >> "$HOME/.zshrc"