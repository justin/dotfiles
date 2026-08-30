# Interactive llm workflows.
#
# These helpers use the source-managed llm templates and fragment aliases. Run
# `just llm-fragments-sync` after applying this configuration to install the
# aliases in llm's local database. Generated commands are always returned for
# review; they are never executed by these helpers.
#
# Templates:
# - swift-review: Swift 6 correctness and concurrency review.
# - japanese: Genki II-level Japanese explanation.
# - branch-brief: Concise branch-diff briefing for reviewers.
# - precommit: Staged-diff summary, concerns, tests, and commit subject.
#
# Fragments:
# - macos-cli: Local shell, platform, and command-safety context.
# - debugging: Root-cause-first diagnostic behavior.
# - swift-review: JWW Swift review priorities and constraints.
# - japanese-study: Japanese-learning explanation preferences.

# Return success when llm is available, otherwise show a non-fatal warning.
function __llm_require() {
  if ! is_cmd llm; then
    warning 'llm is not installed or is not on PATH'
    return 1
  fi
}

# Diagnose command output supplied on stdin.
# Usage: command 2>&1 | whyfail
function whyfail() {
  __llm_require || return

  if [[ -t 0 ]]; then
    warning 'usage: command 2>&1 | whyfail'
    return 1
  fi

  llm -f debugging -s 'Identify the earliest likely root cause in this command output. Distinguish it from cascading errors, explain it concisely, and suggest the next diagnostic commands. Assume zsh. Do not suggest destructive commands unless clearly labeled.'
}

