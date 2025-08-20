# 1Password CLI
# https://developer.1password.com/docs/cli
if is_cmd op; then
  eval "$(op completion zsh)"
  compdef _op op
fi

# if os is macOS, set the SSH_AUTH_SOCK to the 1Password agent socket
# This is needed for 1Password to manage SSH keys
if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ -S ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ]]; then
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
  else
    warning "1Password SSH agent socket not found, please ensure 1Password is running."
  fi
fi
