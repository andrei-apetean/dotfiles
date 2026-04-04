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
vim.opt.path:append("**")
vim.opt.selection = "exclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.syntax = "on"


vim.opt.list = true
vim.opt.listchars = {
    space = "·",      -- Show spaces as · (U+00B7 Middle dot)
    tab = "→ ",       -- Show tabs as → followed by a space
    trail = "•",      -- Show trailing spaces as •
    extends = ">",    -- Show character for text extending beyond window
    precedes = "<",   -- Show character for text preceding the window
}
vim.o.laststatus = 3 -- show a single status line at the bottom / no split
vim.g.netrw_banner    = 0 
-- vim.g.netrw_liststyle = 3 
-- vim.g.netrw_browse_split = 4  -- open in previous window (most useful with Lexplore)

vim.cmd("colorscheme dusk")

vim.opt.shell = "powershell"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- ── Statusline ────────────────────────────────

local git_branch = ""
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  callback = function()
    local result
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
        result = vim.fn.system("git rev-parse --abbrev-ref HEAD 2> $null")
    else
        result = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    end
    git_branch = vim.v.shell_error == 0
      and result:gsub("\n", "")
      or ""
  end,
})

local function diagnostics()
  local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local i = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  local parts = {}
  if e > 0 then parts[#parts+1] = "E:" .. e end
  if w > 0 then parts[#parts+1] = "W:" .. w end
  if i > 0 then parts[#parts+1] = "I:" .. i end
  return table.concat(parts, " ")
end

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, c in ipairs(clients) do names[#names+1] = c.name end
  return "[" .. table.concat(names, ", ") .. "]"
end

-- local modes = {
--   n      = "NO", i  = "IN", v  = "VI",
--   V      = "VL", c  = "CM", R  = "RE",
--   s      = "SE", S  = "SL", t  = "TE",
--   ["\22"] = "VB", ["\19"] = "SB",
-- }

function _G.Statusline()
  -- local mode   = modes[vim.api.nvim_get_mode().mode] or "??"
  local branch = git_branch ~= "" and ("[" .. git_branch .. "]") or "[git_none] "
  local file   = " %f%m"
  local diag   = diagnostics()
  local pos    = "%l:%c "
  local lsp    = lsp_clients()

  local right = lsp .. (lsp ~= "" and " " or "[lsp_none]")
                .. branch
                .. (diag ~= "" and diag .. "  " or "")
                .. " "
                .. pos

  return " " .. file .. "%=" .. right
end

vim.o.statusline = "%!v:lua.Statusline()"

-- ── LSP ───────────────────────────────────────
-- Modern completion menu style
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.opt.pumheight   = 12  -- max items shown at once
vim.o.winborder = "rounded"

-- Diagnostics appearance
vim.diagnostic.config({
  virtual_text  = true,
  signs         = true,
  underline     = true,
  update_in_insert = false,
  float = { border = "rounded" },  -- border on gl diagnostic float
})

-- Keymaps and completion, set when LSP attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf  = args.buf
    local opts = { buffer = buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition,           opts)  -- go to definition
    vim.keymap.set("n", "K",  vim.lsp.buf.hover,                opts)  -- hover docs
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,         opts)  -- previous diagnostic
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next,         opts)  -- next diagnostic
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,  opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,       opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("i", "<C-l>", vim.lsp.completion.get,        opts)

    vim.lsp.completion.enable(true, args.data.client_id, buf, { autotrigger = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern  = { "c", "cpp", "lua", "python" },
    callback = function()
        local ft = vim.bo.filetype
        local servers = {
            c   = { name = "clangd",    cmd = { "clangd" } },
            cpp = { name = "clangd",    cmd = { "clangd" } },
            lua = { name = "lua_ls", cmd  = { "lua-language-server" },
            settings = {
                Lua = {
                    runtime  = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" }, },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                },
            },
        },
    }
    local cfg = servers[ft]
    if cfg then
        vim.lsp.start({
            name     = cfg.name,
            cmd      = cfg.cmd,
            root_dir = vim.fs.dirname(
                vim.fs.find(
                    { "compile_commands.json", ".clangd", "CMakeLists.txt", ".git" },
                    { upward = true }
                )[1]
            ),
        })
    end
end,
    })

