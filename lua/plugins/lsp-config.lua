return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ts_ls", "lua_ls", "ruby_lsp", "biome" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Nvim 0.11+ disables virtual_text by default (was true in 0.10)
      -- This is the #1 reason RuboCop diagnostics seem to "disappear" after updating
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 2,
          -- Show Cop name for RuboCop: "Metrics/AbcSize Assignment Branch Condition..."
          -- ruby-lsp stores cop in `code`, none-ls in `code` as well - format merges them.
          format = function(diagnostic)
            local msg = diagnostic.message:gsub("\n.*", "") -- strip multiline suffix from ruby-lsp
            if diagnostic.code then
              return string.format("%s %s", diagnostic.code, msg)
            end
            return msg
          end,
        },
        virtual_lines = false,
        underline = true,
        signs = true,
        severity_sort = true,
        float = { border = "rounded", source = true, header = "", suffix = "" },
        update_in_insert = false,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "<leader>gr", function()
            require("telescope.builtin").lsp_references()
          end, vim.tbl_extend("force", opts, { desc = "Show references with Telescope" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
        end,
      })
      vim.lsp.enable({ "ruby_lsp", "ts_ls", "lua_ls", "biome" })
    end,
  },
}
