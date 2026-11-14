# Global preferences

Personal defaults for every project. A project's own CLAUDE.md overrides these.
Machine: Arch Linux, Hyprland, bash, kitty + tmux. Dotfiles live in ~/dotfiles (GNU Stow, `home/` mirrors `~`).

## C++ terminal apps (TUIs)

Default stack and style for any new TUI. `~/Projects/crate` is a good example of all of this in practice.

**Build**
- C++23, CMake 3.20 or newer, `-Wall -Wextra`.
- Export `compile_commands.json` (`CMAKE_EXPORT_COMPILE_COMMANDS ON`) so clangd works.
- Build out of tree into `build/`: `cmake -B build -DCMAKE_BUILD_TYPE=Release`, then `cmake --build build -j`.
- UI library is **FTXUI**, fetched with `FetchContent` at a pinned tag (shallow clone). Link `ftxui::screen ftxui::dom ftxui::component`.
- Other libraries come from system packages (pacman) via `pkg_check_modules`. If a dependency is optional, guard it with a compile definition so the app still builds without it.
- README lists dependencies (pacman command, split into build-time and runtime) and how to symlink the binary into `~/.local/bin`.
- One `.cpp` + `.hpp` pair per module in `src/`, with the UI in `main.cpp`. List sources explicitly in CMake.
- Background threads trigger redraws by posting an event to the screen, never by touching UI state directly.

**Keys: vim-style, always**
- Navigate with `j`/`k` (and arrows), `h`/`l` between panes, `gg`/`G` for top/bottom (`G` with a count goes to that line), `Ctrl-d`/`Ctrl-u` half page, `Ctrl-f`/`Ctrl-b` full page. `Tab`/`Shift-Tab` cycle panes.
- Numeric counts prefix commands (`5j`). Multi-key commands use a pending-key state (`gg`, `dd`, `yy`).
- Editing commands follow vim where they make sense: `y` yank, `d` delete, `x` cut, `p`/`P` put, `V` visual select, `J`/`K` move an item.
- `/` searches, `n`/`N` step through matches, `:` opens a command line, `Esc` cancels or clears, `q` quits, `?` opens a help screen (any key closes it).
- Text inputs behave like a shell: `Ctrl-u` clears the line, `Ctrl-n`/`Ctrl-p` move through choices, `Enter` confirms, `Esc` cancels.
- A capital letter is the bigger or alternate version of its lowercase command.
- Every app has a `?` screen listing all of its keys. Keep it up to date when keys change.

**Look**
- Panes are bordered boxes with the title in the border.
- The active pane's title is bold and green. Inactive panes are dim.
- The selected row is `inverted` when its pane has focus and a gray background when it doesn't.
- Use color sparingly: green for the active or current thing, cyan for special groups, `dim` for secondary text. Avoid other loud colors.
- A one-line status bar at the bottom shows messages and hints, including a hint when a key doesn't apply in the current pane.
- Unicode symbols for state are fine.

## Python

- Use **uv** for everything: `uv init`, `uv add`, `uv run`, `uv sync`. Never `pip install` or hand-managed venvs.
- Dependencies and metadata go in `pyproject.toml`. Commit `uv.lock`.
- Run tests with `uv run pytest` and scripts with `uv run python ...`.
- Plots use matplotlib with the personal styles in `~/.config/matplotlib/stylelib`.

## General

- Edit config through the dotfiles repo (`~/dotfiles/home/...`), not the symlink in `~`. Run `stow --restow home` from `~/dotfiles` after adding files.
- Don't commit or push unless asked.
