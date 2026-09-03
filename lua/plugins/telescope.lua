return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = function()
			local theme = "dropdown"
      local telescope = require("telescope")

			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"^%.git/",         -- .git directory
						"%.env$",          -- .env files
						"%.env%..*",       -- .env.local, .env.production, etc.
						"%.key$",          -- private key files
						"master%.key$",    -- Rails master key
					},
				},
				pickers = {
					find_files = {
						theme = theme,
						previewer = false,
						hidden = true, -- Show hidden/dotted files
					},
					buffers = {
						theme = theme,
						previewer = false,
						sort_mru = true, -- Sort by most recently used
						ignore_current_buffer = true, -- Exclude the current buffer from the list
					},
				},
			})

      telescope.load_extension("live_grep_args")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Telescope list open buffers"})
		end,
	},
}
