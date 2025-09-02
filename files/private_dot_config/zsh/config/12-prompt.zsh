#
# Custom ZSH Prompt
#

# Cursor configuration
function zle-keymap-select() {
  case $KEYMAP in
    vicmd)
      # Normal mode - thick blinking cursor
      echo -ne '\e[1 q'
      ;;
    viins|main)
      # Insert mode - thin blinking cursor
      echo -ne '\e[5 q'
      ;;
  esac
  zle reset-prompt
  zle -R
}

function zle-line-init() {
  # Start with insert mode cursor
  echo -ne '\e[5 q'
}

function zle-line-finish() {
  # Reset to default cursor when leaving zle
  echo -ne '\e[0 q'
}

# set initial cursor
function vi_mode_prompt_info() {
  case "$KEYMAP" in
    vicmd) printf '%s' '[NORMAL]' ;;
    viins|main) printf '%s' '[INSERT]' ;;
    *) printf '%s' '[INSERT]' ;;
  esac
}

local host_name="λ"
# [username] at [hostname]
local host_format="${PR_MAGENTA}%n${PR_RESET} at ${PR_YELLOW}%m${PR_RESET}"
# on [current branch](!?)
local git_format="on ${PR_MAGENTA}%b${PR_RESET}${PR_MAGENTA}%u%c${PR_RESET}"
# path, releative to ~ (/Users/justin becomes ~)
local path_format="${PR_BOLD_GREEN}%~${PR_RESET}"
# os
local os="$(uname)"

# append the function to our array of precmd functions
typeset -a precmd_functions
precmd_functions+=(set_title)

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' formats $git_format

precmd() {
  set_title
  vcs_info
}

# ===== Left Prompt =====
# [username] at [hostname] in [path] on [current_branch]
setopt prompt_subst
PROMPT='
${host_format} in ${path_format} ${vcs_info_msg_0_}
${PR_BOLD_YELLOW}$(vi_mode_prompt_info)${PR_RESET} ${host_name} '

# ===== Right Prompt =====
if [ $os != "Linux" ] && [ -z "$TMUX" ]; then
  # [Battery %, if available] - but not in tmux
  RPROMPT=$(battery)
else
  RPROMPT=
fi

## Updates editor information when the keymap changes.
#function zle-keymap-select() {
#  zle reset-prompt
#  zle -R
#}
#
#zle -N zle-keymap-select
#
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

echo -ne '\e[5 q'
# ===== For my own sanity =====
# git:
#   %b => current branch
#   %a => current action (rebase/merge)
#   %c => style if there are staged changes in the repository
#   %u => style if there are unstaged changes in the repository
# prompt:
#   %f => reset color
#   %~ => current path
#   %n => username
#   %m => shortname host
#
# Full List: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
