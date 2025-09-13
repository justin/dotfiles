" Status Line Configuration
" ==========================

" Use truecolor in terminal UIs so GUI hex colors are respected
if has('termguicolors')
  set termguicolors
endif

" Try to hide the command-line row entirely until needed (if supported by your Vim)
" Only enable cmdheight=0 on Neovim or Vim 9+ (older Vim doesn't support 0)
if exists('+cmdheight') && (has('nvim') || v:version >= 900)
  silent! set cmdheight=0
endif

set laststatus=2
" Ensure a statusline is visible immediately (overridden by setlocal later)
set statusline=%!StatusLineActive()

" Color scheme for statusline components:
hi clear StatusLine
hi StatusLine             ctermfg=0   ctermbg=13  cterm=NONE  guifg=#000000 guibg=#ff00ff gui=NONE
hi StatusLineNC           ctermfg=8   ctermbg=13  cterm=NONE  guifg=#666666 guibg=#ff00ff gui=NONE
hi StatusLineNormalMode   ctermfg=15  ctermbg=0   cterm=BOLD  guifg=#ffffff guibg=#000000 gui=BOLD
hi StatusLineInsertMode   ctermfg=15  ctermbg=0   cterm=BOLD  guifg=#ffffff guibg=#000000 gui=BOLD
hi SLBranch               ctermfg=15  ctermbg=8   cterm=NONE  guifg=#ffffff guibg=#303030 gui=NONE
hi SLFile                 ctermfg=0   ctermbg=13  cterm=NONE  guifg=#000000 guibg=#ff00ff gui=NONE
hi SLPercent              ctermfg=0   ctermbg=13  cterm=NONE  guifg=#000000 guibg=#ff00ff gui=NONE
hi SLLineCol              ctermfg=15  ctermbg=8   cterm=NONE  guifg=#ffffff guibg=#303030 gui=NONE
hi SLClock                ctermfg=15  ctermbg=0   cterm=BOLD  guifg=#ffffff guibg=#000000 gui=BOLD
hi SLSepModeToBranch      ctermfg=0   ctermbg=8   cterm=NONE  guifg=#000000 guibg=#303030 gui=NONE
hi SLSepBranchToFile      ctermfg=8   ctermbg=13  cterm=NONE  guifg=#303030 guibg=#ff00ff gui=NONE
hi SLSepModeToFile        ctermfg=0   ctermbg=13  cterm=NONE  guifg=#000000 guibg=#ff00ff gui=NONE
hi SLSepPercentToLC       ctermfg=8   ctermbg=13  cterm=NONE  guifg=#303030 guibg=#ff00ff gui=NONE
hi SLSepLCToClock         ctermfg=0   ctermbg=8   cterm=NONE  guifg=#000000 guibg=#303030 gui=NONE

" Return a short, readable mode label
function! StatuslineMode() abort
    let l:map = {
        \ 'n': 'NORMAL',
        \ 'v': 'VISUAL',
        \ 'V': 'V-LINE',
        \ "\<C-v>": 'V-BLOCK',
        \ 's': 'SELECT',
        \ 'S': 'S-LINE',
        \ "\<C-s>": 'S-BLOCK',
        \ 'i': 'INSERT',
        \ 'R': 'REPLACE',
        \ 'c': 'CMD',
        \ 't': 'TERM'
        \ }
    return get(l:map, mode(), 'NORMAL')
endfunction

" Efficient git branch lookup for the file's directory (not cwd), with small cache
function! GitBranchForBuffer() abort
    let l:dir = expand('%:p:h')
    if empty(l:dir)
        let l:dir = getcwd()
    endif

    " 2s TTL for cache
    if get(b:, 'git_branch_dir', '') ==# l:dir
                \ && exists('b:git_branch')
                \ && exists('b:git_branch_cached_at')
                \ && reltimefloat(reltime(b:git_branch_cached_at)) < 2.0
        return b:git_branch
    endif

    let l:branch = trim(system('git -C '.shellescape(l:dir).' rev-parse --abbrev-ref HEAD 2>/dev/null'))
    if v:shell_error || empty(l:branch)
        " Not a repo or error
        let b:git_branch = ''
    else
        if l:branch ==# 'HEAD'
            " detached HEAD → show short sha
            let l:sha = trim(system('git -C '.shellescape(l:dir).' rev-parse --short HEAD 2>/dev/null'))
            let b:git_branch = empty(l:sha) ? '' : l:sha
        else
            let b:git_branch = l:branch
        endif
    endif

    let b:git_branch_dir = l:dir
    let b:git_branch_cached_at = reltime()
    return b:git_branch
endfunction

" Active window statusline:
" Left: [MODE] [ branch] filename%m
" Right: %p%%  line:col  time
function! StatusLineActive()
    " Left side: [MODE]  [branch]  [filename%m]
    let l:mode_group = (mode() ==# 'i') ? 'StatusLineInsertMode' : 'StatusLineNormalMode'
    let l:left = '%#'.l:mode_group.'# '.StatuslineMode().' '

    let l:branch = GitBranchForBuffer()
    if empty(l:branch)
        " mode → file (black → pink)
        let l:left .= '%#SLSepModeToFile#%#SLFile# %t%m '
    else
        " mode → branch (black → gray) → file (gray → pink)
        let l:left .= '%#SLSepModeToBranch#%#SLBranch#  '.l:branch.' '
        let l:left .= '%#SLSepBranchToFile#%#SLFile# %t%m '
    endif

    " Right side: [percent]  [line:col]  [clock]
    let l:right = '%#SLPercent# %p%% '
    let l:right .= '%#SLSepPercentToLC#%#SLLineCol# %l:%c '
    let l:right .= '%#SLSepLCToClock#%#SLClock# '.strftime('%H:%M').' '

    return l:left . '%=' . l:right
endfunction

" Inactive window statusline (keep simple)
function! StatusLineInactive()
    let l:filename = '%t'
    let l:line_col = '%l:%c'
    return l:filename . '%=' . l:line_col
endfunction

" Load the status line based on the active state of the window.
function! StatusLineLoad(mode)
  if a:mode ==# 'active'
    setlocal statusline=%!StatusLineActive()
  else
    setlocal statusline=%!StatusLineInactive()
  endif
endfunction

" Script-local callback for timer (avoids lambda incompatibility on some Vim builds)
function! s:RedrawStatusCb(timer) abort
  redrawstatus
endfunction

augroup statusline_load
    autocmd!
    " Initialize at startup and force a repaint (defer if timers available)
    autocmd VimEnter * call StatusLineLoad('active') | if exists('*timer_start') | call timer_start(1, 's:RedrawStatusCb') | else | redrawstatus | endif
    " Cover initial paint when new windows/tabs appear
    autocmd BufWinEnter,WinNew,TabEnter * call StatusLineLoad('active') | redrawstatus
    " Active/inactive transitions
    autocmd WinEnter * call StatusLineLoad('active')
    autocmd WinLeave * call StatusLineLoad('inactive')
    " Refresh when things change that affect content
    autocmd BufWritePost,CursorHold,FocusGained,ShellCmdPost,DirChanged * call StatusLineLoad('active')
augroup END
