#
# Custom ZSH Prompt
#

local host_name="λ"
# [username] at [hostname]
local host_format="${PR_MAGENTA}%n${RESET} at ${PR_YELLOW}%m${RESET}"
# on [current branch](!?)
local git_format="on ${PR_MAGENTA}%b${RESET}${PR_MAGENTA}%u%c${RESET}"
# path, releative to ~ (/Users/justin becomes ~)
local path_format="${PR_BOLD_GREEN}%~${RESET}"
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
${host_name} '

# ===== Right Prompt =====
if [ $os != "Linux" ]; then
  # [Battery %, if available]
  RPROMPT=$(battery)
else
  RPROMPT=
fi

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
