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
6. `./run curl` — curl-bootstrapped CLIs (`entire`, `opencode2`, `fx`, `nub`, `vp`, `cursor-agent`, `moviebox-tui`, `netbird`) and AppImages
7. `./run omarchy` — hooks, menu, shell plugins, bar layout (`shell.json` widget positions), theme + background path

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
./run curl                # curl-bootstrapped CLIs + AppImages
./run curl install-tools  # just the CLIs, skip the AppImage downloads
./run omarchy             # omarchy config (plugins, bar, theme, hooks)
./run omarchy --dry       # preview without changing anything
```

## curl-installed tools and AppImages

`./run curl` covers what no package manager tracks. Two data files drive it,
both pipe-separated with `#` comments, edited by hand and committed:

| File                       | Columns                          | Notes                                                       |
| -------------------------- | -------------------------------- | ----------------------------------------------------------- |
| `runs/curl/tools.list`     | id, url, presence check, sudo    | `check` gates the install; `sudo` is `yes` for installers writing outside `$HOME` |
| `runs/curl/appimages.list` | file name, url, presence check   | `{version}` resolves via the GitHub API, `{arch}` from `uname -m` |
| `runs/curl/stubs/`         | launcher scripts                 | copied to `~/.local/bin` by `install-stubs`                   |

Three scripts read them — `install-tools` runs the bootstrappers, `appimages`
downloads into `~/AppImages`, `install-stubs` refreshes the launcher stubs.
All are idempotent: anything whose presence check passes is skipped, so
re-running `./run curl` is cheap. A failure in one entry does not stop the
rest; the step exits non-zero if anything failed.

AppImage downloads land as `<name>.part` and are moved into place only after a
complete, non-empty transfer, so an interrupted download never leaves a
truncated AppImage that the presence check would then treat as installed.

**Not automated here:** `t3_code_alpha.appimage` has no public download URL.
Fetch it from t3.chat into `~/AppImages/t3_code_alpha.appimage` by hand.

**Deliberately absent from `tools.list`:** `zed` (already in `runs/yay/zed`) and
`tailscale` (already a pacman package).

### Launcher stubs

`runs/curl/install-stubs` writes the `~/.local/bin` entries for the AppImages,
from sources in `runs/curl/stubs/`. They are **generated, not stowed**:
`install-config` runs `stow --adopt`, which overwrites the repo copy of a file
with whatever is live at the target — so a stub kept under `home/` gets
replaced by the previous version on the next run. That is correct for dotfiles
you edit live, wrong for generated files.

Both stubs check for their AppImage and print how to fetch it if missing.

### Two tools mise also installs

`agy` and `grok` have mise copies as well as the curl builds in `tools.list`.
The curl builds are the ones running:

| Tool  | Used                                | Shadowed                              |
| ----- | ----------------------------------- | ------------------------------------- |
| `agy` | `~/.local/bin/agy` 1.1.12           | mise `antigravity-cli` 1.2.14         |
| `grok`| `~/.grok/bin/grok` 1.0.46           | mise `npm:@xai-official/grok` stub    |

`grok` wins only because its `PATH` line sits *after* the `~/.local/bin` line
in `.zshrc`. Reordering those silently hands `grok` to mise. Both `tools.list`
and `.zshrc` carry comments saying so. To go back to the mise builds, drop the
`agy` entry from `home/.config/mise/config.toml`, delete `~/.local/bin/agy`,
and remove the grok installer block from `.zshrc`.

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
- mise-installed tools beyond `config.toml` — extra tools the machine accumulated (`aube`, `cmake`, `golangci-lint`, `java`, `node`, `staticcheck`, `uv`, `zig`, `zls`, …) are not in `home/.config/mise/config.toml`. Add the ones you want to keep.

## LosslessCut GUI launches were failing

The old `~/.local/bin/losslesscut` stub passed `--no-sandbox`, which LosslessCut
rejects — it exits 9 with `bad option`. The stub also piped stderr to
`/dev/null`, which hid the error, so `losslesscut.desktop` launches failed
quietly. The stub in `runs/curl/stubs/losslesscut` drops the flag and keeps
stderr visible.
