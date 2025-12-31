#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
PACMAN_LIST_FILE="$DOTFILES_DIR/packages-arch-pacman-explicit.txt"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles directory not found: $DOTFILES_DIR"
  exit 1
fi

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git stow

if [[ -f "$PACMAN_LIST_FILE" ]]; then
  mapfile -t PKGS < <(sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$PACMAN_LIST_FILE")
  echo "Installing ${#PKGS[@]} pacman packages from $PACMAN_LIST_FILE"
  sudo pacman -S --needed --noconfirm "${PKGS[@]}"
else
  echo "Package list not found: $PACMAN_LIST_FILE"
  echo "Create it with: pacman -Qqe > $PACMAN_LIST_FILE"
fi

cd "$DOTFILES_DIR"
bash "$DOTFILES_DIR/scripts/stow-all.sh"

echo "Done."
#!/usr/bin/env bash
set -euo pipefail
echo "TODO: Arch/Cachy package install script"
