```bash
mkdir -p ~/dev && git clone https://github.com/MandavkarPranjal/environment.git ~/dev/environment

cd ~/dev/environment
```

## New PC restore

See [OMARCHY.md](OMARCHY.md) for the full Omarchy setup guide.

```bash
./arch-setup   # only if yay is missing (pacman + yay bootstrap)
./restore      # stow config + packages + flatpak + omarchy (plugins, bar positions, theme, hooks)
```

## After changing this machine

Re-capture your machine state (packages, flatpak apps, omarchy bar layout,
plugins, theme, hooks), then commit:

```bash
./snapshot
git add -A && git commit -m "snapshot"
```

## What is synced

- native packages (`runs/pacman/packages.list`), AUR (`runs/yay/aur.list`), flatpak apps (`runs/flatpak/apps.list`)
- stowed dotfiles (`home/`)
- omarchy: bar/widget layout (`shell.json`), shell plugins, menu, theme + background, hooks

## Not synced

- `~/.config/omarchy/calendars.json` — contains a private feed URL (secret)
- `displays.json` / monitor layout — per-machine
- app data, browser profiles, vaults
- `~/.oh-my-zsh` — installed by `runs/yay/zsh`
