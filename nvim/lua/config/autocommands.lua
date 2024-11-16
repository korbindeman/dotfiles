-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Define an autocommand that changes the directory to the current working directory on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("cdpwd", { clear = true }),
	callback = function()
		local args = vim.fn.argv()
		if #args > 0 then
			-- Get the directory of the first argument
			local arg = args[1]
			local dir = vim.fn.fnamemodify(arg, ":p:h")
			vim.fn.chdir(dir)
		else
			-- No files specified, set to shell's current directory
			vim.fn.chdir(vim.loop.cwd())
		end
	end,
})
