return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			local lsp = require("lsp-zero").preset({})

			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({ buffer = bufnr })
			end)

			require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

			require("lspconfig").emmet_language_server.setup({
				filetypes = { "templ", "html", "css", "javascriptreact", "typescriptreact" },
			})

			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
				}),
				formatting = lsp.cmp_format({ details = true }),
			})

			lsp.setup()
			vim.diagnostic.config({ virtual_text = false })

			require("mason").setup({ ui = { border = "single" } })
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer" },
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
				},
			})
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
			vim.keymap.set("n", "<leader>rn", ":IncRename ")
		end,
	},
}
