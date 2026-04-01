#!/usr/bin/env bash

cat << 'EOF'
===============================
         Tmux Help
===============================

Start a new session:
    tmux new -s <name>

Attach to a session:
    tmux attach -t <name>

List sessions:
    tmux ls

Kill a session:
    tmux kill-session -t <name>

Detach from a session (inside tmux):
    Ctrl-Space d

Split panes:
    Ctrl-Space %   # vertical split
    Ctrl-Space "   # horizontal split

Navigate panes:
    Ctrl-Space <arrow key>

Resize panes:
    Ctrl-Space :resize-pane -D / -U / -L / -R

Create / switch windows:
    Ctrl-Space c   # new window
    Ctrl-Space n   # next window
    Ctrl-Space p   # previous window
    Ctrl-Space w   # list windows

Kill tmux server (all sessions):
    tmux kill-server

===============================
EOF
