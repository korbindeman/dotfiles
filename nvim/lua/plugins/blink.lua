return {
	"saghen/blink.cmp",
	lazy = false,
	version = "v0.*",
	opts = {
		keymap = { preset = "enter" },
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			cmdline = {},
		},
		-- experimental auto-brackets support
		-- completion = { accept = { auto_brackets = { enabled = true } } },

		-- experimental signature help support
		-- signature = { enabled = true }
	},
	-- opts_extend = { "sources.completion.enabled_providers" },
}
