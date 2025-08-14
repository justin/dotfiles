# colors - Prompt customization with color constants.
autoload -U colors && colors

# The variables are wrapped in \%\{\%\}. This should be the case for every
# variable that does not contain space.
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
  eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
  eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done

# TODO: Handle the bright colors.

eval RESET='$reset_color'
export PR_RED PR_GREEN PR_YELLOW PR_BLUE PR_WHITE PR_BLACK
export PR_BOLD_RED PR_BOLD_GREEN PR_BOLD_YELLOW PR_BOLD_BLUE
export PR_BOLD_WHITE PR_BOLD_BLACK


# LSCOLORS: Customize 'ls' colors in BSD/macOS. Each pair sets foreground/background for file types.
# Format: aabbccddeeff, where:
#   aa = directory, bb = symbolic link, cc = socket, dd = pipe, ee = executable, ff = block special,
#   gg = character special, hh = executable with setuid, ii = executable with setgid, jj = directory writable to others, k = directory sticky & writable to others
#
# Color codes: a = black, b = red, c = green, d = brown, e = blue, f = magenta, g = cyan, h = light grey,
#   A = bold black, B = bold red, C = bold green, D = bold brown, E = bold blue, F = bold magenta, G = bold cyan, H = bold light grey, x = default
# Example below:
unset LSCOLORS
export CLICOLOR=1
export LSCOLORS="cxfxcxdxbxegedabagacad"
#  dir  sym  sock pipe exec block char suid sgid  wdir  stky
#  cx   fx   cx   dx   bx   eg   ed   ab   ag    ac   ad
