return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = { "ts_ls", "lua_ls", "ruby_lsp", "biome" },
      auto_install = true
    }
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.ruby_lsp.setup({
        root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git")
      })
      lspconfig.ts_ls.setup({})

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc= 'Go to definition' })
      vim.keymap.set("n", "<leader>gr", function()
        require("telescope.builtin").lsp_references()
      end, { desc= 'Show references with Telescope'})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc= 'Code actions'})
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc= 'Rename' })
    end
  }
}
