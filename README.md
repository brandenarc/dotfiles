# dotfiles

## Restore on Arch/Cachy without SSH (First Install)
```bash
git clone https://github.com/brandenarc/dotfiles.git ~/dotfiles
bash ~/dotfiles/scripts/install-arch.sh
```

## Restore on Arch/Cachy with SSH
```bash
git clone git@github.com:brandenarc/dotfiles.git ~/dotfiles
bash ~/dotfiles/scripts/install-arch.sh
```


## Restore on Debian Without SSH (First Install)
```bash
git clone https://github.com/brandenarc/dotfiles.git ~/dotfiles
bash ~/dotfiles/scripts/install-debian.sh
```

## Restore on Debian With SSH
```bash
git clone git@github.com:brandenarc/dotfiles.git ~/dotfiles
bash ~/dotfiles/scripts/install-debian.sh
```

-----------

This repository manages my application configs using **GNU Stow**.

Each app has its own folder (e.g. `alacritty/`, `mpv/`, `fish/`) that mirrors `$HOME` paths like `.config/<app>/...`.

`scripts/stow-all.sh` is the **single source of truth** for which apps get stowed.

The `custom/` directory contains **manual assets** (not stowed):
- `custom/Blender` – startup files, themes
- `custom/Davinci` – LUTs, keyboard shortcuts

-------

## Restore checklist (new system)

### Arch / CachyOS
1. Install prerequisites:
   - `git`
   - `stow`
   - `openssh` (for SSH access to GitHub)

2. Clone the repo:
   ```bash
   git clone git@github.com:brandenarc/dotfiles.git ~/dotfiles

Run the install script:
```bash
bash ~/dotfiles/scripts/install-arch.sh
```
Done — packages are installed and configs are applied via Stow.

### Debian / Pop!_OS (when available)

Clone the repo:
```bash
git clone git@github.com:brandenarc/dotfiles.git ~/dotfiles
```

Run the install script:
```bash
bash ~/dotfiles/scripts/install-debian.sh
```

(Later) Generate the apt package list on that system and commit it:
```bash
apt-mark showmanual > ~/dotfiles/packages-debian-apt-explicit.txt
```

## Apply dotfiles in order to put the configs where they need to be after it has been cloned onto the new system:

```bash
bash ~/dotfiles/scripts/stow-all.sh
```
--------

## Adding a new app to dotfiles (example workflow)

Example: adding neovim.

Create the app folder in the repo:
```bash
mkdir -p ~/dotfiles/neovim/.config
```

Move the existing config into the repo:
```bash
mv ~/.config/nvim ~/dotfiles/neovim/.config/
```

Stow the app:
```bash
cd ~/dotfiles
stow -v neovim
```
Add neovim to scripts/stow-all.sh so it is included on restores.

Commit and push:
```bash
cd ~/dotfiles
git add neovim scripts/stow-all.sh
git commit -m "Add neovim config"
git push
```
------------------

## Updating existing configs and pushing changes


### Before making changes (recommended)
Always sync with GitHub first:

```bash
cd ~/dotfiles
git pull --rebase origin main
```

This:

fetches updates from GitHub

reapplies your local commits on top

avoids merge commits

----- 
## To edit existing configs and push (we will use mpv as an example):

Edit configs normally (they are symlinks into the repo):

nano ~/.config/mpv/mpv.conf


Review changes (Can be skipped but IF skipped then add "git diff" to the push):
```bash
cd ~/dotfiles
git status
git diff
```

Commit and push:
```bash
git add -A
git commit -m "Update mpv config"
git push
```
-------------------

## Update Safe Package list refresh (Arch / CachyOS)

Update the list of explicitly installed packages (no dependencies):
```bash
pacman -Qqe > ~/dotfiles/packages-arch-pacman-explicit.txt
pacman -Qqm > ~/dotfiles/packages-arch-foreign.txt
```

Commit and push:
```bash
cd ~/dotfiles
git add packages-arch-*.txt
git commit -m "Update Arch package lists"
git push
```

## Notes:

packages-arch-pacman-explicit.txt is the main list used for reinstalling.
packages-arch-foreign.txt is for AUR/foreign packages (may be empty).
