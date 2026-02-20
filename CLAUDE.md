# CLAUDE.md
# This file loads into every session. Keep it short, universal, and pointer-based.
# Target: under 80 lines of actual content. Comments (lines starting with #) 
# are stripped by Claude Code and don't count toward context.
# Run /pm:new-initiative to generate the first brief before editing this file.

---

## What this project is

<!-- FILL IN: One or two sentences. What does this product do and who is it for?
     This is the WHY. Write it as if explaining to a new team member in 30 seconds.
     
     Example: "A Claude Code workflow system for product managers. Gives PMs the 
     same structured process they use with human teams — discovery, kickoff, build, 
     retro — with Claude as the tech lead and dev team."
-->

[YOUR PROJECT PURPOSE HERE]

---

## Tech stack at a glance

<!-- FILL IN: The WHAT. Stack, language, key frameworks. One line each.
     Only include what Claude needs to make technology decisions.
     Don't include version numbers unless a specific version matters.
     
     Example:
     - Language: TypeScript
     - Runtime: Node.js (use `bun` not `node` for all commands)
     - Frontend: Next.js App Router
     - Database: Postgres via Prisma
     - Testing: Vitest
     - Styles: Tailwind CSS
-->

- Language:
- Runtime:
- Frontend:
- Backend:
- Database:
- Testing:
- Other:

---

## How to verify your work

<!-- FILL IN: The HOW. Exact commands Claude should run to check its work.
     These are the commands that matter every session.
     Don't include build/deploy — only test, typecheck, lint.
     
     Example:
     - Run tests:        `bun test`
     - Typecheck:        `bun tsc --noEmit`
     - Lint:             `bun lint` (auto-fixes, do not use --fix manually)
     - All checks:       `bun check` (runs the above in sequence)
-->

- Run tests:
- Typecheck:
- Lint:
- All checks:

---

## PM-OS system

This project uses PM-OS. The current initiative, task status, and session 
state are in `.pm/state.md`. Read this before starting any work.

For the full PM artifact system — briefs, specs, ADRs, lessons — 
see `.pm/CLAUDE.md` (loads when you access .pm/ files).

For PM commands, type `/pm:` in any session to see available commands.

---

## Non-negotiables

<!-- FILL IN: Two to five rules that are universally true for this project,
     in every session, with no exceptions. Be ruthlessly selective.
     If something only matters sometimes, it belongs in a skill or subdirectory 
     CLAUDE.md, not here.
     
     Correct examples (universal, imperative):
     - Never modify .env files directly. Use .env.example as the template.
     - Always run `bun check` before marking a task complete.
     - Database migrations require human approval before running.
     
     Wrong examples (not universal, belongs elsewhere):
     - Use Zod for form validation (belongs in a skill or feature brief)
     - Follow the API response format in docs/api.md (belongs in .claude/skills/ or @import)
     - Prefer functional components (belongs in subdirectory CLAUDE.md for /src)
-->

- Always read `.pm/state.md` at the start of a session before doing anything else.
- Run all checks before marking any task complete. Never skip on failing tests.
- If a task would exceed its defined scope in the brief, stop and surface the question.
- [ADD YOUR PROJECT-SPECIFIC RULE]
- [ADD YOUR PROJECT-SPECIFIC RULE]

---

## Key reference files

<!-- These load on demand when relevant. Claude reads them when it needs detail.
     Add or remove lines as your project grows. Keep descriptions one line.
-->

@.pm/state.md          — current initiative, session state, open blockers
@.pm/CLAUDE.md         — PM-OS document system guide (briefs, specs, ADRs)
@.claude/skills/       — execution skills (TDD, YAGNI, risk tiers)
