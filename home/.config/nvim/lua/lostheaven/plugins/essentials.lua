return {
	{ "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- to fast jump to any location
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
	   -- stylua: ignore
	   keys = {
	     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
	     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
	     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
	     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
	     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	   },
	},

	-- to preview markdown files
	-- {
	-- 	"toppair/peek.nvim",
	-- 	event = { "VeryLazy" },
	-- 	build = "deno task --quiet build:fast",
	-- 	config = function()
	-- 		require("peek").setup({
	-- 			auto_load = true, -- whether to automatically load preview when
	-- 			close_on_bdelete = true, -- close preview window on buffer delete
	-- 			syntax = true, -- enable syntax highlighting, affects performance
	-- 			theme = "dark", -- 'dark' or 'light'
	-- 			update_on_change = true,
	-- 			app = "webview", -- 'webview', 'browser', string or a table of strings
	-- 			filetype = { "markdown" }, -- list of filetypes to recognize as markdown
	-- 			throttle_at = 200000, -- start throttling when file exceeds this
	-- 			throttle_time = "auto", -- minimum amount of time in milliseconds
	-- 		})
	-- 		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
	-- 		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	-- 	end,
	-- },
}
