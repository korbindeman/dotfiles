-- highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- change directory to the current working directory on VimEnter
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

-- disable comment on newlines
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "setlocal formatoptions-=o",
})
