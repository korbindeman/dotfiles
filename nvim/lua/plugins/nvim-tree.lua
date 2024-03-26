local nonicons_extention = require("nvim-nonicons.extentions.nvim-tree")

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>t",
			function()
				require("nvim-tree.api").tree.toggle()
			end,
		},
	},
	opts = {
		renderer = {
			group_empty = true,
			icons = {
				glyphs = nonicons_extention.glyphs,
				show = {
					git = false,
				},
			},
		},
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
		filters = {
			dotfiles = true,
			custom = { "Cargo.lock", "bun.lockb" },
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set("n", "H", function()
				api.tree.toggle_hidden_filter()
				api.tree.toggle_custom_filter()
			end, opts("Toggle filter: Hidden Files"))
		end,
	},
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function(data)
				-- buffer is a directory
				local directory = vim.fn.isdirectory(data.file) == 1

				if not directory then
					return
				end

				-- change to the directory
				vim.cmd.cd(data.file)

				-- open the tree
				require("nvim-tree.api").tree.open()
			end,
		})
	end,
}
