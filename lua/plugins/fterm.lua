return {
	"numToStr/FTerm.nvim",
	enabled = true,
	main = "FTerm",
	config = function()
		vim.keymap.set("n", "<leader>t", '<CMD>lua require("FTerm").toggle()<CR>', { desc = "Open terminal" })
		vim.keymap.set("t", "<leader>t", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = "Close terminal" })
	end,
}
