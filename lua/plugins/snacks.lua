-- snacks.nvim is already installed as a claudecode.nvim dependency; this spec
-- configures its terminal module and adds the keymaps for it.

-- Lowest terminal number not currently in use, so <leader>tn always opens a
-- fresh split instead of toggling an existing one.
local function next_free_term()
	for i = 1, 99 do
		if not Snacks.terminal.get(nil, { count = i, create = false }) then
			return i
		end
	end
	return 1
end

local function pick_term()
	local terms = Snacks.terminal.list()
	if #terms == 0 then
		vim.notify("No open terminals", vim.log.levels.INFO)
		return
	end
	vim.ui.select(terms, {
		prompt = "Terminals",
		format_item = function(t)
			local info = vim.b[t.buf].snacks_terminal or {}
			return string.format("%d: %s", info.id or 0, vim.b[t.buf].term_title or "terminal")
		end,
	}, function(t)
		if t then
			t:show():focus()
		end
	end)
end

return {
	"folke/snacks.nvim",
	opts = {
		terminal = {
			win = {
				position = "bottom",
				height = 0.3,
				-- Move out of the terminal split with the same keys used elsewhere
				keys = {
					nav_h = { "<C-h>", function() vim.cmd.wincmd("h") end, mode = "t", desc = "Go to left window" },
					nav_j = { "<C-j>", function() vim.cmd.wincmd("j") end, mode = "t", desc = "Go to lower window" },
					nav_k = { "<C-k>", function() vim.cmd.wincmd("k") end, mode = "t", desc = "Go to upper window" },
					nav_l = { "<C-l>", function() vim.cmd.wincmd("l") end, mode = "t", desc = "Go to right window" },
				},
			},
		},
	},
	keys = {
		{ "<leader>t", nil, desc = "Terminal" },
		{
			"<leader>tt",
			function() Snacks.terminal.toggle() end,
			desc = "Toggle terminal (prefix a count for #N)",
		},
		{
			"<leader>tn",
			function() Snacks.terminal.toggle(nil, { count = next_free_term() }) end,
			desc = "New terminal",
		},
		{ "<leader>tl", pick_term, desc = "List terminals" },
		{
			"<C-\\>",
			function() Snacks.terminal.toggle() end,
			mode = { "n", "t" },
			desc = "Toggle terminal",
		},
	},
}
