-- Neovim configuration (init.lua)
-- Converted from Vim config for Neovim, with improvements and cleanup for Neovim
-- Maintainer: Justin Williams

-- XDG Base Directory support (Neovim uses this by default, but we ensure it)
vim.env.XDG_CACHE_HOME  = vim.env.XDG_CACHE_HOME  or (vim.env.HOME .. "/.cache")
vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
vim.env.XDG_DATA_HOME   = vim.env.XDG_DATA_HOME   or (vim.env.HOME .. "/.local/share")
vim.env.XDG_STATE_HOME  = vim.env.XDG_STATE_HOME  or (vim.env.HOME .. "/.local/state")

-- Set runtime path for FZF
if vim.fn.isdirectory('/opt/homebrew/opt/fzf') == 1 then
  vim.opt.runtimepath:append('/opt/homebrew/opt/fzf')
elseif vim.fn.isdirectory('/usr/bin/fzf') == 1 then
  vim.opt.runtimepath:append('/usr/bin/fzf')
end

-- Set directories for swap, backup, view, undo, and viminfo
vim.opt.directory = vim.env.XDG_CACHE_HOME .. "/nvim/swap//"
vim.opt.backupdir = vim.env.XDG_STATE_HOME .. "/nvim/backup//"
vim.opt.viewdir   = vim.env.XDG_STATE_HOME .. "/nvim/view//"
vim.opt.undodir   = vim.env.XDG_STATE_HOME .. "/nvim/undo//"
vim.opt.undofile  = true
vim.opt.viminfofile = vim.env.XDG_STATE_HOME .. "/nvim/viminfofile"

-- General settings
vim.opt.fileformats = {"unix", "dos", "mac"}
vim.opt.numberwidth = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.history = 1000
vim.opt.scrolloff = 10
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = "a"

-- Wildmenu and completion
vim.opt.wildmenu = true
vim.opt.wildmode = {"list", "longest"}
vim.opt.wildignore = {"*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx"}

-- Key mappings
vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<leader>|", ":vsplit<CR>")
vim.keymap.set("n", "<leader>-", ":split<CR>")
vim.keymap.set("n", "<leader>n", ":set hlsearch!<CR>")
vim.keymap.set("n", "<leader>l", ":bnext<CR>")
vim.keymap.set("n", "<leader>h", ":bprevious<CR>")
-- Disable arrow keys in all modes
for _, mode in ipairs({"n", "i", "v"}) do
  for _, key in ipairs({"<Up>", "<Down>", "<Left>", "<Right>"}) do
    vim.keymap.set(mode, key, "<Nop>")
  end
end

-- FZF keybindings
vim.keymap.set("n", "<leader><leader>", ":Files<CR>", { silent = true })
vim.keymap.set("n", "<leader>t", ":<C-u>Files<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", ":Buffers<CR>", { silent = true })
vim.keymap.set("n", "<leader>g", ":Lines<CR>", { silent = true })
vim.keymap.set("n", "<leader>f", ":BLines<CR>", { silent = true })
vim.keymap.set("n", "<leader>h", ":History:<CR>", { silent = true })
vim.keymap.set("n", "<leader>/", ":History/<CR>", { silent = true })
vim.keymap.set("n", "<leader>a", ":Rg!<CR>", { silent = true })

-- Colorscheme
vim.cmd([[colorscheme jww]])

-- Source statusline (lua version)
require("statusline")
