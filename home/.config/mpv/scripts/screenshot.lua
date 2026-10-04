-- Timestamped screenshots, optionally copied to the Wayland clipboard.
--
--   s          save the window (with OSD) to ~/Pictures
--   Shift+v    copy the last saved screenshot to the clipboard
--   Shift+w    copy a video-only frame to the clipboard

local utils = require "mp.utils"

local dir = mp.get_opt("screenshot_dir", "~/Pictures")
local copy_cmd = mp.get_opt("screenshot_copy_cmd", "wl-copy")

local last_file = nil

local function expand(p)
    return (p:gsub("^~", os.getenv("HOME") or "/"))
end

local function quote(s)
    return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function capture(mode, cb)
    local path = utils.join_path(expand(dir), "mpv-shot-" .. os.date("%Y-%m-%d-%H%M%S") .. ".png")
    mp.commandv("screenshot-to-file", path, mode)
    cb(path)
end

local function copy_to_clipboard(path)
    mp.commandv("run", "/bin/sh", "-c", "cat " .. quote(path) .. " | " .. copy_cmd .. " >/dev/null 2>&1")
end

mp.add_key_binding(nil, "screenshot/save", function()
    capture("window", function(path)
        last_file = path
        mp.osd_message("Screenshot: " .. path)
    end)
end)

mp.add_key_binding(nil, "screenshot/copy", function()
    if not last_file or not utils.file_info(last_file) then
        mp.osd_message("No screenshot to copy yet")
        return
    end
    copy_to_clipboard(last_file)
    mp.osd_message("Copied to clipboard: " .. last_file)
end)

mp.add_key_binding(nil, "screenshot/copy-video", function()
    capture("video", function(path)
        last_file = path
        copy_to_clipboard(path)
        mp.osd_message("Copied frame to clipboard")
    end)
end)
