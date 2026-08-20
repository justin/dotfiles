# Agent workflows

This directory contains deterministic developer-workflow automation shared by
Codex and Claude Code. Tool-specific configuration remains in each client's
configuration directory and calls into the scripts here.

## GitHub issue session titles

`scripts/github_issue_session_title.py` handles the common workflow:

1. Detect one unambiguous GitHub issue in the initial prompt.
2. Derive the repository from an explicit reference or the current Git origin.
3. Resolve the canonical issue title with `gh issue view`.
4. Store per-client, per-session state under
   `$XDG_STATE_HOME/agent-workflows/github-issue-session-title`.
5. Return the client-specific naming response.

Codex receives an exact `CODEX_THREAD_TITLE` instruction and uses its task-title
tool. Claude Code receives `hookSpecificOutput.sessionTitle` and applies the
title directly. A later prompt can change the title only when the session was
already associated with an issue and the prompt clearly names a different one.

Ambiguous references, missing tools, authentication failures, and unresolved
issues leave the existing title unchanged. Naming failures never block the
user's request.

## Extending the framework

Keep parsing, external lookups, state, and failure handling in a shared script.
Keep lifecycle registration and host-specific outputs in small client adapters.
Do not add a client to shared behavior until that client's documented API can
support the intended outcome.
