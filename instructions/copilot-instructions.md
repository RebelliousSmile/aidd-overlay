### Main Workflow for Copilot

Each step waits for user "oui" before continuing.

1. `brainstorm` or `create_user_story` → push to issue tracker
2. Plan with issue number → challenge until 100% confidence — always write plan to `aidd_docs/tasks`
3. Implement with @kent
4. Run tests — iterate until all tests pass
5. Functional review — fix all issues before proceeding
6. Code review — fix all issues before proceeding
7. If applicable: apply rules from `.github/instructions/custom/08-issue-closing.md`, then close the issue
8. Commit changes
9. End plan — confirm parent branch (default: main), run learning, delete branch
10. Changelog

## Available Instructions

See `.github/instructions/custom/` for project rules:
- `04-bruno.instructions.md` - Bruno API client rules
- `04-git-main-protection.instructions.md` - Git protection rules
- `04-rules-namespace.instructions.md` - Namespace convention
- `08-issue-closing.instructions.md` - Issue closing protocol
- `09-aidd-workflow.instructions.md` - AIDD workflow rules