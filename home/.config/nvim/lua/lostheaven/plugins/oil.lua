return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = false,
				columns = {
					"icon",
					-- "permissions",
					-- "size",
					-- "mtime",
				},
				view_options = {
					show_hidden = true,
					natural_order = true,
				},
				win_options = {
					wrap = true,
				},
			})
		end,
	},
}
