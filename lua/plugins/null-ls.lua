return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      debug = true,
      sources = {
        -- RuboCop diagnostics/formatting disabled here to avoid duplicates with ruby-lsp.
        -- ruby-lsp now provides RuboCop via lsp/ruby_lsp.lua:5 (formatter/linters = rubocop).
        -- That gives single diagnostics with code = "Metrics/AbcSize" and proper quick-fixes.
        -- If you prefer none-ls, comment the ruby-lsp linters and uncomment the two blocks below.
        -- null_ls.builtins.diagnostics.rubocop.with({
        --   command = "bundle",
        --   args = { "exec", "rubocop", "--format", "json", "--force-exclusion", "--stdin", "$FILENAME" },
        --   condition = function(utils)
        --     return utils.root_has_file({ ".rubocop.yml" })
        --   end,
        -- }),
        -- null_ls.builtins.formatting.rubocop.with({
        --   command = "bundle",
        --   args = { "exec", "rubocop", "-a", "--server", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
        --   condition = function(utils)
        --     return utils.root_has_file({ ".rubocop.yml" })
        --   end,
        -- }),
        null_ls.builtins.formatting.biome.with({
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
        }),
      },
      on_attach = function(client, bufnr)
        if client:supports_method("textDocument/formatting", bufnr) then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}
