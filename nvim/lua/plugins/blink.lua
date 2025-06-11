return {
	"saghen/blink.cmp",
	lazy = false,
	version = "v0.*",
	opts = {
		keymap = {
			preset = "enter",
			["<Tab>"] = {
				function(cmp)
					if vim.b[vim.api.nvim_get_current_buf()].nes_state then
						cmp.hide()
						return (
							require("copilot-lsp.nes").apply_pending_nes()
							and require("copilot-lsp.nes").walk_cursor_end_edit()
						)
					end
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			-- cmdline = {},
		},
		-- experimental auto-brackets support
		-- completion = { accept = { auto_brackets = { enabled = true } } },

		-- experimental signature help support
		-- signature = { enabled = true }
	},
	-- opts_extend = { "sources.completion.enabled_providers" },
}
