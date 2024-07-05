return {
	"echasnovski/mini.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	version = "*",
	init = function()
		require("mini.comment").setup({
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		})
		require("mini.pairs").setup()
		require("mini.trailspace").setup()
		require("mini.surround").setup()
		require("mini.pick").setup()
		require("mini.pairs").setup()
		require("mini.files").setup({
			mappings = {
				synchronize = "w",
			},
			options = {
				permanent_delete = false,
			},
		})
		require("mini.move").setup({
			mappings = {
				left = "H",
				right = "L",
				down = "J",
				up = "K",
			},
		})

		vim.keymap.set("n", "<Leader>t", require("mini.files").open)
		vim.keymap.set("n", "<Leader>ff", require("mini.pick").builtin.files)
	end,
}
