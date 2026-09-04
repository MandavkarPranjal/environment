-- Personal keybindings.
-- Ported from the pre-quattro bindings.conf and bindings-override.conf.
--
-- The SUPER -> ALT swap of Omarchy's defaults happens in hyprland.lua; the
-- entries below are the bindings the defaults don't already provide, plus the
-- handful the old override handled specially (TAB/PRINT/monitor groups) that
-- need explicit unbinds because the swapped defaults would collide.

-- ---------------------------------------------------------------- Applications
hl.unbind("ALT + RETURN")
o.bind("ALT + RETURN", "Terminal", [[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"]])

hl.unbind("SUPER + ALT + RETURN")
o.bind(
	"SUPER + ALT + RETURN",
	"Tmux",
	[[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "exec tmux new-session -A -s Work"]]
)

hl.unbind("ALT + SHIFT + RETURN")
o.bind("ALT + SHIFT + RETURN", "Browser", "omarchy-launch-browser")

hl.unbind("ALT + SHIFT + F")
o.bind("ALT + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window")

hl.unbind("SUPER + ALT + SHIFT + F")
o.bind(
	"SUPER + ALT + SHIFT + F",
	"File manager (cwd)",
	[[uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"]]
)

hl.unbind("ALT + SHIFT + B")
o.bind("ALT + SHIFT + B", "Browser", "omarchy-launch-browser")

hl.unbind("SUPER + SHIFT + ALT + B")
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", "omarchy-launch-browser --private")

-- ------------------------------------------------------------------------ OCR
hl.unbind("ALT + CTRL + PRINT")
o.bind("ALT + SHIFT + O", "Extract text (OCR) from screenshot", "omarchy-capture-text")

-- -------------------------------------------------------------- Screenshot trio
-- The old override flipped screenrecording and the color picker, and moved
-- OCR away from the Print key entirely.
hl.unbind("ALT + PRINT")
hl.unbind("SUPER + PRINT")
o.bind(
	"SUPER + PRINT",
	"Screenrecording",
	[[omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord]]
)
o.bind("ALT + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")

-- -------------------------------------------------------------- Hold + scroll
-- SUPER + scroll zooms (workspace scrolling is the swapped ALT + scroll).
hl.unbind("SUPER + mouse_down")
hl.unbind("SUPER + mouse_up")
hl.unbind("SUPER + SHIFT + mouse_down")
o.bind("SUPER + mouse_down", "Zoom in", function()
	local zoom = hl.get_config("cursor.zoom_factor") or 1
	hl.config({ cursor = { zoom_factor = math.min(zoom * 1.5, 30) } })
end)
o.bind("SUPER + mouse_up", "Zoom out", function()
	local zoom = hl.get_config("cursor.zoom_factor") or 1
	hl.config({ cursor = { zoom_factor = math.max(zoom * 0.67, 1) } })
end)
o.bind("SUPER + SHIFT + mouse_down", "Reset zoom", function()
	hl.config({ cursor = { zoom_factor = 1 } })
end)

-- ------------------------------------------------------------- Wayscriber
o.bind("SUPER + D", "Wayscriber", "wayscriber --daemon-toggle")

-- ----------------------------------------------------------------- Launchers
-- ALT + SPACE opens the app launcher (old omarchy-launch-walker / launch-app);
-- SUPER + SPACE and SUPER + ALT + SPACE open the Omarchy root menu.
hl.unbind("ALT + SPACE")
o.bind("ALT + SPACE", "Launch apps", "omarchy-menu toggle apps")
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")
hl.unbind("SUPER + ALT + SPACE")
o.bind("SUPER + ALT + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- ------------------------------------------------------ TAB / monitor groups
-- The old override moved window cycling from ALT + TAB to SUPER + TAB so that
-- ALT + TAB could switch workspaces.
hl.unbind("ALT + TAB")
hl.unbind("ALT + SHIFT + TAB")
o.bind("ALT + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("ALT + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + TAB", "Focus on next window", hl.dsp.window.cycle_next())
o.bind("SUPER + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
o.bind("SUPER + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
o.bind("SUPER + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

hl.unbind("CTRL + ALT + TAB")
o.bind("CTRL + SUPER + TAB", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
hl.unbind("CTRL + ALT + SHIFT + TAB")
o.bind("CTRL + SUPER + SHIFT + TAB", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

-- ---------------------------------------------------------------- Close all
hl.unbind("CTRL + ALT + DELETE")
o.bind("CTRL + SUPER + DELETE", "Close all windows", "omarchy-hyprland-window-close-all")

-- -------------------------------------------------------- Audio / brightness
-- Precise controls move from ALT (the new main modifier) to SUPER.
hl.unbind("ALT + XF86AudioRaiseVolume")
o.bind(
	"SUPER + XF86AudioRaiseVolume",
	"Volume up precise",
	"omarchy-audio-output-volume +1",
	{ locked = true, repeating = true }
)
hl.unbind("ALT + XF86AudioLowerVolume")
o.bind(
	"SUPER + XF86AudioLowerVolume",
	"Volume down precise",
	"omarchy-audio-output-volume -1",
	{ locked = true, repeating = true }
)
hl.unbind("ALT + XF86MonBrightnessUp")
o.bind(
	"SUPER + XF86MonBrightnessUp",
	"Brightness up precise",
	"omarchy-brightness-display +1%",
	{ locked = true, repeating = true }
)
hl.unbind("ALT + XF86MonBrightnessDown")
o.bind(
	"SUPER + XF86MonBrightnessDown",
	"Brightness down precise",
	"omarchy-brightness-display 1%-",
	{ locked = true, repeating = true }
)

-- Switch audio output on ALT + Mute.
o.bind("ALT + XF86AudioMute", "Switch audio output", "omarchy-audio-output-switch", { locked = true })
