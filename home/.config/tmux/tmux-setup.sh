#!/usr/bin/env bash

# kill all existing sessions
#tmux kill-server
# Check if tmux server is running and kill it if it is
if tmux ls &>/dev/null; then
	  tmux kill-server
	  echo "Killed existing tmux server."
fi

# create the base session
tmux new -Ad -s master -c "$HOME"

# create grouped sessions that share windows with 'master'
tmux new -Ad -s alt  -t master
tmux new -Ad -s main -t master

# Add windows to the 'master' session ['o', 'oo', 'test', 'dev']
tmux rename-window -t master:0 'o'   # use :1 if you have base-index 1
tmux new-window  -t master -n 'oo'   -c "$HOME"
tmux new-window  -t master -n 'test' -c "$HOME"
tmux new-window  -t master -n 'dev'  -c "$HOME"

tmux attach -t main

echo "Tmux sessions 'master', 'alt', and 'main' created with shared windows."
echo "Use 'tmux attach -t <session-name>' to attach to a session."
