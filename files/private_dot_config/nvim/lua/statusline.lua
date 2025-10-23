-- statusline.lua
-- Neovim statusline configuration, ported and improved from Vim version
-- Maintainer: Justin Williams

-- Use truecolor
vim.opt.termguicolors = true

-- Try to hide the command-line row entirely until needed (if supported by your Neovim)
-- Only enable cmdheight=0 on Neovim (older versions don't support 0)
if vim.fn.has('nvim') == 1 then
  vim.opt.cmdheight = 0
end

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

-- Git branch (with caching for performance)
local function git_branch()
  local dir = vim.fn.expand('%:p:h')
  if dir == '' then
    dir = vim.fn.getcwd()
  end

  -- 2s TTL for cache
  if vim.b.git_branch_dir == dir
      and vim.b.git_branch
      and vim.b.git_branch_cached_at
      and vim.fn.reltimefloat(vim.fn.reltime(vim.b.git_branch_cached_at)) < 2.0 then
    return vim.b.git_branch
  end

  local handle = io.popen("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
  if not handle then return "" end
  local branch = handle:read("*a"):gsub("\n", "")
  handle:close()

  if branch == "HEAD" or branch == "" then
    local sha_handle = io.popen("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --short HEAD 2>/dev/null")
    if sha_handle then
      local sha = sha_handle:read("*a"):gsub("\n", "")
      sha_handle:close()
      vim.b.git_branch = sha ~= "" and sha or ""
    else
      vim.b.git_branch = ""
    end
  else
    vim.b.git_branch = branch
  end

  vim.b.git_branch_dir = dir
  vim.b.git_branch_cached_at = vim.fn.reltime()
  return vim.b.git_branch
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

-- Script-local callback for timer (avoids lambda incompatibility)
local function redraw_status_cb()
  vim.cmd('redrawstatus')
end

-- Autocommands for statusline refresh
vim.api.nvim_create_augroup('statusline_load', { clear = true })
-- Initialize at startup and force a repaint (defer if timers available)
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  group = 'statusline_load',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLineActive()'
    if vim.fn.exists('*timer_start') == 1 then
      vim.fn.timer_start(1, redraw_status_cb)
    else
      vim.cmd('redrawstatus')
    end
  end,
})
-- Cover initial paint when new windows/tabs appear
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinNew', 'TabEnter' }, {
  group = 'statusline_load',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLineActive()'
    vim.cmd('redrawstatus')
  end,
})
-- Active/inactive transitions
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  group = 'statusline_load',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLineActive()'
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  group = 'statusline_load',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLineInactive()'
  end,
})
-- Refresh when things change that affect content
vim.api.nvim_create_autocmd({ 'BufWritePost', 'CursorHold', 'FocusGained', 'ShellCmdPost', 'DirChanged' }, {
  group = 'statusline_load',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLineActive()'
  end,
})
