-- git remap
vim.keymap.set("n", "<leader>gs", ":Git<CR>", {})
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", {})
vim.keymap.set("n", "<leader>gg", ":Gitsigns stage_hunk<CR>", {})
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
vim.keymap.set("n", "]g", ":Gitsigns next_hunk<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[g", ":Gitsigns prev_hunk<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", {})

-- undotree
vim.keymap.set("n", "<leader>vu", ":UndotreeToggle<CR>", {})

-- supermaven
vim.keymap.set("n", "<leader>sp", ":SupermavenStop<CR>")

-- oil
vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- CellularAutomaton
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")
