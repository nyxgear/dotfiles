---
name: pr-review
description: >-
  Review pull requests for correctness, security, and maintainability.
  Use when the user asks to review a PR, examine code changes, or provide
  feedback on a pull request.
---

# PR Review

## Workflow

1. Understand the PR's purpose from the title, description, and linked issues.
2. Review the full diff -- look at ALL commits, not just the latest.
3. Assess each area in the checklist below.
4. Provide structured feedback.

## Review Checklist

### Correctness
- Does the logic match the stated intent?
- Are edge cases handled (nulls, empty collections, boundary values)?
- Are error paths handled gracefully?

### Security
- No secrets or credentials in code.
- User input is validated and sanitized.
- No SQL injection, XSS, or path traversal vectors.
- Auth checks are present where required.

### Design
- Changes are in the right layer/module.
- No unnecessary coupling introduced.
- Public API surface is minimal and intentional.

### Tests
- New behavior has corresponding tests.
- Edge cases are covered.
- Tests are deterministic (no flaky timing, no network calls).

### Operational
- Logging is adequate for debugging.
- No performance regressions (n+1 queries, unbounded loops).
- Database migrations are backward-compatible.

## Feedback Format

Categorize each piece of feedback:

- **blocker** -- Must fix before merge. Correctness or security issue.
- **suggestion** -- Worth improving. Design, readability, or minor issue.
- **nit** -- Optional. Style, naming, or minor preference.
- **question** -- Seeking clarification on intent or trade-off.

Structure feedback as:

```
### [blocker|suggestion|nit|question] Short title

File: `path/to/file.py` (lines X-Y)

Description of the issue and a concrete suggestion for fixing it.
```

## Guidelines

- Lead with what's good -- acknowledge solid work before diving into issues.
- Be specific -- point to exact lines, suggest concrete alternatives.
- Explain WHY something is a problem, not just that it is.
- Distinguish personal preference from objective issues.
- If the PR is large, summarize the overall assessment before detailed feedback.
