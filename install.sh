#!/usr/bin/env sh
#
# Configure a new machine with the dotfiles and configuration from this repository.
# Install script shamelessly stolen and updated from viggo-gascou/dotfiles.

set -e

RED='\033[1;31m'   # bold red
GREEN='\033[32;1m' # bold green
BOLD='\033[1m'     # bold
NC='\033[0m'       # no Color

# My GitHub account.
readonly GITHUB_USERNAME="justin"

# The operating system this script will run on.
readonly PLATFORM="$(uname)"

if [ $PLATFORM = "Darwin" ]; then
  if [ "${xcode-select -p 1>/dev/null;echo $?}" = 2 ]; then # only install Xcode Command Line Tools if not installed
    echo "${BOLD}⏳ Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
  else
    echo "${GREEN}✅ Xcode Command Line Tools already installed.${NC}"
  fi

  if command -v brew >/dev/null 2>&1; then # only install Homebrew if not installed
    echo "${GREEN}✅ Homebrew already installed.${NC}"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    if command -v chezmoi >/dev/null 2>&1; then # only install chezmoi if not installed
      echo "${GREEN}✅ Chezmoi already installed.${NC}"
    else
      echo "${BOLD}Installing chezmoi via homebrew.${NC}"
      brew install chezmoi
    fi
  else
    echo "${BOLD}⏳ Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "${BOLD}Installing chezmoi via homebrew.${NC}"
    brew install chezmoi
  fi

  echo "${BOLD}🛠 Setting up dotfiles using chezmoi...${NC}"
  exec chezmoi init --apply $GITHUB_USERNAME
else
  bin_dir="${HOME}/.local/bin"
  chezmoi="${bin_dir}/chezmoi"
  echo "${BOLD}🛠 Setting up dotfiles using chezmoi...${NC}"
  sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "${bin_dir}"
  unset bin_dir

  # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
  script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

  set -- init --apply --source="${script_dir}"

  echo "Running 'chezmoi $*'" >&2
  exec "$chezmoi" "$@"
fi
