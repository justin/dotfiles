# #!/usr/bin/env zsh

# tmac
# tmux attach to a session, or create it if it doesn't exist.
# Usage: tmac <session_name>
# Example: tmac mysession
funcion tmac () {
    tmux has-session -t "$1" 2>/dev/null
    if [ $? != 0 ]; then
        tmux new-session -s "$1" -d
    fi
    tmux attach -t "$1"
}

# __check_can_reload_or_exit
# Checks if there are any background jobs running.
# If there are, it prints an error message and returns 1.
# If there are no background jobs, it returns 0.
# Usage: __check_can_reload_or_exit [<action>]
# <action> is an optional string that will be included in the error message.
# If provided, it should describe the action that cannot be performed due to background jobs.
# Example: zsh::utils::check_can_reload_or_exit "reload"
function __check_can_reload_or_exit () {
  if [[ -n "$(jobs)" ]]; then
    local prefix="Error"
    [[ -n "${1:-}" ]] && prefix="Cannot $1"

    error -P "${prefix}: %j job(s) in background"

    return 1
  else
    return 0
  fi
}

# reload
# Safely reloads the ZSH shell by checking for background jobs.
# If there are background jobs, it prints an error message and exits.
# If there are no background jobs, it reloads the ZSH shell.
# Usage: reload
function reload () {
  zsh::utils::check_can_reload_or_exit "reload" || return 1
  info "Reloading 'zsh'"
  exec zsh
}
