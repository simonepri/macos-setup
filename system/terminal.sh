#!/usr/bin/env bash

# Exit on error
set -e

rm "$HOME/.profile"
rm "$HOME/.zshrc"
rm "$HOME/.zsh_plugins.txt"
rm -rf "$HOME/.fzf"
sudo rm -rf "$HOME/.antidote"

printf "Configuring terminal...\n"

# Create a bin folder in your home
mkdir -p "$HOME/.bin"
echo '# set PATH so it includes user private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
' >> "$HOME/.profile"
source "$HOME/.profile"

# Setup language
echo '# language
export LANG="en_US.UTF-8"
' >> "$HOME/.profile"
source "$HOME/.profile"

# Set zsh as default shell
sudo chsh -s "$(which zsh)"
chsh -s "$(which zsh)"
echo '# load .profile
source "$HOME/.profile"
' >> "$HOME/.zshrc"

# Setup zsh
echo '# zsh setup
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt SHARE_HISTORY
' >> "$HOME/.zshrc"

# Install antidote
git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
echo '# antidote setup
source "$HOME/.antidote/antidote.zsh"
antidote load
' >> "$HOME/.zshrc"

# Install antidote plugins
echo '# oh-my-zsh plugins
ohmyzsh/ohmyzsh path:plugins/colored-man-pages
ohmyzsh/ohmyzsh path:plugins/extract
ohmyzsh/ohmyzsh path:plugins/safe-paste

# this block is in alphabetic order
zsh-users/zsh-completions
zsh-users/zsh-autosuggestions

# these should be at last!
sindresorhus/pure kind:fpath
zdharma-continuum/fast-syntax-highlighting kind:defer
zsh-users/zsh-history-substring-search
' > "$HOME/.zsh_plugins.txt"

# Setup pure
echo '# pure setup
PURE_CMD_MAX_EXEC_TIME=1
autoload -Uz promptinit && promptinit && prompt pure
PROMPT='%F{white}%* '$PROMPT
' >> "$HOME/.zshrc"

# Setup completion
echo '# completion setup
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
setopt completealiases
' >> "$HOME/.zshrc"

# Install zfz
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" && yes | "$HOME/.fzf/install"

# Install Snazzy terminal theme
curl -o "$HOME/Downloads/Snazzy.terminal" -L https://raw.githubusercontent.com/sindresorhus/terminal-snazzy/master/Snazzy.terminal
open "$HOME/Downloads/Snazzy.terminal"
rm "$HOME/Downloads/Snazzy.terminal"
sleep 0.5
osascript -e 'tell application "Terminal" to set miniaturized of front window to true'

# Terminal > General > On startup, open: New window with profile:
defaults write com.apple.Terminal "Startup Window Settings" -string Snazzy

# Terminal > Profiles > Snazzy > Default
defaults write com.apple.Terminal "Default Window Settings" -string Snazzy

# Disable Last Login on New Terminal
touch "$HOME/.hushlogin"
