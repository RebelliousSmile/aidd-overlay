# Claude Code Configuration - SmartLockers Client Manager

This directory contains the complete Claude Code configuration for the SmartLockers Client Manager project.

## 📁 Directory Structure

```
.claude/                         # 🔧 Configuration (Templates/How to work)
├── agents/                      # Sub-agents for specialized tasks
│   ├── claude-code-optimizer.md  # Meta-agent for Claude Code optimization
│   └── README.md
├── commands/                    # Custom slash commands
│   ├── analyze-api-cache.md
│   ├── create-client-migration.md
│   ├── fix-phpstan.md
│   ├── review-and-fix.md
│   ├── task.md
│   ├── update-docs.md
│   └── README.md
├── skills/                      # Reusable capabilities
│   ├── code-review/
│   │   └── SKILL.md
│   ├── smartlockers-sync/
│   │   └── SKILL.md
│   ├── task-definition/
│   │   └── SKILL.md
│   ├── user-story/
│   │   └── SKILL.md
│   └── README.md
├── settings.json               # Claude Code settings
├── settings.local.json         # Local overrides (not in git)
└── README.md                   # This file

documentation/                   # 📄 Historical Records (What was done)
├── prompts/                     # Executed prompts/strategies (reference)
├── reviews/                     # Completed code reviews (examples)
└── tasks/                       # Finished tasks (knowledge base)
```

### 📌 Important Distinction

| Directory | Purpose | Usage |
|-----------|---------|-------|
| **`.claude/`** | Active configuration | Templates Claude uses to work |
| **`documentation/`** | Historical records | Past work for reference/learning |

**Do NOT move** files from `documentation/` to `.claude/` - they serve different purposes!

## 🎯 Quick Start

### For New Team Members

1. **Clone the repository** - Configuration is automatically available
2. **Start Claude Code** - Skills, agents, and commands auto-discovered
3. **Read CLAUDE.md** - Project-specific instructions in root directory
4. **Try commands:**
   ```
   /task            # Execute complete task with tests and commit
   /review-and-fix  # Automated code review and critical fixes
   /update-docs     # Update documentation after code changes
   ```

### For Experienced Users

- **Skills** trigger automatically based on context
- **Agents** handle specialized sub-tasks
- **Commands** provide quick workflows
- **Settings** customize Claude Code behavior

## 🔧 Components Overview

### 1. Skills (`.claude/skills/`)

**Reusable capabilities for the main conversation**

| Skill | Trigger | Purpose |
|-------|---------|---------|
| **code-review** | "review this code" | Structured code review with SmartLockers checklist |
| **task-definition** | "create a task for..." | Task definition with DoD and testing strategy |
| **smartlockers-sync** | "define sync mapping..." | Data mapping external API → SmartLockers |
| **user-story** | "write a user story..." | User story with acceptance criteria |

**How they work:**
- Claude automatically detects when to use them
- Can be invoked manually: "Use the code-review skill..."
- Each skill has specific tools and focused purpose

📖 **[Full Skills Documentation](skills/README.md)**

---

### 2. Sub-Agents (`.claude/agents/`)

**Specialized AI assistants for complex tasks**

| Agent | Expertise | Auto-Trigger |
|-------|-----------|--------------|
| **claude-code-optimizer** | Claude Code config optimization | ✅ PROACTIVE |

