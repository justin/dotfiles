# 1Password CLI
# https://developer.1password.com/docs/cli
if is_cmd op; then
  eval "$(op completion zsh)"
  compdef _op op
fi
