# ===== ASDF Configuration =====
export ASDF_CONFIG_FILE=$CONFIG_HOME/asdf/asdfrc
export ASDF_DATA_DIR=$XDG_DATA_HOME/asdf

# Source asdf.
# https://asdf-vm.com/
if [ -f $(brew --prefix asdf)/libexec/asdf.sh ]; then
  source $(brew --prefix asdf)/libexec/asdf.sh
fi
