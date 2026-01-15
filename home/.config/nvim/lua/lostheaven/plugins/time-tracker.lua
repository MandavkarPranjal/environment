return {
	{
		"voltycodes/areyoulockedin.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("areyoulockedin").setup({
				session_key = "cb56ee32-9836-4049-8f1d-6e284a839bdb",
			})
		end,
	},

	{ "wakatime/vim-wakatime", lazy = false },
}
