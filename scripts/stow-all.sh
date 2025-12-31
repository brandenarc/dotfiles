#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

cd "$DOTFILES_DIR"

stow -R \
  alacritty \
  btop \
  cava \
  celluloid \
  fish \
  ghostty \
  kitty \
  mpv \
  vlc \
  yazi
