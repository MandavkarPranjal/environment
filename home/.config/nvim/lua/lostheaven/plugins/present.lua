return {
	{
		"present",
		dir = vim.fn.stdpath("config") .. "/lua/lostheaven/custom",
		name = "present",
		config = function()
			require("lostheaven.custom.present").setup()
		end,
	},
}
