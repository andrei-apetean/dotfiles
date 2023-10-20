vim.opt.clipboard='unnamedplus'
vim.opt.smartcase=true
vim.opt.smarttab=true
vim.opt.hlsearch=false
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true
vim.opt.termguicolors=true
vim.opt.cursorline=true
vim.opt.number=true
vim.opt.syntax='enable'
vim.opt.encoding="utf-8"

local Plug = vim.fn['plug#']
local plug_location = 'C:/Users/aa/AppData/Local/nvim/plugs'

vim.call ('plug#begin', plug_location)
	Plug 'nvim-lualine/lualine.nvim'
    Plug 'jacoborus/tender.vim'
vim.call ('plug#end')

-- Lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding',  'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

vim.cmd[[colorscheme tender]]
