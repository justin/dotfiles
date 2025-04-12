# Make sure Python's PATH is set correctly for Homebrew.
# https://docs.brew.sh/Homebrew-and-Python
if is_cmd brew; then
  export PATH="$(brew --prefix python)/libexec/bin:${PATH}"
fi
