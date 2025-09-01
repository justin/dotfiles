# # ============================
# # zsh-vi-mode configuration
# # ============================

# bindkey -v
# bindkey jk vi-cmd-mode

# function zvm_config() {
#     # Change the cursor shape based on mode
#     ZVM_CURSOR_BLOCK=$'\e[1q'   # Block cursor for normal mode
#     ZVM_CURSOR_BEAM=$'\e[5q'    # Beam cursor for insert mode
#     ZVM_CURSOR_UNDERLINE=$'\e[3q' # Underline cursor for visual mode

#     # Always start in insert mode
#     ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

#     # Add 'jk' as an additional keybinding to exit insert mode. ESC and
#     ZVM_VI_INSERT_ESCAPE_BINDKEY='jk'
#     ZVM_INIT_MODE=sourcing
# }

# function zvm_after_init() {
#     ## ===== Navigation and editing keybindings =====
#     #bindkey '^[[1;5C' forward-word       # Ctrl + → (Right Arrow): Move forward one word
#     #bindkey '^[[1;5D' backward-word      # Ctrl + ← (Left Arrow): Move backward one word
#     #bindkey '^[[1~' beginning-of-line    # Home: Move to beginning of line
#     #bindkey '^[[4~' end-of-line          # End: Move to end of line
#     #bindkey '^[[H' beginning-of-line     # Home (alternate): Move to beginning of line
#     #bindkey '^[[F' end-of-line           # End (alternate): Move to end of line
#     #bindkey '^[[3~' delete-char          # Delete: Delete character under cursor

#     ## ===== zsh-autosuggestions keybindings =====
#     #bindkey '^Y' autosuggest-accept      # Ctrl + Y to accept the autosuggestion
#     #bindkey '^J' autosuggest-execute     # Ctrl + J to accept and execute the autosuggestion
#     #bindkey '^H' autosuggest-clear       # Ctrl + H to clear the autosuggestion
#     #bindkey '^K' autosuggest-fetch       # Ctrl + K to fetch the next suggestion

#     # ===== History search keybindings =====
#     # These might get overridden by vi-mode, so restore them
#     autoload -U up-line-or-beginning-search
#     zle -N up-line-or-beginning-search
#     [[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
#     bindkey "^[[A" up-line-or-beginning-search

#     autoload -U down-line-or-beginning-search
#     zle -N down-line-or-beginning-search
#     [[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search
#     bindkey "^[[B" down-line-or-beginning-search

#     # ===== FZF keybindings =====
#     # Re-establish FZF bindings that might have been overridden
#     if command -v fzf >/dev/null 2>&1; then
#         # Custom fzf-history-widget-accept function binding
#         zle -N fzf-history-widget-accept
#         bindkey '^X^R' fzf-history-widget-accept
#     fi
# }

# if [[ -f $XDG_CACHE_HOME/zsh/external/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
#     source $XDG_CACHE_HOME/zsh/external/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# fi
