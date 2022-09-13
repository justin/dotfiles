#!/usr/bin/env sh
#
# Configure a new machine with the dotfiles and configuration from this repository.
# Install script shamelessly stolen and updated from viggo-gascou/dotfiles.

set -e

RED='\033[1;31m' # bold red
GREEN='\033[32;1m' # bold green
BOLD='\033[1m' # bold
NC='\033[0m' # no Color

# My GitHub account.
readonly GITHUB_USERNAME="justin"

# The operating system this script will run on.
readonly PLATFORM="$( uname )"

if [ $PLATFORM = "Darwin" ]; then
  if [ "${xcode-select -p 1>/dev/null;echo $?}" = 2 ]; then # only install Xcode Command Line Tools if not installed
    echo "${BOLD}⏳ Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
  else
    echo "${GREEN}✅ Xcode Command Line Tools already installed.${NC}"
  fi

  if command -v brew >/dev/null 2>&1; then # only install Homebrew if not installed
    echo "${GREEN}✅ Homebrew already installed.${NC}"

    if command -v chezmoi >/dev/null 2>&1; then # only install chezmoi if not installed
      echo "${GREEN}✅ Chezmoi already installed.${NC}"
    else
      echo "${BOLD}Installing chezmoi via homebrew.${NC}"
      brew install chezmoi
    fi
  else
    echo "${BOLD}⏳ Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "${BOLD}Installing chezmoi via homebrew.${NC}"
    brew install chezmoi
  fi

  echo "${BOLD}🛠 Setting up dotfiles using chezmoi...${NC}"
  exec chezmoi init --apply $GITHUB_USERNAME
else
  echo "${BOLD}🛠 Setting up dotfiles using chezmoi...${NC}"
  sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply $GITHUB_USERNAME
fi
