# #!/usr/bin/env zsh

tmac () {
    tmux has-session -t "$1" 2>/dev/null
    if [ $? != 0 ]; then
        tmux new-session -s "$1" -d
    fi
    tmux attach -t "$1"
}
