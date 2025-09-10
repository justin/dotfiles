" Neovim color scheme converted from JWW Xcode theme
" Maintainer: Justin Williams
" Last Change: 2025-08-04

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "jww"

" UI Colors
hi Normal           guifg=#ffffff ctermfg=231
hi Cursor           guifg=#000000 guibg=#ffffff ctermfg=16 ctermbg=231
hi CursorLine       guibg=#1a1919 ctermbg=234
hi Visual           guibg=#4a473f ctermfg=NONE ctermbg=238
hi LineNr           guifg=#323232 ctermfg=236
hi CursorLineNr     guifg=#ffffff ctermfg=231
hi VertSplit        guifg=#323232 guibg=#323232 ctermfg=236 ctermbg=236
hi StatusLine       guifg=#ffffff guibg=#323232 ctermfg=231 ctermbg=236
hi StatusLineNC     guifg=#808080 guibg=#323232 ctermfg=244 ctermbg=236
hi Pmenu            guifg=#ffffff guibg=#323232 ctermfg=231 ctermbg=236
hi PmenuSel         guifg=#000000 guibg=#ffffff ctermfg=16 ctermbg=231
hi Search           guibg=#4a473f ctermfg=NONE ctermbg=238
hi IncSearch        guibg=#4a473f ctermfg=NONE ctermbg=238

" Syntax Highlighting - converted from Xcode RGBA values
hi Comment          guifg=#41cc45 ctermfg=83 gui=italic
hi Keyword          guifg=#d31895 ctermfg=162 gui=bold
hi Statement        guifg=#d31895 ctermfg=162 gui=bold
hi Conditional      guifg=#d31895 ctermfg=162 gui=bold
hi Repeat           guifg=#d31895 ctermfg=162 gui=bold
hi Label            guifg=#d31895 ctermfg=162 gui=bold
hi Operator         guifg=#d31895 ctermfg=162 gui=bold
hi Exception        guifg=#d31895 ctermfg=162 gui=bold
hi String           guifg=#ff2b38 ctermfg=203
hi Character        guifg=#ff2b38 ctermfg=203
hi Number           guifg=#786dff ctermfg=105
hi Float            guifg=#786dff ctermfg=105
hi Boolean          guifg=#786dff ctermfg=105
hi Function         guifg=#23ff83 ctermfg=48
hi Type             guifg=#23ff83 ctermfg=48
hi StorageClass     guifg=#23ff83 ctermfg=48
hi Structure        guifg=#23ff83 ctermfg=48
hi Typedef          guifg=#23ff83 ctermfg=48
hi Identifier       guifg=#00a0ff ctermfg=39
hi Constant         guifg=#23ff83 ctermfg=48
hi PreProc          guifg=#e57c48 ctermfg=173
hi Include          guifg=#e57c48 ctermfg=173
hi Define           guifg=#e57c48 ctermfg=173
hi Macro            guifg=#e57c48 ctermfg=173
hi PreCondit        guifg=#e57c48 ctermfg=173
hi Special          guifg=#5cd8ff ctermfg=81
hi SpecialChar      guifg=#5cd8ff ctermfg=81
hi Tag              guifg=#5cd8ff ctermfg=81
hi Delimiter        guifg=#5cd8ff ctermfg=81
hi SpecialComment   guifg=#5cd8ff ctermfg=81
hi Debug            guifg=#5cd8ff ctermfg=81
hi Underlined       guifg=#4164ff ctermfg=69 gui=underline
hi SpecialKey       guifg=#2d439b ctermfg=61
hi Error            guifg=#f74a4a guibg=NONE ctermfg=203 ctermbg=NONE
hi ErrorMsg         guifg=#f74a4a guibg=NONE ctermfg=203 ctermbg=NONE
hi WarningMsg       guifg=#efb759 guibg=NONE ctermfg=215 ctermbg=NONE
hi Todo             guifg=#41cc45 guibg=NONE ctermfg=83 ctermbg=NONE gui=bold
hi DiffAdd          guibg=#1a4a1a ctermfg=NONE ctermbg=22
hi DiffChange       guibg=#4a4a1a ctermfg=NONE ctermbg=58
hi DiffDelete       guifg=#f74a4a guibg=#4a1a1a ctermfg=203 ctermbg=52
hi DiffText         guibg=#6a6a1a ctermfg=NONE ctermbg=100
hi Folded           guifg=#808080 guibg=#1a1a1a ctermfg=244 ctermbg=234
hi FoldColumn       guifg=#808080 guibg=#000000 ctermfg=244 ctermbg=16
hi MatchParen       guibg=#4a473f ctermfg=NONE ctermbg=238
hi SpellBad         guisp=#f74a4a gui=undercurl ctermfg=203 cterm=underline
hi SpellCap         guisp=#4164ff gui=undercurl ctermfg=69 cterm=underline
hi SpellLocal       guisp=#efb759 gui=undercurl ctermfg=215 cterm=underline
hi SpellRare        guisp=#786dff gui=undercurl ctermfg=105 cterm=underline
hi TabLine          guifg=#808080 guibg=#323232 ctermfg=244 ctermbg=236
hi TabLineFill      guifg=#323232 guibg=#323232 ctermfg=236 ctermbg=236
hi TabLineSel       guifg=#ffffff guibg=#000000 ctermfg=231 ctermbg=16
hi WildMenu         guifg=#000000 guibg=#ffffff ctermfg=16 ctermbg=231
hi htmlTag          guifg=#e57c48 ctermfg=173
hi htmlEndTag       guifg=#e57c48 ctermfg=173
hi htmlTagName      guifg=#23ff83 ctermfg=48
hi htmlArg          guifg=#5cd8ff ctermfg=81
hi htmlString       guifg=#ff2b38 ctermfg=203
hi cssClassName     guifg=#23ff83 ctermfg=48
hi cssIdentifier    guifg=#23ff83 ctermfg=48
hi cssProperty      guifg=#5cd8ff ctermfg=81
hi cssValue         guifg=#ff2b38 ctermfg=203
hi javascriptFunction guifg=#d31895 ctermfg=162
hi javascriptIdentifier guifg=#00a0ff ctermfg=39
hi javascriptNumber guifg=#786dff ctermfg=105
hi pythonFunction   guifg=#23ff83 ctermfg=48
hi pythonBuiltin    guifg=#00a0ff ctermfg=39
hi pythonDecorator  guifg=#e57c48 ctermfg=173
hi gitcommitOverflow guifg=#f74a4a ctermfg=203
hi gitcommitSummary guifg=#ffffff ctermfg=231
hi gitcommitComment guifg=#41cc45 ctermfg=83
hi gitcommitBranch  guifg=#00a0ff ctermfg=39

