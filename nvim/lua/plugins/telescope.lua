local icons = require("nvim-nonicons")

return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
            },
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep()
                end,
            },
        },
        opts = {
            defaults = {
                prompt_prefix = "  " .. icons.get("telescope") .. "  ",
                selection_caret = " ❯ ",
                entry_prefix = "   ",
            },
        }
    },
}
