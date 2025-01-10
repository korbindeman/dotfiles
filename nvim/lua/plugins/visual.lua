return {
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = false,
		priority = 1000,
	},
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	-- {
	-- 	"korbindeman/nvim-nonicons",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = true,
	-- },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = { scope = { enabled = false } },
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"b0o/incline.nvim",
		config = function()
			local devicons = require("nvim-web-devicons")

			require("incline").setup({
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "no file"
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename, nil, { default = true })
					return {
						{ ft_icon, guifg = ft_color },
						" ",
						filename,
					}
				end,
			})
		end,
	},
	{
		"jinh0/eyeliner.nvim",
		opts = {
			highlight_on_key = true,
		},
	},
}
