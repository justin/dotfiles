bindkey '^[[1;5C' forward-word     # Ctrl + → (Right Arrow): Move forward one word
bindkey '^[[1;5D' backward-word    # Ctrl + ← (Left Arrow): Move backward one word
bindkey '^[[1~' beginning-of-line  # Home: Move to beginning of line
bindkey '^[[4~' end-of-line        # End: Move to end of line
bindkey '^[[H' beginning-of-line   # Home (alternate): Move to beginning of line
bindkey '^[[F' end-of-line         # End (alternate): Move to end of line
bindkey '^[[3~' delete-char        # Delete: Delete character under cursor

# zsh-autosuggestions keybindings
# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#configuration

# Use Ctrl + Y to accept the autosuggestion
bindkey '^Y' autosuggest-accept
# Use Ctrl + J to accept the autosuggestion
bindkey '^J'  autosuggest-execute
# Use Ctrl + H to clear the autosuggestion
bindkey '^H' autosuggest-clear
# Use Ctrl + K to fetch the next suggestion
bindkey '^K' autosuggest-fetch

if [[ -f $XDG_CACHE_HOME/zsh/external/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
    source $XDG_CACHE_HOME/zsh/external/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi
