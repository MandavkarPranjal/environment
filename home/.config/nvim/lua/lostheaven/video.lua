-- video.lua
-- Provides :Record, :RecordHQ, :RecordStop and :Screenshot on Linux via ffmpeg + x11grab
-- Now uses PTY mode and sends 'q' to ffmpeg for a clean stop (so the MP4 trailer is written).

local M = {}

-- Run a shell command and return its stdout (or nil on failure)
local function exec(cmd)
	local out = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return out
end

-- Probe X11 for your screen resolution (WxH)
local function get_screen_size()
	local info = exec([[xdpyinfo | grep dimensions]])
	if not info then
		return "1920x1080"
	end
	local w, h = info:match("dimensions:%s*(%d+)x(%d+)")
	if w and h then
		return w .. "x" .. h
	end
	return "1920x1080"
end

-- Generic recorder launcher
-- framerate: number
-- filter_str: string for -filter:v
-- extra_opts: string for any extra ffmpeg flags (e.g. presets)
-- suffix: string appended to filename before extension
local function start_record(framerate, filter_str, extra_opts, suffix)
	local name = vim.fn.expand("%:t")
	local ts = os.date("%Y-%m-%d_%H-%M-%S")
	local fn = string.format("%s(%s)%s.mp4", name, ts, suffix or "")
	local out = vim.fn.expand("~/Movies/") .. fn
	local display = os.getenv("DISPLAY") or ":0.0"
	local size = get_screen_size()
	local logf = vim.fn.expand("~/Movies/ffmpeg-record.log")

	-- Build ffmpeg command, redirect stderr to log
	local cmd = string.format(
		[[
    ffmpeg -y \
      -f x11grab \
      -video_size %s \
      -framerate %d \
      -i %s+0,0 \
      -filter:v "%s" \
      %s \
      "%s" 2>>"%s"
  ]],
		size,
		framerate,
		display,
		filter_str,
		extra_opts or "",
		out,
		logf
	)

	print(("Recording → %s\n(check %s for ffmpeg debug output)"):format(out, logf))
	-- use pty=true so we can send 'q'
	local job_id = vim.fn.jobstart(cmd, { pty = true })
	vim.g.recording_job_id = job_id
end

-- Low-latency 30fps
function M.aesthetic_record()
	local filter = "crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0"
	start_record(30, filter, "-preset ultrafast", "")
end

-- High-quality 60fps
function M.aesthetic_record_hq()
	local filter = "crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=7:7:1.0:7:7:0.0"
	start_record(60, filter, "-crf 18 -preset ultrafast", "_hq")
end

-- Stop ffmpeg cleanly by sending 'q' over the PTY
function M.stop_record()
	local job_id = vim.g.recording_job_id
	if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
		vim.fn.chansend(job_id, "q")
		print("Recording stopped (sent 'q' to ffmpeg).")
		vim.g.recording_job_id = nil
	else
		print("No active recording!")
	end
end

-- One-shot screenshot via x11grab
function M.aesthetic_screenshot()
	local name = vim.fn.expand("%:t")
	local ts = os.date("%Y-%m-%d_%H-%M-%S")
	local fn = string.format("%s(%s).png", name, ts)
	local out = vim.fn.expand("~/Pictures/") .. fn
	local display = os.getenv("DISPLAY") or ":0.0"
	local size = get_screen_size()

	local cmd = string.format(
		[[
    ffmpeg -y \
      -f x11grab \
      -video_size %s \
      -i %s+0,0 \
      -frames:v 1 \
      -filter:v "crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0" \
      "%s"
  ]],
		size,
		display,
		out
	)

	local res = vim.fn.system(cmd)
	local code = vim.v.shell_error
	if code ~= 0 then
		vim.notify("Screenshot failed:\n" .. res, vim.log.levels.ERROR)
	else
		vim.notify("Screenshot saved → " .. out, vim.log.levels.INFO)
	end
end

-- Expose commands
vim.api.nvim_create_user_command("Record", M.aesthetic_record, {})
vim.api.nvim_create_user_command("RecordHQ", M.aesthetic_record_hq, {})
vim.api.nvim_create_user_command("RecordStop", M.stop_record, {})
vim.api.nvim_create_user_command("Screenshot", M.aesthetic_screenshot, {})

return M
