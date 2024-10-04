return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "lua", "html", "css", "json", "javascript", "typescript", "rust" },
			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}

-- return {
-- 	{
-- 		"nvim-treesitter/nvim-treesitter",
-- 		"JoosepAlviste/nvim-ts-context-commentstring",
-- 		build = ":TSUpdate",
-- 		config = function()
-- 			require("nvim-treesitter.configs").setup({
-- 				auto_install = true,
-- 				highlight = {
-- 					enable = true,
-- 				},
-- 				indent = { enable = true, disable = { "python" } },
-- 			})
-- 		end,
-- 	},
-- }
