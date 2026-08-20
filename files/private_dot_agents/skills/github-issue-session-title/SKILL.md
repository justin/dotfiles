---
name: github-issue-session-title
description: Align the current Codex or Claude session name with one clearly referenced GitHub issue. Use when developer context supplies `CODEX_THREAD_TITLE` or when the user explicitly asks to name the current session from a GitHub issue. Automatic issue detection is handled by the global hook.
---

# GitHub issue session title

1. Identify exactly one issue from a GitHub issue URL, `owner/repository#123`, or a local `#123` reference whose repository can be derived from the current Git checkout.
2. If the reference is ambiguous or the repository cannot be determined, leave the session name unchanged and continue the user's request.
3. Resolve the canonical issue title with the available GitHub integration or `gh issue view`. Do not infer a missing title.
4. Use the exact name `#<number> <canonical title>`.
5. When developer context supplies `CODEX_THREAD_TITLE`, use that exact value with the Codex thread-title tool and omit the thread ID so the calling task is targeted.
6. Claude Code naming is normally completed directly by the prompt-submission hook. Do not duplicate it or ask the user to rename the session.
7. Treat naming as housekeeping: never block the substantive request, and continue silently when issue resolution or session naming is unavailable.
