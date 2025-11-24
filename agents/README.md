# Claude Code Agents - SmartLockers Client Manager

**Agent architecture**: 7 specialized agents with clearly defined responsibilities.

---

## 🎯 Agent Definitions

### 1. claude-code-optimizer

**Responsibilities**:
- Knowledge of Claude Code functionality
- Modifications in `.claude/` (agents, hooks, skills, config)
- Optimization of model responses
- Claude Code configuration optimization (project + global)

**Domain**: Meta-configuration (Claude Code itself)

**When to invoke**:
- Agent creation/modification
- Hooks/skills/commands configuration
- Prompt optimization
- Claude Code configuration improvement

**Available tools**: Read, Grep, Glob, WebFetch

---

### 2. documentation-architect

**Responsibilities**:
- Ensures files in `documentation/` respect the 8 defined directories
- Modifications in `documentation/`
- Optimizes knowledge used by models
- Optimizes quality and quantity of knowledge loaded in memory-bank

**Domain**: Documentation and memory bank

**8 mandatory directories**:
- `memory-bank/` (how to code + agent triggering)
- `notebooks/` (functional markdown docs, Warp compatible)
- `guides/` (end-user guides .tex LaTeX)
- `diagrams/` (visuals SVG, PNG, Mermaid)
- `reports/` (model-generated documents)
- `tasks/` (plans with subdirectories)
- `reviews/` (generated reviews)
- `wireframes/` (HTML interfaces)

**When to invoke**:
- Documentation organization/reorganization
- Memory-bank optimization
- Guide/notebook creation
- Documentation structure validation

**Available tools**: Read, Write, Edit, Glob, Grep, Bash, Task

---

### 3. test-architect

**Responsibilities**:
- Test project code functionality
- Verify tests are up to date and organized per project rules
- Launch tests that verify the requested task as quickly as possible
- Choose methods that allow analyzing test results **without user intervention**
- Fix tests if necessary

**Domain**: Tests and automated quality

**SmartLockers test strategy**: 70/20/10
- 70% PHPStan level 6
- 20% Contract tests (5-8 tests max)
- 10% Integration tests (2-3 critical flows)

**When to invoke**:
- Generated code validation
- Fix broken tests
- Add new tests
- Test coverage audit

**Available tools**: Read, Write, Edit, Bash, Glob, Grep

---

### 4. code-architect

**Responsibilities**:
- Project technology choices
- Define structures and rules underlying the code
- Analyze efficiency and quality of generated code
- Know security and code optimization best practices
- Propose improvements and enumerate code problems

**Domain**: Technical architecture and structural decisions

**When to invoke**:
- Architectural decisions (new module, refactoring)
- Code quality/security audit
- Performance optimization
- Pattern validation

**Available tools**: Read, Grep, Glob, Bash

---

### 5. super-coder

**Responsibilities**:
- Generate code respecting documentation
- If complex code: use tasks to break down generation
- Launch test-architect agent to test its work
- Launch other super-coder agents **in parallel** if it allows coding faster

**Domain**: Optimized and orchestrated code generation

**Workflow**:
1. Analyze task complexity
2. Break down if necessary (Task)
3. Generate code (respect documentation/)
4. Launch test-architect for validation
5. Fix if tests fail

**When to invoke**:
- Complex code generation
- Multi-file feature implementation
- Need for parallel orchestration
- Code requiring tests

**Available tools**: All tools

---

### 6. ux-designer

**Responsibilities**:
- Project ergonomics and styles
- Define and update style guide in `documentation/`
- Create wireframes to validate project ergonomics
- Organize wireframe code with super-coder

**Domain**: Design and user experience

**Deliverables**:
- Style guide (`documentation/wireframes/charte-graphique.md`)
- HTML wireframes (`documentation/wireframes/`)
- UX guidelines (`documentation/guides/ux-guidelines.tex`)

**When to invoke**:
- Interface creation/redesign
- Ergonomics validation
- Style guide update
- Wireframes for mockups

**Available tools**: Read, Write, Edit, Glob, Grep, Task

---

### 7. web-optimizer

**Responsibilities**:
- Check code compatibility for all browsers and devices
- Audit code accessibility
- Launch ux-designer to optimize responsive design
- Know and verify natural referencing rules for search engines (textual, voice, LLM)

**Domain**: Web optimization, accessibility, SEO

**Audits**:
- Browser compatibility (Chrome, Firefox, Safari, Edge)
- Responsive design (mobile, tablet, desktop)
- WCAG 2.1 AA accessibility
- SEO (Google, Bing, voice, LLM)

**When to invoke**:
- Accessibility audit
- Responsive optimization
- Compatibility verification
- SEO audit

**Available tools**: Read, Grep, Glob, Bash, Task

---

## 🔄 Agent Interactions

### Typical Workflow: New Feature

```
1. code-architect: Validates architecture
   ↓
2. super-coder: Generates code (breaks down if complex)
   ↓
3. test-architect: Tests and validates
   ↓
4. documentation-architect: Documents in notebooks/
   ↓
5. (Optional) ux-designer: Creates wireframes if UI
   ↓
6. (Optional) web-optimizer: Audits accessibility/responsive
```

### Parallel Orchestration

**super-coder can launch**:
- Multiple super-coders in parallel (independent files)
- test-architect after each generation

**web-optimizer can launch**:
- ux-designer for responsive optimization

**documentation-architect can launch**:
- Other agents for decision validation (code-architect, test-architect)

---

## 📋 General Rules

### Proactive Triggering

**Agents triggered automatically if**:
- **documentation-architect**: User mentions "docs", "memory", "context"
- **test-architect**: Code generated, user requests tests
- **code-architect**: Architectural decision needed
- **web-optimizer**: User mentions "accessible", "responsive", "SEO"

### Communication

**Agent report format**:
- Executive summary (< 100 words)
- Created/modified deliverables
- Actions performed
- Recommendations (if applicable)

**Logging**:
- All agents must trace their actions
- Reports saved in `documentation/reports/`

### Conventions

- **Respect documentation/**: All agents must respect 8-directory structure
- **No useless file creation**: Edit existing rather than create
- **Git commits**: NEVER without explicit user request
- **Validation**: Always validate with appropriate scripts (PHPStan, tests, etc.)

---

## 🚀 Usage

### Invoke an Agent

```bash
# Via mention in conversation
@agent-super-coder generate code for module X

# Via Task tool (if agent not available via mention)
Task(subagent_type="super-coder", prompt="generate module X")
```

### Create New Agent

1. Consult `claude-code-optimizer`
2. Define responsibilities clearly
3. Avoid overlaps with existing agents
4. Create file `.claude/agents/agent-name.md`
5. Update this README

---

## 📚 Documentation

- **Claude Code Configuration**: `.claude/README.md`
- **Available Hooks**: `.claude/hooks/README.md`
- **Available Skills**: `.claude/skills/README.md`
- **Slash Commands**: `.claude/commands/README.md`

---

**Last updated**: 2025-11-24
**Maintained by**: claude-code-optimizer
**Status**: 7/7 agents created and translated to English ✅
