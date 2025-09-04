# ===== ZSH History =====
export HISTFILE=${XDG_DATA_HOME:=~/.local/share}/zsh/history

# Just in case: If the parent directory doesn't exist, create it.
[[ -d $HISTFILE:h ]] ||
  mkdir -p $HISTFILE:h

# Save the last $SAVEHIST lines you executed at the end of a Terminal session to $HISTFILE.
export SAVEHIST=$((100 * 1000))
# Read $HISTSIZE lines from $HISTFILE at the start of a Terminal session.
export HISTSIZE=$((1.2 * $SAVEHIST))

# Use modern file-locking mechanisms, for better safety & performance.
setopt hist_fcntl_lock
# Write the history file in the ':start:elapsed;command' format.
setopt extended_history
# imports new commands and appends typed commands to history
setopt share_history
# Expire a duplicate event first when trimming history.
setopt hist_expire_dups_first
# Do not write an event that was just recorded again.
setopt hist_ignore_dups
# Do not write events to history that are duplicates of previous events
setopt hist_ignore_all_dups
# Do not display a previously found event.
setopt hist_find_no_dups
# Remove extra blanks from each command line being added to history
setopt hist_reduce_blanks
# Do not record an event starting with a space.
setopt hist_ignore_space
# Do not write a duplicate event to the history file.
setopt hist_save_no_dups
# Don't create new histories. One zsh history to rule them all.
setopt append_history
# Adds history incrementally as typed, not just at shell exit.
setopt inc_append_history
# Don't execute immediately upon history expansion.
setopt hist_verify
# Don't store history commands
setopt hist_no_store

# ===== History Key Bindings =====

# start typing + [Up-Arrow] - fuzzy find history forward. The $key[X] variants work on Ubuntu.
# whereas the ASCII key code works on macOS. Fun!
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search

# start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Search entire history for passed in argument 
# Usage: h <search-term>
# Example: h git
#
# This will print a list of commands with numbers. 
# You can immediately re-execute any of the commands 
# with !n where n is the command number.
function h() {
  # check if we passed any parameters
  if [ -z "$*" ]; then
      # if no parameters were passed print entire history
      history 1
  else
      # if words were passed use it as a search
      history 1 | egrep --color=auto "$@"
  fi
}
