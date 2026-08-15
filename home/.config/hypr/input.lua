-- Personal input settings.
-- Ported from the pre-quattro input.conf: keyboard layout, options, and
-- touchpad behavior.

-- Mirror of the Omarchy defaults with the personal overrides applied:
--   kb_layout   "us" (hardcoded, instead of /etc/vconsole.conf)
--   kb_options  "compose:caps,ctrl:nocaps" (CapsLock is compose, Ctrl is no-caps)
--   touchpad.natural_scroll = true
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "compose:caps,ctrl:nocaps",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,

    repeat_rate = 40,
    repeat_delay = 250,
    numlock_by_default = true,

    touchpad = {
      natural_scroll = true,
      clickfinger_behavior = true,
      scroll_factor = 0.4,
    },
  },

  misc = {
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },
})

-- Scroll nicely in the terminal.
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Touchpad gestures for moving focus (helpful on scrolling layout).
hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })

-- Two-finger pinch to zoom (2x, toggle).
hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 2 })
