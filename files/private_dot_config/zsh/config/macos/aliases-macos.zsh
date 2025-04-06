# App shortcuts
alias typora="open -a typora"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# ====== BBEdit ======

# Take the pasteboard and open it in BBEdit.
alias bbpb='pbpaste | bbedit --clean --view-top'

# Faster access to bbdif.
alias bbd=bbdiff

# If the bb command is called without an argument, launch BBEdit
# If bb is passed a directory, cd to it and open it in BBEdit
# If bb is passed a file, open it in BBEdit
bb() {
  if [[ -z "$1" ]]; then
    bbedit --launch
  else
    bbedit "$1"
    if [[ -d "$1" ]]; then
      cd "$1"
    fi
  fi
}

# Easier access to the lsregister command for fiddling with Launch Services.
alias lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'

# Flush the macOS DNS cache.
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Xcode
alias ded="rm -rf $HOME/Library/Developer/Xcode/DerivedData"
alias symbolicate="$DEVELOPER_DIR/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash"
alias xcode="open -a Xcode"

alias gt="gittower"

# ====== VS Code ======

# if VS Code - Insiders is installed, alias the `code` CLI to it.
if [[ -x "$(command -v code-insiders)" ]]; then
  alias ci="code-insiders"
  alias code="code-insiders"
  alias c="code-insiders"
else
  alias ci="code"
  alias c="code"
fi
