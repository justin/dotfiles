# Add helper functions and configuration for BBEdit CLI usage.
if is_cmd bbedit; then

  # Use Spotlight to generate a list of BBEdit Projects and open that in an fzf window.
  function bbproj() {
    mdfind kMDItemContentType:com.barebones.bbedit.project \
    | fzf --print0 \
    | xargs -0 open
  }

  # BBFind grep helper
  function bbf() {
    bbfind --grep --gui "$@"
  }

  # Open fzf result in BBEdit.
  function fzfbb() {
    fzf --print0 | xargs -0 -o bbedit
  }

  # Display `ripgrep` search results in a BBEdit results window.
  function rgbb() {
      # Note: --pattern specifies "\s*", instead of the default "\s+"
      rg --column --line-number "$@" \
      | bbresults --pattern '^(?P<file>.+?):(?P<line>\d+):(?P<col>\d+):\s*(?P<msg>.*)$'
  }

  # Display `shellcheck` feedback in a BBEdit results window.
  function shellcheckbb() {
    shellcheck -f gcc "$@" | bbresults --pattern gcc
  }

  # Show `tsc` errors in a BBEdit results browser.
  function tscbb() {
    tsc --noEmit --pretty false "$@" \
    | bbresults -p '^(?P<file>.+?)\((?P<line>\d+),(?P<col>\d+)\): (?P<type>\w+) (?P<msg>.+)'
  }
fi
