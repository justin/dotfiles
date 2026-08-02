# GitHub Actions Workflow Instructions

These instructions apply to files in `.github/workflows/`. Follow the
repository-wide rules in `../../AGENTS.md` as well.

## Workflow Changes

- Keep workflow intent obvious from names and comments.
- Give each non-trivial step a descriptive `name` that explains its purpose.
- Add or update `run-name` when it improves traceability in Actions history.
- Keep push and pull-request triggers narrowly scoped with `paths`.
- Preserve existing container and environment conventions unless a concrete
  requirement justifies changing them.
- Prefer repository-defined commands, such as Just recipes, over duplicated
  command sequences.
- Use least-privilege permissions and do not mask command failures.

Before completion, verify trigger scope, names, run identity, runtime,
permissions, command sources, failure signals, and execution frequency. Report
what changed and why, validation performed, and risks involving triggers,
permissions, runtime, caching, or run frequency.

## File Requirements

For `ci.yml`:

- Keep the workflow name `ci` unless explicitly requested otherwise.
- Keep `main` in `on.push.branches` and use repository-relevant push paths.
- Keep `clone-and-install` on the established devcontainer image family.
- Check out the repository before repository-dependent commands.
- Preserve the `$HOME/.local/bin` export to `GITHUB_PATH` when required.
- Verify chezmoi after installation.

For `copilot-setup-steps.yml`:

- Keep the `copilot-setup-steps` job id required by GitHub Copilot.
- Keep `workflow_dispatch` and path-scoped push and pull-request triggers for
  this workflow file.
- Keep `contents: read` unless broader permissions are explicitly justified.
- Check out the repository before setup, installation, and verification.
- Install required system dependencies before they are used.
- Run `./install.sh` unless an equivalent replacement is requested.
- Report the environment and relevant tool versions during verification.

## Validation

Run a static YAML or CI syntax check when available. Manually review trigger
scope, permissions, and step order. State why any applicable check was not run.
