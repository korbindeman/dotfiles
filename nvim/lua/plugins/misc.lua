return {
	{
		"romainl/vim-cool",
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			-- notifier = { enabled = false },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			-- words = { enabled = false },
		},
		keys = {
			{
				"<leader>g",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
		},
	},
	-- {
	-- 	"jake-stewart/force-cul.nvim",
	-- 	config = function()
	-- 		require("force-cul").setup()
	-- 	end,
	-- },
}
