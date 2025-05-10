require("lostheaven.set")
require("lostheaven.remap")
require("lostheaven.premap")
require("lostheaven.lazy")
require("lostheaven.video")

local augroup = vim.api.nvim_create_augroup
local lostheaven_group = augroup("Lostheaven", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("highlight_yank", {})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 80,
		})
	end,
})

-- remove white space except for Markdown files
autocmd({ "BufWritePre" }, {
	group = lostheaven_group,
	pattern = { "*" },
	callback = function()
		local ft = vim.bo.filetype
		if ft ~= "markdown" then
			vim.cmd([[ %s/\s\+$//e ]])
		end
	end,
})

-- Prevent lsp from overwriting treesitter color setting
vim.highlight.priorities.semantic_tokens = 95

-- Appearance of diagnostics
vim.diagnostic.config({
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- enable TS highlight whenever I enter gleam or conf file
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*/hypr/*.conf", "*.gleam" },
	callback = function()
		vim.cmd("TSBufEnable highlight")
	end,
})
