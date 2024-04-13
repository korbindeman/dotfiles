return {
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
}
