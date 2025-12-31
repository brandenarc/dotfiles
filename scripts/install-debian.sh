#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
APT_LIST_FILE="$DOTFILES_DIR/packages-debian-apt-explicit.txt"
FLATPAK_LIST_FILE="$DOTFILES_DIR/packages-debian-flatpak.txt"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles directory not found: $DOTFILES_DIR"
  exit 1
fi

sudo apt update
sudo apt install -y git stow

# --- APT packages (optional) ---
if [[ -f "$APT_LIST_FILE" ]]; then
  mapfile -t APT_PKGS < <(sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$APT_LIST_FILE")
  echo "Installing ${#APT_PKGS[@]} apt packages from $APT_LIST_FILE"
  if ((${#APT_PKGS[@]})); then
    sudo apt install -y "${APT_PKGS[@]}"
  fi
else
  echo "APT package list not found: $APT_LIST_FILE"
  echo "Create it on Debian/Pop with:"
  echo "  apt-mark showmanual > $APT_LIST_FILE"
fi

# --- Flatpak apps (optional) ---
if [[ -f "$FLATPAK_LIST_FILE" ]]; then
  echo "Flatpak app list found: $FLATPAK_LIST_FILE"
  sudo apt install -y flatpak

  # Add Flathub if not already present
  if ! flatpak remotes --columns=name | grep -qx "flathub"; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi

  mapfile -t FP_APPS < <(sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$FLATPAK_LIST_FILE")
  echo "Installing ${#FP_APPS[@]} flatpak apps from $FLATPAK_LIST_FILE"
  if ((${#FP_APPS[@]})); then
    flatpak install -y flathub "${FP_APPS[@]}"
  fi
else
  echo "Flatpak app list not found: $FLATPAK_LIST_FILE"
  echo "Create it with:"
  echo "  flatpak list --app --columns=application > $FLATPAK_LIST_FILE"
fi

# --- Apply dotfiles ---
bash "$DOTFILES_DIR/scripts/stow-all.sh"

echo "Done."
