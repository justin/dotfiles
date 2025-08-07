if type eza > /dev/null 2>&1; then
  export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
  # If eza is available, use it instead of ls.
  alias ls='eza'
  alias l='ls -l'
  alias la='ls -la'
  alias ll='ls -l'
else
  # Otherwise, use the default ls command.
  alias ls='ls --color=auto'
  alias l='ls -l'
  alias la='ls -la'
  alias ll='ls -l'
fi
