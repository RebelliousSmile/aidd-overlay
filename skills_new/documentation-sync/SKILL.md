---
name: documentation-sync
description: |
  Unified documentation management skill. Modes: sync (code→docs), clean (cleanup),
  quick-ref (create guide), check (verify integrity), optimize (reduce tokens).
  Use PROACTIVELY after code changes or when user mentions documentation.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: [mode] [target]
---

# Documentation Sync

Unified skill for all documentation operations in SmartLockers project.

## Modes

| Mode | Command | Description |
|------|---------|-------------|
| **sync** | `/documentation-sync` | Sync code → docs (default) |
| **clean** | `/documentation-sync clean` | Cleanup temporary files |
| **quick-ref** | `/documentation-sync quick-ref <name>` | Create quick reference guide |
| **check** | `/documentation-sync check` | Verify memory-bank integrity |
| **optimize** | `/documentation-sync optimize` | Audit and reduce token usage |

## Mode: sync (default)

Synchronize code changes with documentation.

### Trigger Conditions (Proactive)
- PHP functions added/modified in `code/clients/`, `code/apis/`, `code/providers/`
- Database tables created or modified
- API routes modified
- User mentions: "doc", "documentation", "update doc"

### Workflow

1. **Detect changes**: `git diff HEAD~1 --name-status`
2. **Map to docs**: Load `reference.md` for code→docs mapping
3. **Generate updates**: PHPDoc, API docs, schema docs
4. **Validate**: Check syntax, links, consistency
5. **Apply with confirmation**: Never auto-modify without user approval

### Usage
```bash
/documentation-sync                    # Sync recent changes
/documentation-sync sync clients/      # Sync specific directory
/documentation-sync sync HEAD~5..HEAD  # Sync commit range
```

## Mode: clean

Cleanup temporary documentation files.

### What Gets Cleaned
- `documentation/reviews/` - Completed code reviews (> 30 days)
- `documentation/tasks/` - Finished tasks
- `CLAUDE.md.backup-*` - Old backups

### Workflow

1. **Scan** for temporary/old files
2. **Calculate** token/disk savings
3. **Propose** archiving or deletion
4. **Execute** with user confirmation only

### Usage
```bash
/documentation-sync clean              # Interactive cleanup
/documentation-sync clean --dry-run    # Preview only
```

## Mode: quick-ref

Create concise quick reference guides (< 2k tokens).

### Guide Structure
1. **TL;DR** (30 seconds) - Core concept
2. **Quick Reference** (5 minutes) - Code examples
3. **Deep Dive** - Links to full docs

### Workflow

1. **Consult** existing documentation
2. **Extract** key concepts and code examples
3. **Generate** using `templates/quick-ref.md`
4. **Save** to `documentation/memory-bank/guides/`

### Usage
```bash
/documentation-sync quick-ref cache-first
/documentation-sync quick-ref jwt-auth
/documentation-sync quick-ref sync-api
```

## Mode: check

Verify memory-bank coherence and integrity.

### Checks Performed
- Referenced files exist
- No duplicates in CLAUDE.md
- Token estimates vs actual sizes
- Orphaned files detection

### Output
```markdown
## Memory Bank Health Check
- Valid files: X/X
- Missing files: 0
- Duplicates: 0
- Recommendations: [...]
```

### Usage
```bash
/documentation-sync check
```

## Mode: optimize

Audit memory bank and propose token reduction.

### Analysis
- Current usage (tokens, files)
- Redundant or obsolete files
- Consolidation opportunities
- CLAUDE.md structure improvements

### Workflow

1. **Analyze** current state
2. **Identify** optimization targets
3. **Calculate** potential savings
4. **Propose** changes (never auto-modify CLAUDE.md)

### Usage
```bash
/documentation-sync optimize
```

## Supporting Files

| File | Purpose | When to Load |
|------|---------|--------------|
| `reference.md` | Code→docs mapping, 8 directories | sync, check |
| `templates/quick-ref.md` | Quick reference template | quick-ref |
| `templates/sync-report.md` | Sync report template | sync |
| `scripts/detect-changes.sh` | Git diff analysis | sync |
| `scripts/check-memory.sh` | Memory-bank verification | check |

## Important Rules

### ❌ NEVER
- Delete documentation without explicit confirmation
- Modify CLAUDE.md automatically
- Overwrite manually written content
- Create files outside the 8 documentation directories

### ✅ ALWAYS
- Ask confirmation before changes
- Preserve existing business descriptions
- Respect the 8-directory structure
- Calculate and show token impact

## 8 Documentation Directories (Strict)

```
documentation/
├── memory-bank/     # Core docs (80-90% of needs)
├── notebooks/       # Deep analysis
├── guides/          # Step-by-step tutorials
├── diagrams/        # Architecture visuals
├── tasks/           # Task definitions
├── reviews/         # Code reviews
├── reports/         # Technical reports
└── wireframes/      # UI mockups
```
