---------------------
---- MY PROGRAMS ----
---------------------

-- NOTE: these are intentionally GLOBALS (no `local`) so that the other modules
-- loaded from hyprland.lua (autostart, keybindings) can reference them. Lua
-- `local`s do not cross file boundaries when files are loaded separately.

terminal = "ghostty"
fileManager = "nautilus"
menu = "rofi -show drun"
aiChat =
	'zen-browser --class zen-chat --new-window --new-tab "https://chatgpt.com/?model=gpt-5" --new-tab "https://claude.ai/new"'

-- Modifier used by every keybinding
mainMod = "SUPER"

-- Pyprland scratchpad CLI
pypr = "/home/rgmatr1x/dev/open/pyprland/.venv/bin/pypr"
