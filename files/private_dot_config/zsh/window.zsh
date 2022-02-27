#!/usr/bin/env zsh
#
# Style the Terminal window

set_title() {
  case $TERM in
  xterm*)
    print -Pn "\e]2;${PWD:t}\a"
    ;;
  esac

  return 0
}
