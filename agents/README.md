# SmartLockers Client Manager - Claude Code Agents

This directory contains project-specific sub-agents for Claude Code specialized task delegation.

## Available Agents

### 🔧 claude-code-optimizer

**Purpose:** Expert in Claude Code configuration and optimization

**Use PROACTIVELY for:**
- Auditing Claude Code setup (skills, agents, commands, hooks)
- Improving configuration based on official best practices
- Optimizing existing components for better performance
- Fixing YAML frontmatter issues
- Creating new skills/agents when needed
- Consulting latest Claude Code documentation

**Key Capabilities:**
- ✅ Audits entire `.claude/` directory structure
- ✅ Validates YAML frontmatter syntax
- ✅ Fetches latest official documentation
- ✅ Provides detailed optimization reports
- ✅ Implements improvements incrementally
- ✅ Documents rationale for all changes

**Tools:** Read, Write, Edit, Grep, Glob, Bash, WebFetch

**Model:** Inherits from main conversation

**Example Invocations:**
```
"Optimize my Claude Code setup"
"Audit my .claude/ configuration"
"Check if my skills follow best practices"
"Help me improve my agents"
"Review my CLAUDE.md file"
```

---

### 📚 documentation-architect

**Purpose:** Expert in documentation and memory bank optimization

**Use PROACTIVELY when:**
- User mentions "documentation", "memory", "context"
- Memory bank usage > 70%
- After completing major tasks/reviews
- User wants to optimize CLAUDE.md

**Key Capabilities:**
- ✅ Audits memory bank usage and suggests optimizations
- ✅ Detects and cleans temporary files (reviews, tasks, prompts)
- ✅ Creates concise quick-reference guides
- ✅ Consolidates redundant documentation
- ✅ Organizes core vs contextual loading
- ✅ Delegates to other agents for decisions
- ❌ **NEVER modifies CLAUDE.md without explicit confirmation**

**Tools:** Read, Write, Edit, Glob, Grep, Bash, Task

**Model:** Inherits from main conversation

**Slash Commands:**
```
/optimize-memory     # Audit memory bank + propose optimizations
/clean-docs          # Clean temporary documentation files
/doc-quick-ref [component]  # Create quick reference guide
```

**Example Invocations:**
```
"Memory bank is at 75%, can you optimize?"
"Clean up old review files from documentation/"
"Create a quick reference for the cache-resilience pattern"
"Archive completed tasks older than 30 days"
```

**Cleanup Workflow:**
1. Scans for temporary files > 30 days old
2. Identifies files not referenced in CLAUDE.md
3. Proposes archiving (conservative) or deletion (aggressive)
4. Calculates token/disk savings
5. ALWAYS asks for confirmation before any action

**Collaboration:**
- Consults `@agent-software-architect` for architecture decisions
- Consults `@agent-product-owner-functional` for functional priorities
- Consults `@agent-claude-code-optimizer` for Claude Code best practices

---

## How Sub-Agents Work

### Automatic Delegation

Claude Code proactively delegates to agents when:
- Task description matches agent's expertise
- Agent description includes "PROACTIVELY" keyword
- Context suggests specialized knowledge needed

### Explicit Invocation

You can manually request specific agents:
```
"Use the claude-code-optimizer agent to audit my setup"
```

### Independent Context

Each agent:
- Has its own context window (separate from main conversation)
- Uses specific tools configured in its definition
- Follows its custom system prompt
- Can use different models (sonnet, opus, haiku, or inherit)

## Agent Structure

Each agent is a markdown file with YAML frontmatter:

```markdown
---
name: agent-name
description: When and why to invoke this agent
tools: Tool1, Tool2, Tool3  # Optional, inherits all if omitted
model: sonnet               # Optional, uses configured default if omitted
---

System prompt describing role, expertise, and workflow...
```

## Creating New Agents

### Quick Method (Recommended)

1. Run `/agents` command in Claude Code
2. Select "Create New Agent"
3. Choose "Project" scope (shared with team)
4. Define agent with interactive prompts

### Manual Method

1. Create file: `.claude/agents/agent-name.md`
2. Add YAML frontmatter with required fields
3. Write detailed system prompt
4. Save and agent is automatically discovered

## Best Practices

### Agent Design

- ✅ **Single responsibility:** One focused purpose per agent
- ✅ **Clear description:** Include "use when..." or "PROACTIVELY" triggers
- ✅ **Minimal tools:** Only grant necessary tool access
- ✅ **Detailed prompts:** Provide examples, workflows, checklists
- ✅ **Inherit model:** Use `model: inherit` unless specific model needed

### Tool Restrictions

Limit tool access to minimum required:
- **Code review:** Read, Grep, Glob, Bash
- **Documentation:** Read, Write, WebFetch
- **Testing:** Read, Bash
- **Optimization:** All tools (for this meta-agent)

### System Prompt Quality

Good system prompts include:
1. Clear role definition
2. Specific responsibilities
3. Step-by-step workflows
4. Examples and templates
5. Quality checklists
6. Error patterns to detect
7. Communication style guidelines

## Version Control

**Project agents** (in `.claude/agents/`) are:
- ✅ Checked into git
- ✅ Shared with all team members
- ✅ Versioned with the codebase
- ✅ Automatically available to everyone

**User agents** (in `~/.claude/agents/`) are:
- Personal to individual developer
- Not shared via git
- Available across all projects

## Management

### Using `/agents` Command

```bash
# View all agents
/agents

# Create new agent (interactive)
/agents create

# Edit existing agent
/agents edit agent-name

# Delete agent
/agents delete agent-name
```

### Direct File Management

```bash
# List all project agents
ls -la .claude/agents/

# Edit agent
vim .claude/agents/agent-name.md

# Delete agent
rm .claude/agents/agent-name.md
```

## Integration with SmartLockers

### Project-Specific Context

All agents have access to:
- **CLAUDE.md** - Project instructions and standards
- **Documentation** - `documentation/` directory
- **Codebase** - All source files via Read/Grep/Glob tools

### SmartLockers Standards

Agents should enforce:
- Architecture fonctionnelle pure (no classes)
- Function naming (snake_case with prefixes)
- Cache-first pattern
- Bearer token auth
- PHPStan niveau 6 compliance
- 70/20/10 testing strategy
- UUID usage for lockers

## Troubleshooting

### Agent Not Triggering

1. **Check description:** Must include clear trigger conditions
2. **Verify YAML:** Syntax must be valid
3. **Add PROACTIVELY:** Include keyword in description
4. **Restart Claude Code:** Changes may need session restart

### YAML Validation Errors

Common issues:
- ❌ Tabs instead of spaces
- ❌ Missing closing `---`
- ❌ Invalid field names (use hyphens, not underscores)
- ❌ Tool names don't match available tools

### Agent Using Wrong Tools

- Check `tools:` field in frontmatter
- Ensure tool names are comma-separated
- Omit field to inherit all tools

## Resources

- **Official Docs:** https://docs.claude.com/en/docs/claude-code/sub-agents.md
- **Project Instructions:** `../CLAUDE.md`
- **Skills:** `.claude/skills/`
- **Slash Commands:** `.claude/commands/`

## Related Components

- **Skills** (`.claude/skills/`) - Reusable capabilities for main conversation
- **Slash Commands** (`.claude/commands/`) - Custom CLI commands
- **Plugins** - Bundled tools and agents from marketplace
- **Hooks** (`.claude/hooks/`) - Automated responses to events
