return {
	"Shatur/neovim-session-manager",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	config = function()
		local Path = require("plenary.path")
		local config = require("session_manager.config")

		require("session_manager").setup({
			sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"), -- Directory to save sessions
			autoload_mode = config.AutoloadMode.CurrentDir, -- Change this to use the current directory or Git
			autosave_last_session = true, -- Autosave session when exiting Neovim
			autosave_ignore_not_normal = true, -- Ignore autosave when Neovim isn't in normal mode
			autosave_only_in_git = true, -- Only autosave sessions in Git repositories
		})
	end,
}
