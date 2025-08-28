-- statusline.lua
-- Neovim statusline configuration, ported and improved from Vim version
-- Maintainer: Justin Williams

-- Use truecolor
vim.opt.termguicolors = true

-- Highlight groups (Neovim Lua API)
local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hi("StatusLine",             { fg="#000000", bg="#ff00ff", bold=false })
hi("StatusLineNC",           { fg="#666666", bg="#ff00ff", bold=false })
hi("StatusLineNormalMode",   { fg="#ffffff", bg="#000000", bold=true })
hi("StatusLineInsertMode",   { fg="#ffffff", bg="#000000", bold=true })
hi("SLBranch",               { fg="#ffffff", bg="#303030", bold=false })
hi("SLFile",                 { fg="#000000", bg="#ff00ff", bold=false })
hi("SLPercent",              { fg="#000000", bg="#ff00ff", bold=false })
hi("SLLineCol",              { fg="#ffffff", bg="#303030", bold=false })
hi("SLClock",                { fg="#ffffff", bg="#000000", bold=true })
hi("SLSepModeToBranch",      { fg="#000000", bg="#303030", bold=false })
hi("SLSepBranchToFile",      { fg="#303030", bg="#ff00ff", bold=false })
hi("SLSepModeToFile",        { fg="#000000", bg="#ff00ff", bold=false })
hi("SLSepPercentToLC",       { fg="#303030", bg="#ff00ff", bold=false })
hi("SLSepLCToClock",         { fg="#000000", bg="#303030", bold=false })

-- Mode label
local function statusline_mode()
  local map = {
    n = "NORMAL", v = "VISUAL", V = "V-LINE", ['\22'] = "V-BLOCK",
    s = "SELECT", S = "S-LINE", ['\19'] = "S-BLOCK",
    i = "INSERT", R = "REPLACE", c = "CMD", t = "TERM"
  }
  return map[vim.api.nvim_get_mode().mode] or "NORMAL"
end

-- Git branch (async, but fallback to sync for statusline)
local function git_branch()
  local handle = io.popen("git -C " .. vim.fn.expand('%:p:h') .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
  if not handle then return "" end
  local branch = handle:read("*a"):gsub("\n", "")
  handle:close()
  if branch == "HEAD" or branch == "" then
    local sha = io.popen("git -C " .. vim.fn.expand('%:p:h') .. " rev-parse --short HEAD 2>/dev/null"):read("*a"):gsub("\n", "")
    return sha ~= "" and sha or ""
  end
  return branch
end

-- Statusline function
function _G.StatusLineActive()
  local mode_group = (vim.api.nvim_get_mode().mode == 'i') and '%#StatusLineInsertMode#' or '%#StatusLineNormalMode#'
  local left = mode_group .. ' ' .. statusline_mode() .. ' '
  local branch = git_branch()
  if branch == "" then
    left = left .. '%#SLSepModeToFile#%#SLFile# %t%m '
  else
    left = left .. '%#SLSepModeToBranch#%#SLBranch#  ' .. branch .. ' '
    left = left .. '%#SLSepBranchToFile#%#SLFile# %t%m '
  end
  local right = '%#SLPercent# %p%% '
  right = right .. '%#SLSepPercentToLC#%#SLLineCol# %l:%c '
  right = right .. '%#SLSepLCToClock#%#SLClock# ' .. os.date('%H:%M') .. ' '
  return left .. '%=' .. right
end

function _G.StatusLineInactive()
  return '%t%=%l:%c'
end

vim.opt.laststatus = 2
vim.opt.statusline = '%!v:lua.StatusLineActive()'

-- Autocommands for statusline refresh
vim.api.nvim_create_augroup('statusline_load', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'BufWinEnter', 'WinNew', 'TabEnter', 'WinEnter', 'BufWritePost', 'CursorHold', 'FocusGained', 'ShellCmdPost', 'DirChanged' }, {
  group = 'statusline_load',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLineActive()'
  end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = 'statusline_load',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLineInactive()'
  end,
})
