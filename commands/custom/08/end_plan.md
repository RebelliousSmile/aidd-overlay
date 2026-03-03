---
name: 'custom:08:end_plan'
description: 'Archive the plan as processed, run /learn, return to parent branch and clean up'
---

# End Plan Prompt

After a PR/MR has been created on a plan branch, archive the plan and cleanly return to the parent branch.

## Rules

- Never force-delete a branch with uncommitted changes
- Never push anything
- Always pull after checkout
- Confirm branch deletion with user before executing

## Steps

1. Get current task branch name: `` `git branch --show-current` ``
2. Detect parent branch:
   - `` `git log --oneline --decorate HEAD` `` to find branch point
   - Fallback: ask user to confirm parent branch name
3. Confirm: display task branch → parent branch, ask user to validate
4. Find the plan file: search `aidd_docs/tasks/` for a `.md` file (not `.processed.md`, not `.review.md`) whose content contains `` **Branch name**: `<current-branch>` ``
   - If not found: ask user to identify the plan file
5. Rename plan file from `<name>.md` to `<name>.processed.md`
6. Ask user: run `/learn` to capture learnings? (optional)
7. Checkout parent: `` `git checkout <parent>` ``
8. Merge plan branch: `` `git merge --no-ff <plan-branch>` ``
9. Push: `` `git push` ``
10. Ask user: delete plan branch? (local only / local + remote / keep)
    - Local: `` `git branch -D <plan-branch>` ``
    - Remote: `` `git push origin --delete <plan-branch>` ``
11. Report final state: current branch, last commit, renamed plan file, deleted branches
