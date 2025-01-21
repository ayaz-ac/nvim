return {
	{
		"echasnovski/mini.comment",
		version = "*",
	},
	{
		"echasnovski/mini.cursorword",
		version = "*",
		config = true,
	},
	{
		"echasnovski/mini.indentscope",
		version = "*",
		config = function()
			local indentscope = require("mini.indentscope")
			indentscope.setup({
				draw = {
					animation = indentscope.gen_animation.none(),
				},
			})
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = true,
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = true,
	},
}
