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
    visual) printf '%s' '[VISUAL]' ;;
    viopp) printf '%s' '[OPERATOR]' ;;
    viins|main) printf '%s' '[INSERT]' ;;
    *) printf '%s' '[INSERT]' ;;
  esac
}
