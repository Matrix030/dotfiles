-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- `aiChat` comes from conf/programs.lua (loaded before this module).
hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.exec_cmd("gnome-keyring-daemon --start --components=secrets"))
	hl.dispatch(hl.dsp.exec_cmd("waybar"))
	hl.dispatch(hl.dsp.exec_cmd("hyprpaper"))
	hl.dispatch(hl.dsp.exec_cmd("hyprshot"))
	hl.dispatch(hl.dsp.exec_cmd("swaync"))
	hl.dispatch(hl.dsp.exec_cmd(os.getenv("HOME") .. "/dev/SimplifyJobsDaemon/SimplifyJobsDaemon"))
	hl.dispatch(hl.dsp.exec_cmd(os.getenv("HOME") .. "/dev/SimplifyJobsDaemon/SimplifyInternDaemon"))
	hl.dispatch(hl.dsp.exec_cmd("pypr"))
	hl.dispatch(hl.dsp.exec_cmd(aiChat .. " & sleep 2 && hyprctl dispatch focuswindow class:zen-beta && pypr stash_send C"))
end)