# Review a Git diff, preferring an explicit range, then staged changes.
# Usage: review [<git-diff-range>]
function review() {
  __llm_require || return

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warning 'review must be run inside a Git work tree'
    return 1
  fi

  if (( $# > 1 )); then
    warning 'usage: review [<git-diff-range>]'
    return 1
  fi

  if (( $# == 1 )); then
    if git diff --quiet "$1"; then
      warning "no changes to review for $1"
      return 0
    fi
    git diff "$1" | llm -t swift-review -f swift-review
  elif ! git diff --cached --quiet; then
    git diff --cached | llm -t swift-review -f swift-review
  elif ! git diff --quiet; then
    git diff | llm -t swift-review -f swift-review
  else
    warning 'no staged or unstaged changes to review'
    return 0
  fi
}

# Explain Japanese from stdin, or from the macOS clipboard when stdin is a TTY.
# Usage: jp [<question>] or printf %s '<Japanese text>' | jp [<question>]
function jp() {
  __llm_require || return

  local prompt="${*:-Explain this Japanese at approximately Genki II level. Identify the relevant grammar, but do not add furigana unless necessary.}"

  if [[ -t 0 ]]; then
    if ! is_macos || ! is_cmd pbpaste; then
      warning 'usage: printf %s "Japanese text" | jp [question]'
      return 1
    fi
    pbpaste | llm -t japanese -f japanese-study "$prompt"
  else
    llm -t japanese -f japanese-study "$prompt"
  fi
}

# Answer a question from a compact snapshot of the current Git repository.
# Usage: askrepo <question>
function askrepo() {
  __llm_require || return

  if (( $# == 0 )); then
    warning 'usage: askrepo <question>'
    return 1
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warning 'askrepo must be run inside a Git work tree'
    return 1
  fi

  {
    print '## Repository'
    git remote get-url origin 2>/dev/null || print '(no origin remote)'
    print '\n## Branch'
    git branch --show-current
    print '\n## Status'
    git status --short
    print '\n## Recent commits'
    git log --oneline -15
    print '\n## Diff summary'
    git diff --stat
    print '\n## Staged diff summary'
    git diff --cached --stat
  } | llm -f macos-cli -s "You are helping with the current software repository. Use only the supplied repository state to answer this question: $*. Clearly distinguish visible facts from inference."
}

# Answer a question using only a command's installed --help output.
# Usage: askhelp <command> [<argument> ...] -- <question>
function askhelp() {
  __llm_require || return

  local -a command
  while (( $# > 0 )) && [[ $1 != -- ]]; do
    command+=("$1")
    shift
  done

  if (( $# == 0 )); then
    warning 'usage: askhelp <command> [<argument> ...] -- <question>'
    return 1
  fi
  shift

  if (( ${#command[@]} == 0 || $# == 0 )); then
    warning 'usage: askhelp <command> [<argument> ...] -- <question>'
    return 1
  fi

  "${command[@]}" --help 2>&1 | llm -f macos-cli -s "Answer this question using only the supplied command help: $* If the help does not establish an answer, say so."
}

# Brief the branch diff against origin/HEAD, or an explicitly supplied range.
# Usage: git-brief [<git-diff-range>]
function git-brief() {
  __llm_require || return

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warning 'git-brief must be run inside a Git work tree'
    return 1
  fi

  if (( $# > 1 )); then
    warning 'usage: git-brief [<git-diff-range>]'
    return 1
  fi

  local range="${1:-}"
  if [[ -z $range ]]; then
    range="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)...HEAD"
  fi

  if [[ $range == ...HEAD ]]; then
    warning 'usage: git-brief <git-diff-range> (origin/HEAD is not configured)'
    return 1
  fi

  if git diff --quiet "$range"; then
    warning "no changes to brief for $range"
    return 0
  fi

  git diff "$range" | llm -t branch-brief -f swift-review
}

# Prepare staged changes for a human-reviewed commit without creating one.
# Usage: precommit
function precommit() {
  __llm_require || return

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warning 'precommit must be run inside a Git work tree'
    return 1
  fi

  if git diff --cached --quiet; then
    warning 'no staged changes to prepare for commit'
    return 0
  fi

  git diff --cached | llm -t precommit -f swift-review
}

# Select a commit with fzf; Ctrl-E explains it and q returns to the picker.
# Usage: gitwhy
function gitwhy() {
  __llm_require || return

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warning 'gitwhy must be run inside a Git work tree'
    return 1
  fi

  git log --format='%h %s' | fzf \
    --preview 'git show --color=always {1}' \
    --header 'Enter print hash • CTRL-E explain (q return)' \
    --bind "ctrl-e:execute(git show --color=never {1} | llm -s 'Explain the intent of this commit from its diff and message. Distinguish visible facts from inference.' | LESS= less -R)" |
    awk '{ print $1 }'
}

# Select a branch with fzf; Ctrl-E explains it and q returns to the picker.
# Usage: gitbranch
function gitbranch() {
  __llm_require || return

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warning 'gitbranch must be run inside a Git work tree'
    return 1
  fi

  git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort -u | fzf \
    --preview 'git log --oneline --graph --decorate --color=always -20 {1}' \
    --header 'Enter print branch • CTRL-E explain (q return)' \
    --bind "ctrl-e:execute(git log --oneline -20 {1} | llm -s 'Explain the recent intent and likely state of this Git branch from its commit history. Distinguish visible facts from inference.' | LESS= less -R)"
}

# Select a running Docker container; Ctrl-E diagnoses it and q returns to fzf.
# Usage: dockerpick
function dockerpick() {
  __llm_require || return

  if ! is_cmd docker; then
    warning 'docker is not installed or is not on PATH'
    return 1
  fi

  docker ps --format '{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}' | fzf \
    --delimiter '\t' \
    --preview 'docker logs --tail=100 {1} 2>&1' \
    --header 'Enter print container ID • CTRL-E diagnose (q return)' \
    --bind "ctrl-e:execute((docker inspect {1}; docker logs --tail=100 {1}) 2>&1 | llm -s 'Diagnose this Docker container state and recent logs. Separate symptoms from likely causes and suggest the next three diagnostic commands.' | LESS= less -R)" |
    cut -f1
}

# Generate a zsh command and write it to stdout without executing it.
# Usage: llm-command <request>
function llm-command() {
  __llm_require || return
  llm -t zsh -f macos-cli "$*"
}

# Shorthand for llm-command; the alias avoids extended-glob expansion of ??.
# Usage: ?? <request>
alias '??'=llm-command

# Replace the current ZLE buffer with a generated zsh command for review.
# Bound to Option-?; it refuses an empty buffer and never executes the result.
function llm-command-widget() {
  __llm_require || return

  if [[ -z $BUFFER ]]; then
    zle -M 'Describe the command in the current buffer first'
    return 1
  fi

  local generated
  generated="$(llm -t zsh -f macos-cli "$BUFFER")" || return
  BUFFER=$generated
  CURSOR=${#BUFFER}
  zle -R
}

zle -N llm-command-widget
# Option-? turns the natural-language buffer into a reviewable zsh command.
bindkey '^[?' llm-command-widget
