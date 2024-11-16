return {
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()

			cmp.setup({
				formatting = lsp_zero.cmp_format({ details = true }),
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp_action.luasnip_supertab(),
					["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
				}),
			})
		end,
	},
	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })

				-- client.server_capabilities.semanticTokensProvider = nil
			end)

			vim.diagnostic.config({
				virtual_text = false,
			})

			require("mason").setup({ ui = {
				border = "single",
			} })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
				},
			})

			local lsp = require("lspconfig")

			lsp.emmet_language_server.setup({
				filetypes = { "templ", "html", "css", "javascriptreact", "typescriptreact" },
				init_options = {
					html = {
						options = {
							-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
							["bem.enabled"] = true,
						},
					},
				},
			})

			-- LSP server setup
			-- :help lspconfig-all or https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			--
			-- lsp.emmet_ls.setup({
			-- 	init_options = {
			-- 		jsx = {
			-- 			options = {
			-- 				-- ["markup.attributes"] = { className = "class" }, -- this is for solid.js
			-- 				["output.selfClosingStyle"] = "xhtml",
			-- 			},
			-- 		},
			-- 	},
			-- })
			-- lsp.pyright.setup({})
			-- lsp.gleam.setup({})
			-- lsp.hls.setup({})
			-- lsp.jsonls.setup({})
			lsp.lua_ls.setup(lsp_zero.nvim_lua_ls())
			-- lsp.rust_analyzer.setup({})
			-- lsp.svelte.setup({})
			-- lsp.tailwindcss.setup({})
			-- lsp.tsserver.setup({})
			-- lsp.wgsl_analyzer.setup({})
			-- lsp.cssls.setup({})
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
