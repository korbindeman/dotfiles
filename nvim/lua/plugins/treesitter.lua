return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
			-- "JoosepAlviste/nvim-ts-context-commentstring",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = {
					enable = true,
				},
				indent = { enable = true, disable = { "python" } },
				autotag = {
					enable = true,
				},
			})
		end,
	},
}
