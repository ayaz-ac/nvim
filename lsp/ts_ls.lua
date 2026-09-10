-- typescript-language-server config for JavaScript and TypeScript.
--
-- This file has to exist because the pinned nvim-lspconfig commit still uses the old
-- `lua/lspconfig/configs/*.lua` layout. `vim.lsp.enable("ts_ls")` only reads `lsp/*.lua`
-- from the runtimepath, so without this file ts_ls is enabled but never attaches, and
-- go-to-definition reports "method not supported by any server".

return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- tsserver resolves imports from the tsconfig/jsconfig project, so the markers go from
  -- the most precise project file down to the plain repository root.
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  init_options = { hostInfo = "neovim" },
  settings = {
    -- Both keys are needed: tsserver reads `typescript.*` for .ts/.tsx and `javascript.*`
    -- for .js/.jsx, and ignores the other one.
    typescript = {
      -- Definitions land on the implementation instead of an alias re-export.
      preferGoToSourceDefinition = true,
      inlayHints = { includeInlayParameterNameHints = "none" },
    },
    javascript = {
      preferGoToSourceDefinition = true,
      inlayHints = { includeInlayParameterNameHints = "none" },
    },
    -- A JavaScript project with no jsconfig.json gets no cross-file resolution. The
    -- implicit project makes imports resolve, and checkJs stays off so plain JS files
    -- do not fill up with type errors.
    implicitProjectConfiguration = { checkJs = false },
  },
}
