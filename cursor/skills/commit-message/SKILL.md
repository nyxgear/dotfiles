---
name: commit-message
description: >-
  Generate clear, conventional commit messages from staged changes. Use when
  the user asks to commit, write a commit message, or review staged changes
  for committing.
---

# Commit Message Generator

## Workflow

1. Run `git diff --cached` (and `git status`) to understand staged changes.
2. Classify the change type:
   - `feat` -- new feature or capability
   - `fix` -- bug fix
   - `refactor` -- restructuring without behavior change
   - `docs` -- documentation only
   - `test` -- adding or updating tests
   - `chore` -- tooling, deps, CI, config
   - `perf` -- performance improvement
   - `style` -- formatting, whitespace (no logic change)
3. Identify the scope (module, component, or area affected).
4. Write the message.

## Format

```
type(scope): short imperative summary (max 72 chars)

Optional body: explain WHY, not WHAT. The diff already shows what changed.
Reference relevant issue IDs if applicable.
```

## Examples

**Single file fix:**
```
fix(auth): prevent token refresh race condition

Two concurrent requests could both trigger a refresh, invalidating each
other's tokens. Add a mutex around the refresh flow.
```

**Multi-file feature:**
```
feat(api): add pagination to list endpoints

Support cursor-based pagination on /users and /orders.
Default page size is 50, max 200.
```

**Dependency update:**
```
chore(deps): upgrade pydantic to v2.7

Migrate deprecated validator decorators to field_validator.
```

## Guidelines

- Subject line is imperative mood ("add", not "added" or "adds").
- Don't end the subject line with a period.
- Body wraps at 72 characters.
- If the change is trivial (typo, formatting), a subject-only message is fine.
- Don't include file lists -- `git log --stat` already provides that.
