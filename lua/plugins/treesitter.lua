return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = { "ruby", "embedded_template", "javascript" },
			auto_install = true,
			highlight = { enable = true },
		})
	end,
}
