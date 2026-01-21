---
name: skill-stats
description: Display skill/command usage statistics from tracking logs.
allowed-tools: Bash, Read
argument-hint: [days]
---

# Skill Usage Statistics

Display usage statistics for skills and commands.

## Usage

```
/skill-stats [days]
```

- `days` (optional): Number of days to analyze (default: 30)

## What It Shows

1. **By frequency**: Most used skills/commands ranked
2. **By date**: Daily usage counts
3. **Total invocations**: Overall count

## Example Output

```
=== Skill/Command Usage Statistics (last 30 days) ===

## By frequency:
  15 fix-phpstan
   8 code-review
   5 task
   3 update-docs
   2 create-client-migration

## By date:
   5 2026-01-21
   3 2026-01-20
   4 2026-01-19

## Total invocations:
23
```

## Log Location

Data stored in: `.claude/logs/skill-usage.log`

## Implementation

Execute the stats script:

```bash
.claude/hooks/show-skill-stats.sh $ARGUMENTS
```
