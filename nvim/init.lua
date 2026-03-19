vim.cmd("colorscheme retrobox")
-- basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smartindent = true

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- visual settings
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
 vim.opt.statuscolumn = '%l  ' --│

vim.opt.colorcolumn = "96"
vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.completeopt = { 'menuone', 'noinsert' , 'noselect' }

-- file  handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.nvim/undodir")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.autoread = true
vim.opt.autowrite = false

-- behaviour
vim.opt.hidden = true
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append(".","**")
vim.opt.selection = "exclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.syntax = "on"
vim.opt.swapfile = false
vim.opt.path = {".", "**"}

vim.opt.list = true
vim.opt.listchars = {
    space = "·",      -- Show spaces as · (U+00B7 Middle dot)
    tab = "→ ",       -- Show tabs as → followed by a space
    trail = "•",      -- Show trailing spaces as •
    extends = ">",    -- Show character for text extending beyond window
    precedes = "<",   -- Show character for text preceding the window
}

local function branch_name()
 local branch
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
        -- Windows: use NUL instead of /dev/null and remove newline with PowerShell
        branch = vim.fn.system("git branch --show-current 2> NUL")
        branch = branch:gsub("\n", "")  -- Remove newline for Windows
    else
        -- Unix-like systems: use /dev/null and tr to remove newline
        branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    end
    return branch ~= "" and branch or "[none]"
end

local function lsp_status()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        return "[lsp]"
    end
    local client_names = {}
    for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
    end
    if #clients > 1 then 
        return "[" .. table.concat(client_names, ",") .. "]"
    else
        return client_names[1]
    end
end

vim.api.nvim_create_autocmd({"FileType", "BufEnter", "FocusGained"}, {
    callback = function()
        vim.b.branch_name = branch_name()
    end
})

vim.api.nvim_create_autocmd({"LspAttach", "LspDetach", "BufEnter"}, {
    callback = function()
        vim.b.lsp_status = lsp_status()
    end
})


function status_line()
    return " %f %= "
        .. vim.b.branch_name
        .. " %l:%c %L %P "
end
vim.opt.statusline = " %f %= %{luaeval('vim.b.branch_name')} %{luaeval('vim.b.lsp_status')} %l:%c %L %P "

-----------------------------------------------------------------
--                            LSP
-----------------------------------------------------------------
-- Enable LSP diagnostics
vim.diagnostic.config({
  virtual_text = true,      -- Show inline diagnostic messages
  signs = true,             -- Show signs in the sign column
  underline = true,         -- Underline diagnostics
  update_in_insert = false, -- Don't update diagnostics while typing
  severity_sort = true,     -- Sort by severity
})

-- Start clangd automatically for C/C++ files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.lsp.start({
      name = 'clangd',
      cmd = {'clangd'},
      root_dir = vim.fs.dirname(vim.fs.find({'compile_commands.json', '.git'}, { upward = true })[1]),
    })
  end,
})

-- LSP keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }

    -- Keybindings
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

    -- Enable completion
    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
})

-- Wanted a plugin-less config but need to install this crap cause... treesitter
-- (not bashing on Lazy, it's pretty awesome)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- TreeSitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        -- Install parsers for these languages
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "json",
          "markdown",
        },
        
        -- Install parsers synchronously (only for ensure_installed)
        sync_install = false,
        
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        
        -- Highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        
        -- Indentation based on treesitter
        indent = {
          enable = true,
        },
      })
    end,
  },
})
