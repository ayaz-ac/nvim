local keys = {}

function keys.init()
  -- No arrow key allowed
  vim.keymap.set("n", "<up>", "<nop>", { silent = true })
  vim.keymap.set("n", "<down>", "<nop>", { silent = true })
  vim.keymap.set("n", "<left>", "<nop>", { silent = true })
  vim.keymap.set("n", "<right>", "<nop>", { silent = true })

  -- Remove macro key since I don't use it
  vim.keymap.set("n", "q", "<nop>", { silent = true })
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

  -- Use Tab and Shift + Tab to indent/unindent
  vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selected lines", silent = true })
  vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selected lines", silent = true })
  vim.keymap.set("i", "<Tab>", "<C-t>", { desc = "Indent line in insert mode", silent = true })
  vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Unindent line in insert mode", silent = true })

end

return keys
