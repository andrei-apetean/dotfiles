return {
    "X3eRo0/dired.nvim",
    dependencies =  {"MunifTanjim/nui.nvim"},
 config = function()
        -- Set up the Dired plugin
        require("dired").setup({
            path_separator = "/",
            show_banner = false,
            show_icons = false,
            show_hidden = true,
            show_dot_dirs = true,
            show_colors = true,
        })

        -- Bind the Dired command to a keymap (e.g., <leader>d)
        vim.api.nvim_set_keymap('n', '<leader>d', ':Dired<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>D', ':DiredQuit<CR>', { noremap = true, silent = true })
    end,
}
