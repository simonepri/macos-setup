#!/usr/bin/env bash

# Exit on error
set -e

printf "Installing brew...\n"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo '# brew
export PATH="/opt/homebrew/bin:$PATH"
' >> "$HOME/.profile"
source "$HOME/.profile"

brew doctor