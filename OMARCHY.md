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

## Updating mpv UI scripts

`home/.config/mpv` ships a vendored copy of **uosc** (UI) and **thumbfast**
(seekbar thumbnail previews), which give mpv a YouTube-style hover preview.

`home/.config/mpv/fonts/uosc_{icons.otf,textures.ttf}` are required — without
them uosc renders every button as overlapping raw text instead of icons.
To update them, re-download into the repo and re-stow:

```bash
cd ~/dev/environment
curl -L -o /tmp/uosc.zip https://github.com/tomasklaen/uosc/releases/latest/download/uosc.zip
rm -rf home/.config/mpv/scripts/uosc && unzip -q /tmp/uosc.zip -d /tmp/uosc-dl
cp -r /tmp/uosc-dl/scripts/uosc home/.config/mpv/scripts/
cp -f /tmp/uosc-dl/fonts/uosc_icons.otf /tmp/uosc-dl/fonts/uosc_textures.ttf home/.config/mpv/fonts/
rm -f home/.config/mpv/scripts/uosc/bin/ziggy-darwin home/.config/mpv/scripts/uosc/bin/ziggy-windows.exe
curl -L -o home/.config/mpv/scripts/thumbfast.lua https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.lua
curl -L -o home/.config/mpv/script-opts/uosc.conf https://github.com/tomasklaen/uosc/releases/latest/download/uosc.conf
curl -L -o /tmp/thumbfast.conf https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.conf
cp /tmp/thumbfast.conf home/.config/mpv/script-opts/thumbfast.conf
./install-config
```

Options live in `home/.config/mpv/script-opts/{uosc,thumbfast}.conf` — those files
carry local edits, so check `git diff` before overwriting them.

Layout of `home/.config/mpv`:

| Path                   | Purpose                                                     |
| ---------------------- | ----------------------------------------------------------- |
| `mpv.conf`             | GPU/hwdec, subtitle placement, `osc=no` (uosc draws the UI)  |
| `input.conf`           | keybinds (`Shift+←/→` 30s seek, `` ` `` speed, `Shift+a/s/f`) |
| `scripts/screenshot.lua` | `s` save window shot, `Shift+v` copy last, `Shift+w` copy frame |
| `scripts/thumbfast.lua`  | seekbar thumbnail previews (needs `fonts/`)                 |
| `scripts/uosc/`        | vendored uosc 5.13.0                                        |
| `fonts/`               | uosc icon/texture fonts — **required**                      |

Screenshots go to `~/Pictures/mpv-shot-<timestamp>.png`; override with
`screenshot_dir` in `script-opts/screenshot.conf`.

### Local patches to vendored uosc

Two edits are applied to `scripts/uosc/main.lua` and are **lost on re-download**:

1. `open_subtitles_api_key = ''` — uosc ships a hardcoded OpenSubtitles key.
2. `download_command` removed from the subtitles menu opener — subtitles come
   from the files themselves, so the downloader is not wanted.

Re-apply both after any uosc update.

## Not synced

- `~/.config/omarchy/calendars.json` — private feed URL (secret)
- `displays.json` / monitor layout — per-machine
- app data, browser profiles, vaults
- `~/.oh-my-zsh` — installed by `runs/yay/zsh`
- the wallpaper image itself — only the background *path* is recorded. Theme-shipped backgrounds are recreated by `omarchy theme set`; custom wallpapers are not copied to the repo and must already exist on the new PC.
