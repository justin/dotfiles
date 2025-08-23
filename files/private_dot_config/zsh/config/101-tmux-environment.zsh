# via https://without-brains.net/2020/08/05/tmux-and-ssh-agent-forwarding/
function __update_environment_from_tmux() {
  if [ -n "${TMUX}" ]; then
    eval "$(tmux show-environment -s)"
  fi
}

add-zsh-hook precmd __update_environment_from_tmux
