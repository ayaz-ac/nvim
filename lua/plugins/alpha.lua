return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("c", "  Configuration", ":cd ~/.config/nvim | :Telescope find_files<CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
		}

		alpha.setup(dashboard.opts)
	end,
}
