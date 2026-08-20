# Codex customizations

This directory is the version-controlled source for global Codex behavior. Chezmoi installs it at `~/.config/codex`; `~/.codex` is a managed symlink to that directory. Deterministic behavior shared with Claude Code lives under `~/.config/agent-workflows`.

## Layout

- `AGENTS.md` links to rendered global instructions that repository instructions can refine.
- `hooks.json` wires small lifecycle entry points to deterministic scripts.
- `~/.config/agent-workflows/scripts/` contains procedural implementation shared by Codex and Claude Code hooks.
- `~/.agents/skills/` contains reusable workflows discovered by both clients.

Codex runtime files in this directory remain unmanaged unless they are explicitly represented in the dotfiles source. In particular, `config.toml` is reconciled by its existing modify template so app-owned settings and state survive `chezmoi apply`.

## GitHub issue task names

The `UserPromptSubmit` hook recognizes one unambiguous GitHub issue in the initial prompt. Supported forms are:

- `https://github.com/owner/repository/issues/123`
- `owner/repository#123`
- `Issue #123` or `Fix #123` when the current repository has a GitHub `origin`
- `#123` when it is the complete prompt and the current repository has a GitHub `origin`

The shared script resolves the canonical title with `gh issue view` and injects an exact `CODEX_THREAD_TITLE` instruction. The active agent invokes its thread-title tool, which keeps the mutation on the Codex host that owns the task and sidebar. Per-session state under `$XDG_STATE_HOME/agent-workflows` prevents repeated attempts; a later prompt can rename the task only when it clearly names a different issue.

Ambiguous references, non-GitHub remotes, missing tools, authentication failures, and unresolved issues leave the existing task name unchanged. The hook never blocks the user's request.

After installing or changing a user hook, open `/hooks` in Codex to review and trust its current definition.

## Extending the framework

Keep lifecycle wiring in `hooks.json` small. Put reusable deterministic behavior under `~/.config/agent-workflows/scripts/`, and put agent-driven workflows in one focused directory under `~/.agents/skills`. Manage only individual skill directories so skills installed by other tools remain untouched.
