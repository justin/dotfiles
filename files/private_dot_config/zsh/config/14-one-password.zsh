# 1Password CLI
# https://developer.1password.com/docs/cli
if is_cmd op; then
  eval "$(op completion zsh)"
  compdef _op op

  # Load plugins if the file exists
  [ -f "$XDG_CONFIG_HOME/op/plugins.sh" ] && \
  source "$XDG_CONFIG_HOME/op/plugins.sh"
fi
