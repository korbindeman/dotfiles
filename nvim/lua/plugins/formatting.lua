return {
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function(_, opts)
			require("conform").setup(opts)

			vim.keymap.set("n", "<leader>fm", function()
				require("conform").format({
					timeout_ms = 500,
					lsp_fallback = true,
				})
			end, { noremap = true, silent = true, nowait = true })
		end,
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- Use a sub-list to run only the first available formatter
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
				haskell = { "fourmolu" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"nmac427/guess-indent.nvim",
		config = true,
		-- opts = {}
	},
}
