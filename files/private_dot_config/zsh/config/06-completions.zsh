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

# Initialize completion functions after fpath is configured. The cache is rebuilt
# when completion files change, so newly managed functions are discovered.
autoload -Uz compinit
compinit -i -d "${ZSH_COMPDUMP:-${ZDOTDIR:-$HOME}/.zcompdump}"

zmodload -i zsh/complist

_tmac_complete() {
    local -a sessions

    sessions=("${(@f)$(tmux list-sessions -F "#{session_name}" 2>/dev/null)}")
    _describe 'tmux session' sessions
}
compdef _tmac_complete tmac
