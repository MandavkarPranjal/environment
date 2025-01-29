return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = ...,
		config = function()
			-- require("gruvbox").setup({})
			-- vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",

		config = function()
			vim.cmd("colorscheme rose-pine")
			-- vim.cmd("colorscheme rose-pine-main")
			-- vim.cmd("colorscheme rose-pine-moon")
			-- vim.cmd("colorscheme rose-pine-dawn")

			-- transparent background
			-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
}
