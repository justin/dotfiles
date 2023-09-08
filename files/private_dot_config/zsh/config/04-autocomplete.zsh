# Source zsh-autocomplete
# https://github.com/marlonrichert/zsh-autocomplete
if [[ -e "$HOME/.cache/zsh/external/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  if is_linux; then
    export skip_global_compinit=1
  fi
  source "$HOME/.cache/zsh/external/zsh-autocomplete/zsh-autocomplete.plugin.zsh" || true
fi

# Source zsh-syntax-highlighting extension.
# https://github.com/zsh-users/zsh-syntax-highlighting
if [[ -e "$HOME/.cache/zsh/external/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.cache/zsh/external/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" || true
fi

# Source zsh-autosuggestions extension.
# https://github.com/zsh-users/zsh-autosuggestions
if [[ -e "$HOME/.cache/zsh/external/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.cache/zsh/external/zsh-autosuggestions/zsh-autosuggestions.zsh" || true
fi
