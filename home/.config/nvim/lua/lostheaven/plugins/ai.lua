return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				ignore_filetypes = { cpp = true },
				color = {
					suggestion_color = "#ffffff",
					cterm = 244,
				},
				log_level = "info", -- set to "off" to disable logging completely
				disable_inline_completion = false, -- disables inline completion for use with cmp
				disable_keymaps = false, -- disables built in keymaps for more manual control
			})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					openai = function()
						return require("codecompanion.adapters").extend("openai", {
							schema = {
								model = {
									default = "gpt-4.1",
								},
							},
						})
					end,
				},
			})
		end,
	},
	{
		"yetone/avante.nvim",
		enabled = true,
		lazy = true,
		event = "VeryLazy", -- Load only after Neovim is fully started
		priority = 900,
		version = false, -- set this if you want to always pull the latest change
		opts = {
			provider = "copilot",
			auto_suggestion_provider = "copilot",
			behaviour = {
				auto_suggestions = false, -- Experimental stage
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = true,
				enable_token_counting = true,
				enable_cursor_planning_mode = true,
				enable_claude_text_editor_tool_mode = true,
				minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
			},
			providers = {
				copilot = {
					model = "gpt-4.1",
					timeout = 10 * 60 * 1000,
					extra_request_body = {
						temperature = 0,
						max_tokens = 80000,
					},
					max_completion_tokens = 80000,
					reasoning_effort = "high",
				},
				-- cp_gpt4o = {
				--   __inherited_from = "copilot",
				--   timeout = 30000, -- Timeout in milliseconds
				--   extra_request_body ={
				--   temperature = 0,
				--   },
				--   -- max_tokens = 4096,
				-- },
				-- cp_sonnet_35 = {
				--   __inherited_from = "copilot",
				--   model = "claude-3.5-sonnet",
				--   timeout = 30000, -- Timeout in milliseconds
				--   extra_request_body = {
				--     temperature = 0,
				--   },
				--   -- max_tokens = 4096,
				-- },
				-- cp_sonnet_37 = {
				--   __inherited_from = "copilot",
				--   model = "claude-3.7-sonnet",
				--   timeout = 30000, -- Timeout in milliseconds
				--   extra_request_body = {
				--     temperature = 0,
				--   },
				--   -- max_tokens = 4096,
				--   -- disable_tools = true,
				-- },
				-- cp_claude_thinking = {
				--   __inherited_from = "copilot",
				--   model = "claude-3.7-sonnet-thought",
				--   timeout = 30000, -- Timeout in milliseconds
				--   extra_request_body = {
				--     temperature = 0,
				--   },
				--   -- max_tokens = 4096,
				-- },
				-- -- Available
				-- copilot_o1 = {
				--   __inherited_from = "copilot",
				--   model = "o1",
				-- },
				-- -- Available
				-- copilot_o3_mini = {
				--   __inherited_from = "copilot",
				--   model = "o3-mini",
				-- },
				-- -- Unavailable
				-- copilot_gemini = {
				--   __inherited_from = "copilot",
				--   model = "gemini-2.0-flash-001",
				-- },
			},
		},
		build = "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				event = "InsertEnter",
				config = function()
					require("copilot").setup({
						panels = { enabled = false },
						suggestion = {
							enabled = true,
							auto_trigger = true,
							hide_during_completion = true,
							debounce = 75,
							keymap = {
								accept = "<C-M-y>",
								accept_word = false,
								accept_line = false,
								next = "<C-M-n>",
								prev = "<C-M-p>",
								dismiss = "<C-Esc>",
							},
						},
						filetypes = {
							["*"] = false,
						},
					})
				end,
			},
			-- {
			--   -- support for image pasting
			--   "HakonHarnes/img-clip.nvim",
			--   event = "VeryLazy",
			--   opts = {
			--     -- recommended settings
			--     default = {
			--       embed_image_as_base64 = false,
			--       prompt_for_file_name = false,
			--       drag_and_drop = {
			--         insert_mode = true,
			--       },
			--       -- required for Windows users
			--       use_absolute_path = true,
			--     },
			--   },
			-- },
		},
		keys = {
			{
				"<leader>at",
				function()
					require("avante").toggle()
				end,
				desc = "avante: toggle",
			},
			{
				"<leader>aA",
				function()
					vim.cmd("Copilot! attach")
					vim.notify("Copilot attached", vim.log.levels.INFO, { title = "avante" })
				end,
				desc = "avante: attach Copilot",
			},
			{
				"<leader>aD",
				function()
					vim.cmd("Copilot! detach")
					vim.notify("Copilot detached", vim.log.levels.INFO, { title = "avante" })
				end,
				desc = "avante: detach Copilot",
			},
		},
	},
}
