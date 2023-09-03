# do not autoselect the first completion entry
unsetopt menu_complete
# disable output flow control via start/stop characters
unsetopt flow_control
# Use menu completion after the second consecutive request for completion via Tab Key.
setopt auto_menu
setopt complete_in_word
# Always move cursor to end of word after completion.
setopt always_to_end

# Do not care about case sensitivity.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Add some color.
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Support tabbing into the autocomplete menu.
zstyle ':completion:*:*:*:*:*' menu select

# Cache expensive completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_COMPDUMP

# Suggested by zsh-autocomplete
# https://github.com/marlonrichert/zsh-autocomplete
zstyle '*:compinit' arguments -D -i -u -C -w

zmodload -i zsh/complist

# More Fun Options? https://github.com/solnic/dotfiles/blob/master/home/zsh/completion.zsh