**Key features:**
- Independent context window (doesn't clutter main chat)
- Custom system prompts with domain expertise
- Restricted tool access for safety
- Can chain multiple agents for workflows

**Usage:**
- Automatic: Claude delegates when task matches expertise
- Manual: "Use the claude-code-optimizer agent to audit my setup"

📖 **[Full Agents Documentation](agents/README.md)**

---

### 3. Slash Commands (`.claude/commands/`)

**Quick custom workflows**

| Command | Purpose | Tasks Performed |
|---------|---------|----------------|
| **/task** | Complete task execution | Code + Tests + Commit |
| **/review-and-fix** | Automated code review | Review + Critical fixes |
| **/update-docs** | Documentation maintenance | Update docs after changes |
| **/analyze-api-cache** | Cache analysis | Analyze API caching patterns |
| **/create-client-migration** | Client setup | Bootstrap new client |
| **/fix-phpstan** | PHPStan fixes | Fix static analysis errors |

**How to use:**
```bash
/task "Implement user authentication"
/review-and-fix
/update-docs
```

📖 **[Full Commands Documentation](commands/README.md)**

---

### 4. Settings (`.claude/settings.json`)

**Claude Code configuration**

- Model selection
- Tool permissions
- Hooks configuration
- Output formatting
- Memory management

**Local overrides:** Use `settings.local.json` (gitignored) for personal preferences

---

## 🚀 Common Workflows

### Development Workflow

1. **Start task:**
   ```
   /task "Add webhook validation for reservations"
   ```

2. **Claude automatically:**
   - Uses `task-definition` skill to structure the task
   - Implements code following SmartLockers standards
   - Runs PHPStan and tests (70/20/10 strategy)
   - Creates commit if tests pass

3. **Review changes:**
   ```
   /review-and-fix
   ```

4. **Update documentation:**
   ```
   /update-docs
   ```

---

### Integration Workflow

1. **Define sync mapping:**
   ```
   "Define sync mapping for Guesty reservations to SmartLockers"
   ```

2. **Claude uses `smartlockers-sync` skill to:**
   - Analyze Guesty API structure
   - Map fields to SmartLockers entities
   - Generate complete specification
   - Include validation rules

3. **Implement sync function:**
   ```
   /task "Implement Guesty sync based on specification"
   ```

---

### Optimization Workflow

1. **Audit configuration:**
   ```
   "Optimize my Claude Code setup"
   ```

2. **`claude-code-optimizer` agent:**
   - Audits `.claude/` directory
   - Consults latest official docs
   - Provides detailed report with issues and recommendations
   - Implements fixes if requested

3. **Review improvements:**
   - Agent shows before/after
   - Explains rationale
   - Documents changes

---

## 📚 Project Standards

All skills, agents, and commands enforce SmartLockers standards:

### Architecture
- ✅ Functional programming (no classes)
- ✅ Manual `require_once` (no autoloading)
- ✅ Three layers: `code/clients/`, `code/apis/`, `code/providers/`
- ✅ Function prefixes: `client_`, `api_`, `provider_`, `db_`, `auth_`

### Code Quality
- ✅ PHPStan niveau 6 (0 errors)
- ✅ PHPDoc comments on all public functions
- ✅ snake_case naming
- ✅ Cache-first pattern (only update on HTTP 2xx)

### Testing (70/20/10 Strategy)
- ✅ 70% - PHPStan static analysis
- ✅ 20% - Contract tests (5-8 max)
- ✅ 10% - Integration tests (2-3 flows)

### Data & Security
- ✅ Bearer token authentication (no sessions)
- ✅ UUID for locker identification (not numeric IDs)
- ✅ Input validation and sanitization
- ✅ Database schema validation

**Reference:** `../CLAUDE.md` (project instructions)

---

## 🔄 Customization

### Adding New Skills

1. **Create directory:**
   ```bash
   mkdir .claude/skills/my-skill/
   ```

2. **Create SKILL.md:**
   ```yaml
   ---
   name: my-skill
   description: What it does and when to use it
   allowed-tools: Read, Write, Edit
   ---

   # Instructions for Claude...
   ```

3. **Restart Claude Code** - Skill auto-discovered

### Adding New Agents

1. **Use `/agents` command** (recommended):
   ```
   /agents create
   ```

2. **Or create manually:**
   ```bash
   vim .claude/agents/my-agent.md
   ```

   ```yaml
   ---
   name: my-agent
   description: Expert in X. Use PROACTIVELY for Y.
   tools: Read, Grep, Bash
   model: inherit
   ---

   You are an expert in...
   ```

### Adding New Commands

1. **Create command file:**
   ```bash
   vim .claude/commands/my-command.md
   ```

2. **Add command content:**
   ```markdown
   # My Command Description

   Instructions for what this command should do...
   ```

3. **Use command:**
   ```
   /my-command
   ```

---

## 🧪 Testing Your Configuration

### Validate YAML Syntax

```bash
# Check all skills
find .claude/skills -name "SKILL.md" -exec head -10 {} \;

# Check all agents
find .claude/agents -name "*.md" -exec head -10 {} \;
```

### Test Skills

1. Trigger skill manually:
   ```
   "Use the code-review skill to review src/services/sync.php"
   ```

2. Verify output matches expected format

### Test Agents

1. Invoke agent explicitly:
   ```
   "Use the claude-code-optimizer agent to audit my setup"
   ```

2. Check that agent uses correct tools and provides detailed analysis

### Test Commands

1. Run command:
   ```
   /task "Simple test task"
   ```

2. Verify workflow executes correctly

---

## 🐛 Troubleshooting

### Skills Not Triggering

**Problem:** Skill doesn't activate when expected

**Solutions:**
1. Check YAML syntax (no tabs, valid fields)
2. Improve description to include clear triggers
3. Restart Claude Code session
4. Use skill manually to verify it works

### Agent Not Found

**Problem:** "Agent X not found"

**Solutions:**
1. Verify file exists: `ls .claude/agents/`
2. Check YAML frontmatter is valid
3. Ensure `name:` matches filename
4. Restart Claude Code

### Command Not Working

**Problem:** Slash command not recognized

**Solutions:**
1. Check file exists in `.claude/commands/`
2. Verify no syntax errors
3. Use `/help` to see available commands
4. Restart Claude Code

### YAML Validation Errors

**Common issues:**
- ❌ Tabs instead of spaces
- ❌ Missing closing `---`
- ❌ Invalid field names (use hyphens: `allowed-tools`, not `allowed_tools`)
- ❌ Tool names don't match available tools

**Fix:** Compare against working examples in this directory

---

## 📖 Resources

### Official Documentation

- **Claude Code Docs:** https://docs.claude.com/en/docs/claude-code/
- **Skills Guide:** https://docs.claude.com/en/docs/claude-code/skills.md
- **Sub-Agents Guide:** https://docs.claude.com/en/docs/claude-code/sub-agents.md
- **Slash Commands:** https://docs.claude.com/en/docs/claude-code/slash-commands.md

### Project Documentation

- **Project Instructions:** `../CLAUDE.md`
- **Architecture:** `../documentation/architecture/`
- **Development Guide:** `../documentation/developpement/`
- **Functional Specs:** `../documentation/fonctionnel/`

### Component READMEs

- **Skills:** [skills/README.md](skills/README.md)
- **Agents:** [agents/README.md](agents/README.md)
- **Commands:** [commands/README.md](commands/README.md)

---

## 🤝 Contributing

### Before Committing Changes

1. **Test your changes** locally
2. **Validate YAML** syntax
3. **Update documentation** if adding new components
4. **Follow naming conventions** (lowercase, hyphens)
5. **Get review** from team if major changes

### Naming Conventions

- **Skills:** `skill-name` (lowercase, hyphens)
- **Agents:** `agent-name.md` (lowercase, hyphens)
- **Commands:** `command-name.md` (lowercase, hyphens)
- **Directories:** Same as component name

### Documentation Standards

- README.md in each subdirectory
- YAML frontmatter examples
- Usage examples with concrete cases
- Troubleshooting section

---

## 🎓 Best Practices

### Skill Design

✅ **Do:**
- Single, focused purpose
- Clear trigger conditions in description
- Minimal tool access
- Include examples and templates

❌ **Don't:**
- Multiple unrelated responsibilities
- Vague or generic descriptions
- Access to all tools by default
- Overly complex system prompts

### Agent Design

✅ **Do:**
- Specialized domain expertise
- Detailed system prompt with workflows
- Appropriate tool restrictions
- "PROACTIVELY" keyword if should auto-trigger

❌ **Don't:**
- Overlapping with other agents
- Too broad or unfocused scope
- Excessive tool permissions
- Duplicate built-in agent functionality

### Command Design

✅ **Do:**
- Clear, concise instructions
- Specific task workflow
- Include error handling
- Document expected outputs

❌ **Don't:**
- Duplicate built-in commands
- Ambiguous or multi-step prompts
- Missing context or examples
- Overly generic commands

---

## 📊 Current Setup Summary

**Last updated:** 2025-10-24

### Statistics

- **Skills:** 4 (code-review, task-definition, smartlockers-sync, user-story)
- **Agents:** 1 (claude-code-optimizer)
- **Commands:** 6 (task, review-and-fix, update-docs, analyze-api-cache, create-client-migration, fix-phpstan)
- **Settings:** 2 files (settings.json + settings.local.json)

### Coverage

- ✅ Code review automation
- ✅ Task definition and execution
- ✅ Data synchronization specifications
- ✅ User story creation
- ✅ Claude Code optimization
- ✅ Documentation maintenance
- ✅ Client bootstrapping
- ✅ Quality checks (PHPStan)

### Next Steps

Consider adding:
- [ ] Security audit agent
- [ ] Performance optimization agent
- [ ] Database migration skill
- [ ] API testing command
- [ ] Deployment automation

---

## 📞 Support

- **Issues with Claude Code:** https://github.com/anthropics/claude-code/issues
- **Project questions:** See team documentation
- **Configuration help:** Use `claude-code-optimizer` agent

---

**Maintained by:** SmartLockers Development Team
**License:** Same as project
**Version:** 1.0
