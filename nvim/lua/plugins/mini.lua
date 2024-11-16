return {
	"echasnovski/mini.nvim",
	version = "*",
	init = function()
		require("mini.jump").setup()
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
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionRename",
			callback = function(event)
				Snacks.rename.on_rename_file(event.data.from, event.data.to)
			end,
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

		vim.api.nvim_create_user_command("Close", function()
			require("mini.bufremove").delete()
		end, {})
	end,
}
