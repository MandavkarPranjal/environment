-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Swap the main modifier from SUPER to ALT for all Omarchy defaults.
-- Every default binding that uses SUPER (and not ALT) is rebound with ALT,
-- restoring the pre-quattro layout where the physical Alt key is the main
-- modifier. Bindings that already combine SUPER + ALT are left alone.
-- The wrapper is installed only while the Omarchy defaults load; personal
-- bindings in hypr/bindings.lua are free to use SUPER again.
local real_hl_bind = hl.bind
hl.bind = function(keys, dispatcher, options)
  if type(keys) == "string" and not keys:find("ALT", 1, true) and keys:find("SUPER", 1, true) then
    keys = keys:gsub("SUPER", "ALT")
  end
  return real_hl_bind(keys, dispatcher, options)
end

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Restore the unmodified binding helper for the personal configs below.
hl.bind = real_hl_bind

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- resolve-full-opacity (added by Omarchy_resolve_v2.sh): Omarchy's default
-- window translucency is wrong for colour-critical work; keep DaVinci
-- Resolve fully opaque. Loaded after Omarchy defaults, so this rule wins.
o.window(".*[Rr]esolve.*", { opacity = "1 1" })

-- Open DaVinci Resolve's main window over the Omarchy bar instead of under it.
require("hypr.davinci-resolve")
