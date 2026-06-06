-- Hyprland Lua config (migrated from hyprland.conf for v0.55+)
-- https://wiki.hypr.land/Configuring/Start/
--
-- Anything marked "TODO" hasn't been verified against the wiki yet.
--
-- This file is intentionally tiny: it just loads the modules in conf/.
-- Jump straight to the section you want by opening the matching file:
--
--   conf/monitors.lua      monitors + workspace->monitor pinning
--   conf/programs.lua      shared program/var globals (terminal, mainMod, ...)
--   conf/autostart.lua     hyprland.start exec list
--   conf/environment.lua   env vars
--   conf/looknfeel.lua     general/decoration/animations/dwindle/master/misc
--   conf/input.lua         keyboard/mouse/touchpad + per-device
--   conf/keybindings.lua   all binds
--   conf/windowrules.lua   window rules
--
-- Order matters: programs.lua defines globals used by autostart + keybindings,
-- so it must load before them.

local confDir = os.getenv("HOME") .. "/.config/hypr/conf/"

local function load(module)
	dofile(confDir .. module .. ".lua")
end

load("monitors")
load("programs")
load("autostart")
load("environment")
load("looknfeel")
load("input")
load("keybindings")
load("windowrules")
