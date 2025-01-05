return {
      "ej-shafran/compile-mode.nvim",
      tag = "v5.4.0",
      -- you can just use the latest version:
      -- branch = "latest",
      -- or the most up-to-date updates:
      -- branch = "nightly",
      dependencies = {
        "nvim-lua/plenary.nvim",
        -- if you want to enable coloring of ANSI escape codes in
        -- compilation output, add:
         { "m00qek/baleia.nvim", tag = "v1.3.0" },
      },
      config = function()
        ---@type CompileModeOpts
        vim.g.compile_mode = {
            -- to add ANSI escape code support, add:
            baleia_setup = true,
            buffer_name = '_compilation_'
        }
                vim.api.nvim_set_keymap('n', '<leader>x', ':Compile<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>X', ':Recompile<CR>', { noremap = true, silent = true })
 
  end
}
