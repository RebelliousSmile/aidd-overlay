---
name: review
description: Code review orchestrator - Triggers skill (quick) or agent (in-depth) according to context
---

# Command: Code Review

Intelligent code review orchestrator for SmartLockers. Automatically decides between quick review (skill) or in-depth (agent).

## Usage

```bash
/review [module] [--depth=quick|full]
```

## Parameters

- `module` (optional): Module name (ex: onet, sync-api, guesty, lockandchill)
- `--depth` (optional): `quick` (skill, 5 min) or `full` (agent, 15 min)

**If no parameter**: Automatic Git changes detection

## Workflow

### STEP 1: Scope Detection

**If module provided**:
```
Module: {module}
```

**If no module**:

Ask user via AskUserQuestion:

```
Which scope do you want to review?

A. Git branch (all changes since main)
B. Specific module (onet, cosyhosting, halpades, lockandchill, sync-api, database, auth)
C. Specific file(s)
D. All project files (complete audit)
```

**Available modules**:
- `onet`: code/clients/onet_functions.php + code/apis/pilotphone_functions.php + code/apis/planet_functions.php
- `cosyhosting`: code/clients/cosyhosting_functions.php + code/apis/guesty_functions.php
- `halpades`: code/clients/halpades_functions.php + code/apis/msexchange_functions.php
- `lockandchill`: code/clients/lockandchill_functions.php + code/apis/beds24_functions.php
- `sync-api`: code/src/services/smartlockers_sync.php
- `database`: code/src/services/database/mysql.php
- `auth`: code/src/services/auth.php

### STEP 2: Depth Decision (Automatic or Manual)

**If --depth provided**: Use the value

**If --depth NOT provided**: Automatic detection

```bash
# Count modified files and lines
files_count=$(echo "$files" | wc -w)
lines_count=$(cat $files | wc -l)

# Decision rules
if [ "$files_count" -lt 5 ] && [ "$lines_count" -lt 500 ]; then
    depth="quick"   # code-review skill
else
    depth="full"    # super-coder agent
fi
```

**User confirmation** (AskUserQuestion):

```
🔍 **Code Review Parameters**

Module: {module}
Files: {files_count}
Lines: {lines_count}

Recommended depth: {depth}

Options:
- ⚡ Quick: Fast review (5 min) via code-review skill
- 🔬 Full: In-depth review (15 min) with detailed scoring via super-coder agent

Which depth do you want to use?
```

### STEP 3: Review Delegation

#### If depth = quick

```markdown
⚡ **Quick Review (Skill)**

Launching code-review skill for quick review...
```

Use skill `code-review` with module files.

#### If depth = full

```markdown
🔬 **Full Review (Agent)**

Launching in-depth review with scoring...
```

Use agent `super-coder` or specialized review agent.

### STEP 4: Generate Report

Save review to `documentation/reviews/code-review-{module}-{date}.md`

Display summary to user with key findings and recommendations.
