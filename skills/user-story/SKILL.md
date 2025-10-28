---
name: user-story
description: Create structured user story with acceptance criteria and business rules. Use when defining features, requirements, or business functionality from user perspective.
allowed-tools: Read, Write, Edit, Grep, Glob
---

# User Story - SmartLockers Client Manager

Create well-structured user stories following agile best practices and SmartLockers project standards.

## Instructions

This skill helps you transform business requirements into actionable user stories with clear acceptance criteria.

### What to do:

1. **Identify the user** and their need:
   - Who is the user? (role/persona)
   - What do they want to do?
   - Why do they need this?

2. **Define acceptance criteria** using Given/When/Then format

3. **Document business rules** and constraints

4. **Consider technical implications** (but focus on WHAT, not HOW)

## User Story Template

```markdown
# User Story: [Feature Name]

## Story

**As a** [user role/persona]
**I want** [functionality/capability]
**So that** [business value/benefit]

### Example:
**As a** parking facility manager
**I want** to automatically assign lockers based on vehicle reservations
**So that** I can reduce manual work and avoid allocation errors

## Background

**Current Situation:**
[Describe the current state, problem being solved, or opportunity]

**Business Context:**
[Why this is important, business impact, stakeholder needs]

**User Pain Points:**
[What frustrations or inefficiencies exist today]

## Acceptance Criteria

### Main Scenario

**Given** [initial context/state]
**When** [action performed by user]
**Then** [expected outcome/result]

**Example:**
**Given** a vehicle reservation exists in MSExchange
**When** the reservation date arrives
**Then** a locker is automatically allocated and an access code is sent to the driver

### Additional Scenarios

1. **Alternative path:**
   - **Given** [context]
   - **When** [action]
   - **Then** [outcome]

2. **Error scenario:**
   - **Given** [error condition]
   - **When** [action attempted]
   - **Then** [error handling/message]

3. **Edge case:**
   - **Given** [edge condition]
   - **When** [action]
   - **Then** [expected behavior]

## Business Rules

Define the non-negotiable rules that govern this feature:

1. **Rule 1:** [Business rule description]
   - Rationale: [Why this rule exists]
   - Impact: [What happens if violated]

2. **Rule 2:** [Business rule description]
   - Rationale: [Why this rule exists]
   - Impact: [What happens if violated]

**Example:**
1. **Locker allocation must respect reservation time windows**
   - Rationale: Prevent double-booking and ensure availability
   - Impact: System rejects allocations outside time window

2. **Access codes expire 24 hours after reservation end**
   - Rationale: Security and locker availability
   - Impact: Expired codes automatically deactivated

## UI/UX Requirements

**User Interface:**
- Screen/page: [Where this happens]
- Key interactions: [What user does]
- Visual feedback: [What user sees]

**Responsive Design:**
- [ ] Desktop
- [ ] Tablet
- [ ] Mobile

**Accessibility:**
- [ ] Keyboard navigation
- [ ] Screen reader compatible
- [ ] WCAG 2.1 AA compliant

**User Flow:**
```
[Entry point] → [Action 1] → [Action 2] → [Outcome]
```

## Technical Considerations

**APIs Required:**
- External: [Which external APIs: MSExchange, Pilotphone, Guesty, etc.]
- Internal: [Which SmartLockers Sync functions]

**Data Requirements:**
- Input data: [What data is needed]
- Output data: [What data is produced]
- Data validation: [What must be validated]

**Integration Points:**
- Systems involved: [List all systems]
- Data flows: [How data moves between systems]
- Dependencies: [What must exist first]

**Performance Requirements:**
- Response time: [Maximum acceptable latency]
- Throughput: [Number of operations per time unit]
- Scalability: [Expected growth/volume]

**Security Requirements:**
- Authentication: Bearer token required
- Authorization: [Who can do what]
- Data privacy: [What data is sensitive]

## SmartLockers Specific

**Client-Specific Rules:**
- Client: [Which client(s) this applies to]
- Custom logic: [Any client-specific transformations]
- Configuration: [Client-specific settings]

**Sync Functions:**
- [ ] `sync_create_user()`
- [ ] `sync_upsert_customer()`
- [ ] `sync_create_locker_allocation()`
- [ ] `sync_generate_access_code()`
- [ ] Other: [specify]

**Data Mappings:**
- Source system → SmartLockers
- Field transformations required
- Validation rules

## Definition of Done

### Feature Complete
- [ ] Feature works according to all acceptance criteria
- [ ] All scenarios tested (main + alternative + error paths)
- [ ] Business rules enforced in code
- [ ] Edge cases handled

### Quality Assurance
- [ ] Manual testing completed
- [ ] PHPStan niveau 6 passes (0 errors)
- [ ] Tests de contrat written (5-8 max)
- [ ] Tests d'intégration for critical flows (2-3 max)
- [ ] Performance meets requirements

### User Experience
- [ ] UI/UX approved by stakeholder
- [ ] Responsive design verified
- [ ] Accessibility requirements met
- [ ] User documentation created

### Documentation
- [ ] Architecture documentation updated
- [ ] API documentation complete
- [ ] PHPDoc comments in code
- [ ] User guide or help text added

### Stakeholder Acceptance
- [ ] Demo completed
- [ ] Feedback incorporated
- [ ] Sign-off received
- [ ] Ready for production

## Priority & Effort

**Business Value:**
- [ ] High - Critical for business operations
- [ ] Medium - Important but not critical
- [ ] Low - Nice to have

**User Impact:**
- [ ] High - Affects many users or core workflow
- [ ] Medium - Affects some users or secondary workflow
- [ ] Low - Affects few users or edge case

**Effort Estimate:**
- [ ] S (Small) - 1-2 days
- [ ] M (Medium) - 3-5 days
- [ ] L (Large) - 1-2 weeks
- [ ] XL (Extra Large) - 2+ weeks

**Risk Level:**
- [ ] High - Complex integration, many unknowns
- [ ] Medium - Some complexity, some unknowns
- [ ] Low - Straightforward, well-understood

**Dependencies:**
- Blocked by: [Other stories/tasks that must complete first]
- Blocks: [Other stories/tasks waiting on this]

## Non-Functional Requirements

**Reliability:**
- [ ] 99.9% uptime required
- [ ] Graceful degradation on API failures
- [ ] Cache-first pattern for resilience

**Maintainability:**
- [ ] Code follows project conventions
- [ ] Functions are small and focused
- [ ] No code duplication
- [ ] Clear error messages

**Scalability:**
- [ ] Handle X concurrent users
- [ ] Process Y items per minute
- [ ] Database queries optimized

**Monitoring:**
- [ ] Logging for key operations
- [ ] Error tracking
- [ ] Performance metrics

## Assumptions & Constraints

**Assumptions:**
- [What we're assuming is true]
- [What we expect to be available]

**Constraints:**
- Technical: [Technology limitations]
- Business: [Business policy constraints]
- Timeline: [Deadline or time constraints]
- Budget: [Cost constraints]

## Open Questions

**Technical Questions:**
- [ ] Question 1?
- [ ] Question 2?

**Business Questions:**
- [ ] Question 1?
- [ ] Question 2?

**Research Needed:**
- [ ] Topic 1
- [ ] Topic 2

## Related Items

**Related User Stories:**
- [Link to related story 1]
- [Link to related story 2]

**Related Documentation:**
- `documentation/fonctionnel/user-stories.md`
- `documentation/architecture/`
- `documentation/clients/[client].md`

**Related Tasks:**
- [Link to implementation task]
- [Link to testing task]
```

---

**Created:** [Date]
**Author:** [Name]
**Status:** [Draft/Ready/In Progress/Done]
**Sprint:** [Sprint number or name]
