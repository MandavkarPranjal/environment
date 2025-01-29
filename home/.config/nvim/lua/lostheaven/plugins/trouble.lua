---@diagnostic disable: missing-parameter
return {
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup()

			vim.keymap.set("n", "<leader>to", "<cmd>Trouble diagnostics<CR>")

			vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle()
			end)

			vim.keymap.set("n", "]t", function()
				require("trouble").next()
			end)

			vim.keymap.set("n", "[t", function()
				require("trouble").prev()
			end)
		end,
	},
}
