local opts = {}

function opts.init()
  -- General
	vim.opt.encoding = "UTF-8" -- Default encoding
	vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
	vim.opt.mouse = "a" -- Enabled mouse in all mode
	vim.opt.confirm = true -- Confirm before closing an unsaved buffer
	vim.opt.swapfile = false

  -- File management
	vim.opt.autoread = true -- Automatically read and update a file when it has been changed outside
	vim.opt.autowrite = true -- Automatically write file when it was changed

  -- Line config
	vim.opt.number = true -- Number in front of each line
	vim.opt.relativenumber = true -- Show relative number in front of each line
	vim.opt.list = true -- Show space, line breaks, spaces, tabs...
	vim.opt.listchars:append("eol:↴") -- Set the sign for the EOL
  vim.opt.linebreak = true -- Break line when it's too long
	vim.opt.signcolumn = "yes" -- Show a column where the plugins can show sign/status
	vim.opt.cursorline = true -- Highlight current line
  vim.opt.fixeol = true -- Add EOL if not present when writing a file

  -- Indentation
	vim.opt.expandtab = true -- Use spaces instead of tabs
	vim.opt.smartindent = true -- Insert indents automatically
	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.shiftwidth = 2

  -- Scrolling and positionning
	vim.opt.mousescroll = "ver:3,hor:0" -- Disable horizontal mouse scrolling
  vim.opt.scrolloff = 20 -- Extra space above and below the line when scrolling

	-- Enable filetype plugins and indentation
	vim.cmd([[ filetype plugin indent on ]])
end

return opts
