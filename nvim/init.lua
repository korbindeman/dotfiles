require("config.autocommands")
require("config.keymaps")
require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local colorscheme = "moonfly"

require("lazy").setup("plugins", {
	install = {
		colorscheme = { colorscheme },
	},
})

vim.cmd.colorscheme(colorscheme)

-- MY OWN CMD PLUGIN --
require("project_cmds").setup()

-- keymaps (optional)
vim.keymap.set("n", "<leader>rp", function()
	require("project_cmds").pick()
end, { desc = "Pick project command" })
vim.keymap.set("n", "<leader>rr", function()
	require("project_cmds").rerun_last()
end, { desc = "Re-run last project command" })
