# Claude Code customizations

This directory is the version-controlled source for global Claude Code behavior.
Chezmoi installs it at `~/.config/claude`; `~/.claude` is a managed symlink to
that directory.

The settings modify template reconciles the GitHub issue session-title handler
into `UserPromptSubmit` while preserving every unrelated hook and runtime-owned
setting. The handler calls the shared script under
`~/.config/agent-workflows/scripts/`, which returns Claude Code's documented
`sessionTitle` output directly.

Global skills are shared with Codex through the existing `~/.claude/skills`
symlink to `~/.agents/skills`.
