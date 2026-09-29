# Omarchy setup on a new PC

## Prerequisites

A fresh Omarchy install (with `yay` available — the basic Omarchy installer includes it).
If `yay` is missing, run `./arch-setup` first.

## Restore

```bash
mkdir -p ~/dev && git clone https://github.com/MandavkarPranjal/environment.git ~/dev/environment

cd ~/dev/environment
./restore
```

`restore` runs, in order:

1. installs `yay` via `omarchy pkg aur add` (only if missing)
2. `./install-config` — stows dotfiles (hypr, nvim, terminals, `.zshrc`, ...)
3. `./run pacman` — native packages (`--needed`, skips already-installed)
4. `./run yay` — AUR packages, plus the machine setup scripts in `runs/yay/` (zsh/oh-my-zsh, docker, dev tools, ...)
5. `./run flatpak` — adds flathub remote + flatpak apps
6. `./run omarchy` — hooks, menu, shell plugins, bar layout (`shell.json` widget positions), theme + background path

It continues past failures and prints a summary at the end.
Fix any reported failure, then simply re-run `./restore`.

## After changing this machine

Re-capture packages, flatpak apps, bar layout, plugins, theme and hooks:

```bash
./snapshot
git add -A && git commit -m "snapshot"
```

## Individual steps

```bash
./run pacman              # native packages only
./run yay                 # AUR packages + runs/yay setup scripts
./run flatpak             # flatpak apps only
./run omarchy             # omarchy config (plugins, bar, theme, hooks)
./run omarchy --dry       # preview without changing anything
```

## Not synced

- `~/.config/omarchy/calendars.json` — private feed URL (secret)
- `displays.json` / monitor layout — per-machine
- app data, browser profiles, vaults
- `~/.oh-my-zsh` — installed by `runs/yay/zsh`
- the wallpaper image itself — only the background *path* is recorded. Theme-shipped backgrounds are recreated by `omarchy theme set`; custom wallpapers are not copied to the repo and must already exist on the new PC.
