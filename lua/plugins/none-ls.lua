return {
  "nvimtools/none-ls.nvim",
  config = function()
    local function get_project_root()
      local root = vim.fn.findfile("Gemfile", ".;")
      return root ~= "" and vim.fn.fnamemodify(root, ":h") or vim.fn.getcwd()
    end

    local function erb_lint_cmd()
      local gemfile = vim.fn.findfile("Gemfile", ".;")
      if gemfile ~= "" then
        return { "bundle", "exec", "erb_lint" }
      else
        return { "erb_lint" }
      end
    end

    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.rubocop.with({
          command = "bundle",
          args = { "exec", "rubocop", "--format", "json", "--force-exclusion", "--stdin", "$FILENAME" },
          cwd = get_project_root,
        }),
        null_ls.builtins.formatting.rubocop.with({
          command = "bundle",
          args = {
            "exec",
            "rubocop",
            "--autocorrect",
            "--format",
            "quiet",
            "--stdin",
            "$FILENAME",
            "--stdout",
          },
          cwd = get_project_root,
        }),
        null_ls.builtins.diagnostics.erb_lint.with({
          command = function()
            return erb_lint_cmd()[1]
          end,
          args = function()
            local cmd = erb_lint_cmd()
            table.remove(cmd, 1) -- Remove the command itself to get just args
            return vim.list_extend(cmd, { "--lint", "$FILENAME" })
          end,
          cwd = get_project_root,
        }),
        -- ERB Formatting
        null_ls.builtins.formatting.erb_lint.with({
          command = function()
            return erb_lint_cmd()[1]
          end,
          args = function()
            local cmd = erb_lint_cmd()
            table.remove(cmd, 1) -- Remove the command itself to get just args
            return vim.list_extend(cmd, { "--autocorrect", "$FILENAME" })
          end,
          cwd = get_project_root,
        }),
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
