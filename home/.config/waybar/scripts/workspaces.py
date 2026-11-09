#!/usr/bin/env python3
"""Clickable Hyprland workspace buttons for waybar.

Waybar's built-in hyprland/workspaces module sends the old "dispatch workspace N"
command when clicked, which Hyprland rejects now that the config is Lua. So the bar
uses custom/ws1..custom/ws10 instead, and their on-click sends the Lua dispatcher.

Run with no arguments (as the exec of the hidden custom/ws-daemon module) it listens
to Hyprland's event socket, writes one JSON file per workspace into
$XDG_RUNTIME_DIR/waybar-ws/, and signals waybar (RTMIN+9) so each custom/wsN reloads
by running `workspaces.py N`, which just prints its file.
"""
import json, os, re, socket, subprocess, sys, time

STATE = os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), "waybar-ws")
SIGNAL = 9
PERSISTENT = range(1, 9)   # always shown; 9 and 10 only when used
ALL = range(1, 11)

# Icon per window, first match wins (same rules the old module used).
REWRITE = [
    ("title", r".*youtube.*", "\uf16a"),
    ("class", r"kitty", "\ue795"),
    ("class", r"firefox", "\uf269"),
    ("class", r"brave", "\uf269"),
    ("class", r"org\.kde\.dolphin|dolphin", "\uf07b"),
]
DEFAULT_ICON = "?"


def icon(client):
    for field, pattern, glyph in REWRITE:
        if re.fullmatch(pattern, client.get(field, ""), re.IGNORECASE):
            return glyph
    return DEFAULT_ICON


def hyprctl(what):
    out = subprocess.run(["hyprctl", "-j", what], capture_output=True, text=True).stdout
    try:
        return json.loads(out)
    except json.JSONDecodeError:
        return []


def render():
    monitors = hyprctl("monitors")
    clients = hyprctl("clients")
    focused = next((m["activeWorkspace"]["id"] for m in monitors if m.get("focused")), None)
    visible = {m["activeWorkspace"]["id"] for m in monitors}

    windows = {}
    for c in sorted(clients, key=lambda c: (c["at"][0], c["at"][1])):
        windows.setdefault(c["workspace"]["id"], []).append(c)

    os.makedirs(STATE, exist_ok=True)
    for n in ALL:
        ws_windows = windows.get(n, [])
        shown = n in PERSISTENT or ws_windows or n in visible
        classes = ["ws"]
        if n == focused:
            classes.append("active")
        elif n in visible:
            classes.append("visible")
        if ws_windows:
            classes.append("occupied")
        text = " ".join([str(n)] + [icon(c) for c in ws_windows]) if shown else ""
        tooltip = "\n".join(c.get("title") or c.get("class", "") for c in ws_windows) or f"Workspace {n} (empty)"
        tmp = os.path.join(STATE, f"{n}.json.tmp")
        with open(tmp, "w") as f:
            json.dump({"text": text, "class": classes, "tooltip": tooltip}, f, ensure_ascii=False)
        os.replace(tmp, os.path.join(STATE, f"{n}.json"))
    subprocess.run(["pkill", f"-RTMIN+{SIGNAL}", "-x", "waybar"])


def daemon():
    sock_path = os.path.join(os.environ["XDG_RUNTIME_DIR"], "hypr",
                             os.environ["HYPRLAND_INSTANCE_SIGNATURE"], ".socket2.sock")
    relevant = ("workspace", "focusedmon", "openwindow", "closewindow",
                "movewindow", "createworkspace", "destroyworkspace", "monitor")
    while True:
        try:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(sock_path)
            render()
            buf = b""
            while chunk := s.recv(4096):
                buf += chunk
                *lines, buf = buf.split(b"\n")
                if any(l.split(b">>")[0].decode(errors="ignore").startswith(relevant) for l in lines):
                    render()
        except OSError:
            pass
        time.sleep(1)  # Hyprland restarting, or socket not up yet


if __name__ == "__main__":
    if len(sys.argv) > 1:
        try:
            with open(os.path.join(STATE, f"{int(sys.argv[1])}.json")) as f:
                print(f.read())
        except OSError:
            pass
    else:
        daemon()
