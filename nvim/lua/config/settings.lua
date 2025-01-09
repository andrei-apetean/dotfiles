
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.syntax = "on"
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.ignorecase = true

vim.opt.list = true

vim.opt.listchars = {
    -- space = "·",      -- Show spaces as · (U+00B7 Middle dot)
    tab = "→ ",       -- Show tabs as → followed by a space
    trail = "•",      -- Show trailing spaces as •
    extends = ">",    -- Show character for text extending beyond window
    precedes = "<",   -- Show character for text preceding the window
}

-- Keybinding for running shell commands via ':!' with user input
vim.api.nvim_set_keymap('n', '<leader>r', ':lua run_shell()<CR>', { noremap = true, silent = true })

-- Lua function to run ':!' and wait for user input
function run_shell()
  local cmd = vim.fn.input('run: ')  -- Prompt for input
  if cmd and cmd ~= '' then  -- If input is provided
    vim.cmd('!' .. cmd)  -- Run the command with ':!'
  end
end

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
    return branch ~= "" and branch or "<git:no>"
end

local function progress()
    if vim.fn.line(".") == 1 then
        return "top"
    elseif vim.fn.line(".") == vim.fn.line("$") then
        return "bot"
    else
        local p = vim.fn.line(".") / vim.fn.line("$") * 100
        p = p % 1 >= .5 and math.ceil(p) or math.floor(p)
        return string.format("%02d", p) .. "%%"
    end
end

vim.api.nvim_create_autocmd({"FileType", "BufEnter", "FocusGained"}, {
    callback = function()
        vim.b.branch_name = branch_name()
    end
})

local function diagnostics_str()
  local diagnostics = vim.diagnostic.get(0)  -- Get diagnostics for the current buffer (0)
  local counts = { error = 0, warn = 0, info = 0, hint = 0 }

  for _, diagnostic in pairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      counts.error = counts.error + 1
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      counts.warn = counts.warn + 1
    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
      counts.info = counts.info + 1
    elseif diagnostic.severity == vim.diagnostic.severity.HINT then
      counts.hint = counts.hint + 1
    end
  end

  return string.format("E:%d W:%d I:%d H:%d", counts.error, counts.warn, counts.info, counts.hint)
end

local function lsp_client_name()
    local clients = vim.lsp.get_clients({ bufnr = 0 }) -- Get clients attached to the current buffer
    if next(clients) == nil then
        return "<lsp:none>" -- No LSP client attached
    end

    local client_names = {}
    for _, client in ipairs(clients) do
        table.insert(client_names, client.name) -- Collect client names
    end
    return table.concat(client_names, ", ") -- Return as a comma-separated string
end

function status_line()
    return " %f "
        .. "%="
        .. "%l:%c"
         .. progress()
        .. " | "
        .. diagnostics_str()
        .. " | "
        .. vim.b.branch_name
        .. " | "
       .. lsp_client_name()
end

vim.opt.statusline = "%{%v:lua.status_line()%}"

