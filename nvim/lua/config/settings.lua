
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.syntax = "on"
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.swapfile = true

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

function status_line()
	return " %f "
		.. "%="
        .. "%l:%c"
        .. "  "
		.. vim.b.branch_name
        .. " " 
		.. progress()
		.. " "
end

vim.opt.statusline = "%{%v:lua.status_line()%}"

