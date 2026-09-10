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

      -- ts_ls sends definitions to the .d.ts declaration when a package ships one.
      -- Its `_typescript.goToSourceDefinition` command returns the implementation
      -- instead. It answers with an empty list for anything that has no source (a real
      -- ambient type, a Node builtin), so fall back to the plain LSP definition.
      local function goto_definition()
        local ts = vim.lsp.get_clients({ bufnr = 0, name = "ts_ls" })[1]
        if not ts then
          return vim.lsp.buf.definition()
        end

        local params = vim.lsp.util.make_position_params(0, ts.offset_encoding)
        ts:exec_cmd({
          command = "_typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
        }, { bufnr = 0 }, function(_, result)
          if result and not vim.tbl_isempty(result) then
            vim.lsp.util.show_document(result[1], ts.offset_encoding, { reuse_win = true, focus = true })
          else
            vim.lsp.buf.definition()
          end
        end)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>gd", goto_definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
          vim.keymap.set("n", "<leader>gi", function()
            require("telescope.builtin").lsp_implementations()
          end, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
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
