# dotfiles

Arch Linux + Hyprland setup, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Everything under `home/` mirrors `~` and is symlinked into place.

## Install

```sh
git clone git@github.com:gkerr708/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup/arch.sh          # packages (pacman + AUR), stow links, services. Safe to re-run.
```

`setup/arch.sh` moves any real file that would block a link to `<file>.bak` first.
After changing what's in `home/`, re-link with:

```sh
stow --restow home       # run from ~/dotfiles
```

Optional, per-machine setup (see [docs/hardware.md](docs/hardware.md)):

| Script | What it does |
|---|---|
| `sudo ./setup/gpu-limit.sh` | Desktop: RX 6800 power/clock cap at boot (small PSU) |
| `sudo ./setup/cpu-limit.sh` | Desktop: disable CPU boost (thermals) |
| `sudo ./setup/power-profiles.sh` | Laptop: performance on AC, balanced on battery |
| `./setup/guitar.sh` | Carla/NAM guitar rig + low-latency PipeWire service |

## Layout

```
setup/                  one-off install scripts (not stowed)
docs/                   cheatsheets and setup notes
home/                   stow package -> ~
├── .bashrc             core shell setup; sources ~/.config/bash/*.bash
├── .config/
│   ├── bash/           env.bash, aliases.bash, functions.bash
│   ├── hypr/           Hyprland (Lua config, split by topic)
│   ├── waybar/         bar config + scripts/ (JSON modules: cpu, gpu, vram, weather, power)
│   ├── nvim/           Neovim (lazy.nvim)
│   └── ...             kitty, tmux, yazi, wofi, rofi, mpv, zathura, ...
├── .local/bin/         personal commands (on PATH)
└── latex_templates/    used by new-tex
```

## Where scripts go

* **A command you run yourself** → `home/.local/bin/<name>` (no `.sh`, `chmod +x`). It's on `PATH`, so no alias needed.
* **A helper that belongs to one program** → next to that program's config, e.g. `home/.config/waybar/scripts/`, `home/.config/tmux/`. Reference it by full path from that config (waybar/Hyprland don't read `.bashrc`).
* **System setup that needs root or runs once** → `setup/`.

Start scripts with `#!/bin/bash` and `set -euo pipefail`. Leave out `-e` where a failing command is expected and handled. Waybar scripts skip strict mode so a missing sensor hides the module instead of breaking it. Lint with `shellcheck`.

## Commands in `~/.local/bin`

| Command | |
|---|---|
| `new-tex <simple\|complex\|slides> <dir>` | New LaTeX project from `~/latex_templates` |
| `check-git-repos [--pull\|--push\|--sync]` | Status of every repo under `~/lab` |
| `maturin-uv <name>` | New Rust/Python (maturin + uv) project |
| `tmux-help` | tmux cheatsheet |
| `battery-info` | upower details for both laptop batteries |
| `corne-flash` | Build + flash the Corne keyboard ([docs/hardware.md](docs/hardware.md#corne-keyboard-qmk)) |
| `format-usb` | Wipe the Arch installer USB as exFAT |
| `guitar-latency` | Run by `guitar-latency.service`; low PipeWire buffer while a guitar app is open |
| `hypr-keybinds` | Searchable keybind list (**SUPER + /**) |
| `hypr-toggle-animations` | Reduced motion on/off (**SUPER + SHIFT + M**) |

## Docs

* [docs/arch-cheatsheet.md](docs/arch-cheatsheet.md) — USB, network, Bluetooth, pacman, time sync, …
* [docs/hardware.md](docs/hardware.md) — GPU/CPU limits, waybar monitoring, MangoHud, Ollama, guitar rig, Corne
* [docs/crkbd-cheatsheet.md](docs/crkbd-cheatsheet.md) — Corne keymap
