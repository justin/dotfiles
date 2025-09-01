# Source zsh-vi-mode extension
# https://github.com/jeffreytse/zsh-vi-mode
if [[ -e "$HOME/.cache/zsh/external/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
  function zvm_config() {
    # Change the cursor shape based on mode
    ZVM_CURSOR_BLOCK=$'\e[1q'   # Block cursor for normal mode
    ZVM_CURSOR_BEAM=$'\e[5q'    # Beam cursor for insert mode
    ZVM_CURSOR_UNDERLINE=$'\e[3q' # Underline cursor for visual mode

    # Always start in insert mode
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    # Enable system clipboard integration for zsh-vi-mode
    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
    # Set the initial mode to insert mode
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    # Use 'jk' to exit insert mode
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
    # Set the initialization mode to sourcing.
    # https://github.com/jeffreytse/zsh-vi-mode#initialization-mode
    ZVM_INIT_MODE=sourcing
  }

  source "$HOME/.cache/zsh/external/zsh-vi-mode/zsh-vi-mode.plugin.zsh" || true
fi
