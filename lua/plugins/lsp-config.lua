return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ruby_lsp" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local function get_ruby_lsp_cmd()
				-- Check if ruby-lsp is available in the Bundler environment
				local handle = io.popen("bundle exec ruby-lsp --version 2>/dev/null")
				local result = handle:read("*a")
				handle:close()

				if result and result ~= "" then
					-- ruby-lsp found in Bundler, return the Bundler command
					return { "bundle", "exec", "ruby-lsp" }
				else
					-- Fallback to global ruby-lsp
					return { "ruby-lsp" }
				end
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.ruby_lsp.setup({
				cmd = get_ruby_lsp_cmd(),
				filetypes = { "ruby" },
				init_options = {
					enabledFeatures = {
						codeActions = true,
						completion = true,
						definition = true,
						documentHighlights = true,
						hover = true,
						inlayHint = true,
					},
					linters = {},
					formatter = nil,
					experimentalFeaturesEnabled = false,
				},
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for symbol" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
