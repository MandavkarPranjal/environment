return {
	"kyazdani42/nvim-tree.lua",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	lazy = false,
	keys = {
		{ "<leader>fh", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in filetree" },
		{ "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Find file in filetree" },
	},
	opts = {
		git = {},
		view = {
			adaptive_size = true,
			float = {
				enable = true,
			},
		},
	},
}
