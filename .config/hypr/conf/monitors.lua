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

-- Fallback / catch-all rule: applies to any output not matched above (e.g. when
-- DP-4 and DP-2 are both powered off and a different/headless output appears).
-- Without this, losing all explicit outputs drops Hyprland into safe mode.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-- Workspace -> monitor pinning
-- TODO: verify `default = true` field name on the workspace-rules wiki page.
hl.workspace_rule({ workspace = "1", monitor = "DP-4", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-4", default = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", default = true })
