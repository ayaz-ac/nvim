local keys = {}

function keys.init()
  -- No arrow key allowed
  vim.keymap.set("n", "<up>", "<nop>", { silent = true })
  vim.keymap.set("n", "<down>", "<nop>", { silent = true })
  vim.keymap.set("n", "<left>", "<nop>", { silent = true })
  vim.keymap.set("n", "<right>", "<nop>", { silent = true })

  -- Clear search with <esc>
  vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch", silent = true })

  -- Navitage vim panes better
  vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
  vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
  vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
  vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')

  -- Split vertically/horizontally
  vim.keymap.set('n', '<C-s>', ':vsplit<CR>')
  vim.keymap.set('n', '<C-b>', ':split<CR>')
end

return keys
