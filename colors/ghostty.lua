-- `:colorscheme ghostty` loads the current Ghostty theme (see lua/ghostty-theme.lua).
if not require("ghostty-theme").load() then
  vim.notify("No Ghostty theme found", vim.log.levels.WARN)
end
