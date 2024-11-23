return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
      window = {
        position = 'right'
      },
			filesystem = {
				filtered_items = {
					visible = true, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
				},
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
				},
			},
		})

		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
	end,
}
