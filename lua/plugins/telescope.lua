return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local theme = "dropdown"
			require("telescope").setup({
				pickers = {
					find_files = {
						theme = theme,
						previewer = false,
						find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
					},
					buffers = {
						theme = theme,
						previewer = false,
						sort_mru = true, -- Sort by most recently used
						ignore_current_buffer = true, -- Exclude the current buffer from the list
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
}
