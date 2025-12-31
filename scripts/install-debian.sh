#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
APT_LIST_FILE="$DOTFILES_DIR/packages-debian-apt-explicit.txt"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles directory not found: $DOTFILES_DIR"
  exit 1
fi

sudo apt update
sudo apt install -y git stow

if [[ -f "$APT_LIST_FILE" ]]; then
  mapfile -t PKGS < <(sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$APT_LIST_FILE")
  echo "Installing ${#PKGS[@]} apt packages from $APT_LIST_FILE"
  sudo apt install -y "${PKGS[@]}"
else
  echo "Package list not found: $APT_LIST_FILE"
  echo "On Debian/Pop, create it with something like:"
  echo "  apt-mark showmanual > $APT_LIST_FILE"
  echo "(Then review it—apt-mark includes a lot of stuff you may not want.)"
fi

cd "$DOTFILES_DIR"
stow -R alacritty btop cava celluloid fish ghostty kitty mpv vlc yazi

echo "Done."
#!/usr/bin/env bash
set -euo pipefail
echo "TODO: Debian/Pop package install script"
