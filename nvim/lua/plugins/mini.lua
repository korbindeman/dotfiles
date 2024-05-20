return {
	"echasnovski/mini.nvim",
	version = "*",
	init = function()
		require("mini.comment").setup()
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

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function(data)
				-- buffer is a directory
				local directory = vim.fn.isdirectory(data.file) == 1

				if not directory then
					return
				end

				-- change to the directory
				vim.cmd.cd(data.file)
			end,
		})
	end,
}
