# do not autoselect the first completion entry
unsetopt menu_complete
# disable output flow control via start/stop characters
unsetopt flow_control
# Use menu completion after the second consecutive request for completion via Tab Key.
setopt auto_menu
setopt complete_in_word
# Always move cursor to end of word after completion.
setopt always_to_end

# Customization based on zsh-autocomplete suggestions.
# https://github.com/marlonrichert/zsh-autocomplete

# Add some color to completion suggestions.
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# -D: delete any existing dump file before creating a new one.
# -i: ignore insecure directories when creating the dump file.
# -u: to update the dump file if it already exists.
# -C: use caching to speed up the initialization process.
# -w: write a message to the terminal if it encounters any warnings during initialization.
zstyle '*:compinit' arguments -D -i -u -C -w

zmodload -i zsh/complist

_tmac_complete() {
    local word=${COMP_WORDS[COMP_CWORD]}
    local sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
    COMPREPLY=( $(compgen -W "$sessions" -- "$word") )
}
complete -F _tmac_complete tmac
