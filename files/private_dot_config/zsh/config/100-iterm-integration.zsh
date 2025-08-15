# ===== iTerm 2 / tmux =====
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

# Keep this at the end
if [[ -e "$HOME/.cache/iterm2/iterm2_shell_integration.zsh" ]]; then
  source "$HOME/.cache/iterm2/iterm2_shell_integration.zsh" || true
fi
