" Add ~/.vim and ~/.vim/after to the runtime path for Neovim compatibility
set runtimepath^=~/.vim runtimepath+=~/.vim/after

" Set the packpath to match the runtimepath (for plugin compatibility)
let &packpath = &runtimepath

" Source the main vimrc file for unified configuration
source "$XDG_CONFIG_HOME/vim/vimrc"