" Folding
hi Folded           guifg=#808080 guibg=#1a1a1a ctermfg=244 ctermbg=234
hi FoldColumn       guifg=#808080 guibg=#000000 ctermfg=244 ctermbg=16

" Matching parentheses
hi MatchParen       guibg=#4a473f ctermfg=NONE ctermbg=238

" Spell checking
hi SpellBad         guisp=#f74a4a gui=undercurl ctermfg=203 cterm=underline
hi SpellCap         guisp=#4164ff gui=undercurl ctermfg=69 cterm=underline
hi SpellLocal       guisp=#efb759 gui=undercurl ctermfg=215 cterm=underline
hi SpellRare        guisp=#786dff gui=undercurl ctermfg=105 cterm=underline

" Tabline
hi TabLine          guifg=#808080 guibg=#323232 ctermfg=244 ctermbg=236
hi TabLineFill      guifg=#323232 guibg=#323232 ctermfg=236 ctermbg=236
hi TabLineSel       guifg=#ffffff guibg=#000000 ctermfg=231 ctermbg=16

" Wildmenu
hi WildMenu         guifg=#000000 guibg=#ffffff ctermfg=16 ctermbg=231

" Additional syntax groups for better compatibility
hi htmlTag          guifg=#e57c48 ctermfg=173
hi htmlEndTag       guifg=#e57c48 ctermfg=173
hi htmlTagName      guifg=#23ff83 ctermfg=48
hi htmlArg          guifg=#5cd8ff ctermfg=81
hi htmlString       guifg=#ff2b38 ctermfg=203

hi cssClassName     guifg=#23ff83 ctermfg=48
hi cssIdentifier    guifg=#23ff83 ctermfg=48
hi cssProperty      guifg=#5cd8ff ctermfg=81
hi cssValue         guifg=#ff2b38 ctermfg=203

hi javascriptFunction guifg=#d31895 ctermfg=162
hi javascriptIdentifier guifg=#00a0ff ctermfg=39
hi javascriptNumber guifg=#786dff ctermfg=105

" Python specific
hi pythonFunction   guifg=#23ff83 ctermfg=48
hi pythonBuiltin    guifg=#00a0ff ctermfg=39
hi pythonDecorator  guifg=#e57c48 ctermfg=173

" Git diff in vim
hi gitcommitOverflow guifg=#f74a4a ctermfg=203
hi gitcommitSummary guifg=#ffffff ctermfg=231
hi gitcommitComment guifg=#41cc45 ctermfg=83
hi gitcommitBranch  guifg=#00a0ff ctermfg=39
