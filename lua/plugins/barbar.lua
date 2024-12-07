return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			-- Key mappings for buffer navigation
			vim.keymap.set("n", "<Tab>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
			vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
			vim.keymap.set("n", "<leader>bd", "<Cmd>BufferClose<CR>", { desc = "Close current buffer" })
			vim.keymap.set("n", "<leader>bo", "<Cmd>BufferCloseAllButCurrent<CR>", { desc = "Close all buffers" })

			vim.g.bufferline = {
				animation = true, -- Enable/disable animations
				auto_hide = false, -- Hide the tabline when there is only one buffer
				tabpages = true, -- Display tabpages
				closable = true, -- Show close button on each buffer
				clickable = true, -- Enable clickable tabs to switch buffers or close them
				icons = "both", -- Show both filetype icons and modified status
				maximum_padding = 1, -- Maximum padding between buffer names
				maximum_length = 30, -- Maximum buffer name length
				no_name_title = "[No Name]", -- Title for unnamed buffers
			}
		end,
	},
}
