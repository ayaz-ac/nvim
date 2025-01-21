local opts = {}

function opts.init()
	vim.opt.autoread = true -- Read a file when it was changed outside of nvim
	vim.opt.autowrite = true -- Automatically write file when it was changed
	vim.opt.encoding = "UTF-8" -- Default encoding
	vim.opt.number = true -- Number in front of each line
	vim.opt.relativenumber = true
	vim.opt.mouse = "a" -- Enabled in all mode
	vim.opt.list = true -- Show space, line breaks, spaces, tabs...
	vim.opt.listchars:append("eol:↴") -- Set the sign for the EOL
	vim.opt.signcolumn = "yes" -- Show a column where the plugins can show sign/status
	vim.opt.wrap = false -- Long lines are not wrapped
	vim.opt.splitbelow = true -- Cursor go on the left window when split
	vim.opt.splitright = true -- Cursor go on the right windows when split
	vim.opt.confirm = true -- Confirm before closing an unsaved buffer
	vim.opt.cursorline = true -- Highlight current line
	vim.opt.expandtab = true -- Use spaces instead of tabs
	vim.opt.smartindent = true -- Insert indents automatically
	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.swapfile = false
	vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
	vim.opt.mousescroll = "ver:3,hor:0" -- Disable horizontal mouse scrolling

	-- Enable filetype plugins and indentation
	vim.cmd([[ filetype plugin indent on ]])
end

return opts
