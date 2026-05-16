-- Hyprland Lua config (migrated from hyprland.conf for v0.55+)
-- https://wiki.hypr.land/Configuring/Start/
--
-- Anything marked "TODO" hasn't been verified against the wiki yet.

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- DP-4 = Front Monitor, DP-2 = Right Monitor
-- TODO: bitdepth/cm/hdr/sdrbrightness/sdrsaturation field names not shown in
-- the example. Folding them into the legacy mode string is the safe fallback
-- since Hyprland still accepts that format. Verify proper Lua fields on the wiki.
hl.monitor({
	output = "DP-4",
	mode = "2560x1440@144,0x0,1,bitdepth,10,cm,hdr,sdrbrightness,1.2,sdrsaturation,1.0",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "DP-2",
	mode = "2560x1440@144,2560x0,1,bitdepth,10,cm,hdr,sdrbrightness,1.2,sdrsaturation,1.0",
	position = "2560x0",
	scale = 1,
})

-- Workspace -> monitor pinning
-- TODO: verify `default = true` field name on the workspace-rules wiki page.
hl.workspace_rule({ workspace = "1", monitor = "DP-4", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-4", default = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", default = true })

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "ghostty"
local fileManager = "nautilus"
local menu = "rofi -show drun"
local aiChat =
	'zen-browser --class zen-chat --new-window --new-tab "https://chatgpt.com/?model=gpt-5" --new-tab "https://claude.ai/new"'

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.exec_cmd("gnome-keyring-daemon --start --components=secrets"))
	hl.dispatch(hl.dsp.exec_cmd("waybar"))
	hl.dispatch(hl.dsp.exec_cmd("hyprpaper"))
	hl.dispatch(hl.dsp.exec_cmd("hyprshot"))
	hl.dispatch(hl.dsp.exec_cmd("swaync"))
	hl.dispatch(hl.dsp.exec_cmd(os.getenv("HOME") .. "/dev/SimplifyJobsDaemon/SimplifyJobsDaemon"))
	hl.dispatch(hl.dsp.exec_cmd(os.getenv("HOME") .. "/dev/SimplifyJobsDaemon/SimplifyInternDaemon"))
	hl.dispatch(hl.dsp.exec_cmd("/home/rgmatr1x/dev/open/2pyprland/pyprland/run-pyprland.sh"))
	hl.dispatch(hl.dsp.exec_cmd(aiChat .. " & sleep 2 && hyprctl dispatch focuswindow class:zen-beta && pypr send C"))
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- Keep desktop awake when accessing via ssh
hl.env("WLR_DRM_DEVICES", "/dev/dri/card2")
hl.env("HYPRCURSOR_SIZE", "30")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "30")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 5,

		border_size = 1,

		col = {
			active_border = "rgb(00ff99)",
			inactive_border = "rgb(595959)",
		},

		resize_on_border = false,
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a, -- rgba(1a1a1aee) -> 0xAARRGGBB
		},

		blur = {
			enabled = true,
			size = 4,
			passes = 2,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- NOTE: your old hyprlang values were durations (3, 2, 1, 1.5...). Keeping those
-- numbers as-is for `speed`. The example uses larger speed values (10, 5.39...)
-- which behave very differently. Adjust to taste.
hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.5, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = -0.55,

		touchpad = {
			natural_scroll = false,
			scroll_factor = 0.5,
		},
	},
})

-- Per-device config
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Apps & window management
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Y", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("zen-browser"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + F1", hl.dsp.exec_cmd("bluetoothctl connect 40:B3:FA:C3:63:34"))
hl.bind("SUPER + SHIFT + F1", hl.dsp.exec_cmd("bluetoothctl disconnect 40:B3:FA:C3:63:34"))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move/swap active window with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Resize active window with mainMod + ALT + hjkl
-- TODO: the example only demos drag-resize. Numeric delta-resize field name
-- is my best guess. Verify on https://wiki.hypr.land/Configuring/Basics/Binds/
-- Resize active window with mainMod + ALT + hjkl
hl.bind(mainMod .. " + ALT + h", hl.dsp.window.resize({ x = -20, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + ALT + l", hl.dsp.window.resize({ x = 20, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + ALT + k", hl.dsp.window.resize({ x = 0, y = -20 }), { repeating = true })
hl.bind(mainMod .. " + ALT + j", hl.dsp.window.resize({ x = 0, y = 20 }), { repeating = true })

-- Workspaces 1-9
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Special workspaces (scratchpads)
local specials = { "a", "d", "w", "g", "0" }
for _, key in ipairs(specials) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.workspace.toggle_special(key))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "special:" .. key }))
end

-- Pyprland scratchpads
local pypr = "/home/rgmatr1x/dev/open/pyprland/.venv/bin/pypr"
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(pypr .. " stash_toggle S"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(pypr .. " stash_send S"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(pypr .. " stash_toggle C"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(pypr .. " stash_send C"))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Custom: toggle waybar visibility
hl.bind("SUPER + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Suppress maximize events from all apps
local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})
