if is_cmd fzf; then
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
readonly FG="#FFFFFF"
readonly BG="#000000"
readonly BG_HIGHLIGHT="#222121"
readonly MAGENTA="#D31895"
readonly GREEN="#41CC45"
readonly YELLOW="#EFB759"
readonly CYAN="#4164FF"
readonly RED="#FF2B38"
readonly BLUE="#00A0FF"
readonly WHITE="#FFFFFF"

export FZF_DEFAULT_OPTS="--color=fg:${FG},bg:${BG},hl:${MAGENTA},fg+:${FG},bg+:${BG_HIGHLIGHT},hl+:${GREEN},info:${YELLOW},prompt:${CYAN},pointer:${CYAN},marker:${CYAN},spinner:${CYAN},header:${CYAN}"

export FZF_CTRL_R_OPTS="--preview=\"bat --color=always {}\" \
--preview-window down:3:hidden:wrap \
--bind '?:toggle-preview' \
"

# Always use a tmux popup for fzf
export FZF_TMUX_OPTS="-p"

# -- Use fd instead of find --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# -- Use fd for fzf's cd command --
# This command will list directories, including hidden ones, and strip the current working directory prefix.
# It will also exclude the .git directory.
export FZF_ALT_C_COMMAND="fd \
--type=d \
--hidden \
--strip-cwd-prefix \
--exclude .git"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
# Bind executing the selected command to Ctrl+X Ctrl+R
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

fi
