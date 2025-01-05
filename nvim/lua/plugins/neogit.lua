return {
    "NeogitOrg/neogit",
    dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed.
    -- "nvim-telescope/telescope.nvim", -- optional
    -- "ibhagwan/fzf-lua",              -- optional
    "echasnovski/mini.pick",         -- optional
    },

    config = function()
                vim.api.nvim_set_keymap('n', '<leader>g', ':Neogit<CR>', { noremap = true, silent = true })
 
    end
}
