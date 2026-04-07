---
name: close-issue
description: Issue closing comment template — summary, changelog entry, and checklist
---

<!--
AI instructions:
- Replace all {variables} with actual values.
- Base the summary on the plan and commits, not on assumptions.
- Changelog entry follows Keep a Changelog format.
- Omit optional sections if empty.
-->

## ✅ Done

{One sentence: what was implemented and why it matters.}

## 📋 Changelog entry

```
### {Added|Changed|Fixed|Removed} — {scope}
- {concise description of the change, user-facing}
```

## 🔗 References

- **PR**: {pr_url}
- **Branch**: `{branch}`
- **Plan**: {plan_file_path | none}

## 🧪 Checklist

- [ ] Both reviews passed (code + functional)
- [ ] Tests green
- [ ] Branch merged

## 🗒️ Notes (optional)

{Known limitations, follow-up issues to open, observations.}
