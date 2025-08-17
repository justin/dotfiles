# ===== iTerm 2 / tmux =====

if [[ "${TERM_PROGRAM:-}" == "iTerm.app" ]]; then
  if [[ -e "$HOME/.cache/iterm2/iterm2_shell_integration.zsh" ]]; then
    source "$HOME/.cache/iterm2/iterm2_shell_integration.zsh" || true
  fi
fi
