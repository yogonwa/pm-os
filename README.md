# PM-OS — Product Manager Operating System for Claude Code

> *The first Claude Code workflow built from product management process, not developer workflow.*

---

## The problem with vibe coding at scale

Vibe coding works great for session one.

You describe what you want. Claude builds something. You feel like a wizard. Then you come back the next day and Claude has no idea what you built, why you made certain decisions, or what the plan was. You describe it again. Something slightly different gets built. Slowly, the codebase drifts from your intent. Features contradict each other. Code that was clean becomes a patchwork. You spend more time re-explaining than building.

This is called context rot — and every Claude Code workflow in existence is trying to solve it.

Most of them solve it from a *developer* perspective. They focus on TDD, git worktrees, subagent orchestration, atomic commits. Excellent tools. Built by developers, for developers.

But if you're a product manager, the problem starts earlier and runs deeper than that.

**The real context rot is losing the *why*.**

Why does this feature exist? What problem does it solve and for whom? What did we decide *not* to build, and why? What are the measures of success? What architectural decisions were made in the last initiative that this one depends on?

Developers can live without that context and still write good code. A PM-led workflow cannot. When Claude doesn't have the why, it optimizes locally — solving the immediate task correctly while undermining the broader intent.

PM-OS solves context rot at the product layer, not just the code layer.

---

## What PM-OS is

PM-OS is a Claude Code workflow system built around the same gates that professional product teams use to ship software — **discovery, kickoff, build, and rollout** — adapted for a world where Claude is your tech lead and dev team.

It's a GitHub template repo you clone to start a new project, and a shell script you run to add it to an existing one. One setup. Persistent methodology. Every initiative, every session, every context switch — the process is already there.

It is **not** another task runner. It is not a spec generator. It is not a wrapper around Claude Code commands.

It is an *operating system* for how a product manager runs a software project with AI as the team.

---

## The philosophy

**Good PM process survives AI.** Discovery, problem framing, intent, constraints, measures of success, phased delivery — these are not bureaucratic artifacts. They are the things that prevent you from building the wrong thing correctly. Claude makes building fast. PM-OS makes sure you're building the right thing.

**Documents are the team.** In a human team, context lives in people's heads and is transmitted through meetings, Slack, and institutional memory. When Claude is your team, context must live in documents — and those documents must be structured well enough that Claude can pick them up cold and continue without losing fidelity. PM-OS is a document system as much as a command system.

**Human review at the gates.** PM-OS is designed so a human — you, or eventually a real TL or DL — reviews and approves at each gate before execution begins. The kickoff produces artifacts a human can read and mark up. The plan is readable before Claude runs it. The ADR after shipping is legible to anyone who joins later. AI executes. Humans decide.

**Carry the past forward.** Every initiative produces an Architecture Decision Record — a short document capturing what was built, what was decided, and what the next initiative needs to know. PM-OS loads relevant ADRs automatically when a new initiative starts. Your project accumulates institutional memory instead of losing it.

**YAGNI, DRY, and TDD are non-negotiable.** The execution layer enforces test-driven development, avoids premature abstraction, and keeps code DRY. These are not suggestions. Claude is prone to over-engineering and gold-plating when left unsupervised. PM-OS has hooks and skills that enforce discipline at the code level so you don't have to.

**Progressive disclosure over kitchen-sink context.** CLAUDE.md tells Claude where to find information, not everything it could possibly know. Skills are loaded on demand. Subagent contexts are isolated. The main session stays fast and focused.

**Tell Claude when to stop.** Every brief includes explicit escalation conditions — the situations where Claude should surface a question rather than assume an answer and press forward. Without these, Claude always assumes forward. Confident, fast, and sometimes completely wrong. Escalation conditions are not a sign of weak intent. They are a sign of honest intent.

**The system gets smarter after every initiative.** When Claude makes a wrong assumption or repeats a mistake, PM-OS has a structured retro process that diagnoses *where* the failure came from — a gap in the brief, a missing skill, something that should have been a hook — and fixes the narrowest artifact that prevents it next time. Lessons accumulate in the right places. CLAUDE.md stays lean. The system compounds.

---

## The workflow

PM-OS maps five gates to Claude Code primitives:

### Gate 1 — Discovery → Initiative Brief

You describe what you want to build. PM-OS's `/pm:new-initiative` command runs a structured conversation that extracts: the problem being solved, who it's for, why now, constraints and non-goals, measures of success, rough phases, and any GTM considerations.

Two fields most systems miss are required here. **Tradeoffs** — decisions already made, stated explicitly so Claude doesn't relitigate them during implementation. "Postgres over SQLite. No auth in v1. Ship fast over ship perfect." And **escalation conditions** — the specific situations where Claude must stop and surface a question rather than assume an answer. "If the data model needs a new table, stop. If this touches the payment flow, stop."

The output is `brief.md` — a one-page product brief that lives in the repo and is the north star for every subsequent session. Claude cannot start planning until the brief exists and you've approved it.

This is the step every vibe coding system skips. It's the most important step.

### Gate 2 — Kickoff → Spec + Design Context

PM-OS runs two specialist agents in parallel:

The **Architect agent** reads the brief, surveys the existing codebase, and produces `spec.md` — an RFC-style document covering system design choices, technology decisions, API contracts, and what will and won't change architecturally. It also reads relevant ADRs from prior initiatives, so it's not designing in a vacuum.

The **Designer agent** reads the brief and any mocks or wireframes you've provided, and produces `design-context.md` — a document capturing layout decisions, interaction patterns, component choices, and UX intent that the implementation must honor.

You review both. You mark up what's wrong. Claude revises. When you approve, execution begins. Not before.

This is your trio kickoff, encoded in a repeatable process.

### Gate 3 — Build → Plan + Tasks

Claude proposes an implementation plan in `plan.md`. You review it. When you approve, Claude breaks it into `tasks.md` — a running checklist that is updated after every session so the next session can pick up exactly where this one left off.

Each session starts by reading: `brief.md`, `spec.md`, `design-context.md`, and the current state of `tasks.md`. Claude never starts from scratch. It starts from context.

The execution layer runs TDD, enforces YAGNI and DRY, and commits atomically. Hooks block the session from ending if tests are red. A pre-commit hook runs types, linting, and tests deterministically — Claude doesn't do style enforcement, linters do.

### Gate 4 — Checkpoint → Session Handoff

`/pm:checkpoint` is run at the end of each session. It updates `tasks.md`, writes a short session summary capturing what was decided and what's next, and notes any open questions. The next session starts by reading the checkpoint, not by you re-explaining where you left off.

This is the standup, encoded as a document.

### Gate 5 — Done → ADR + Next Initiative

When an initiative ships, `/pm:done` triggers the Reviewer agent for a final code review, generates a PR description, validates the task checklist is complete, and produces `adr.md` — the Architecture Decision Record.

The ADR is short: what was built, what key decisions were made, what tradeoffs were accepted, and what the next initiative needs to know. It's filed in a flat index that `/pm:next-initiative` can load from.

When you start the next initiative, PM-OS reads the relevant ADRs and surfaces them before the brief conversation starts. Your project accumulates memory. Initiative 5 knows what Initiative 2 decided.

### Gate 6 — Retro → System Improvement

`/pm:retro` runs a structured after-action review. It surfaces what went wrong, what assumptions Claude made, and what had to be corrected. Then it asks one diagnostic question per issue: where should this have been caught?

The triage ladder is strict. A one-off mistake unlikely to recur goes into the session ADR — nothing else. A recurring pattern within an initiative updates a specific skill file. A structural assumption Claude had to guess at means the brief template needs a new field. Something deterministic that should have been blocked means a new hook. Only a universal project truth that can't live anywhere more specific goes into CLAUDE.md — and only as a pointer to a skill, never as inline instruction.

CLAUDE.md has a hard ceiling of 150 lines. The retro command reports the current count. If a proposed fix would push it over, the command rejects the fix and asks for a narrower home. This keeps the system honest about its own complexity.

The retro also writes a `lessons.md` entry — a flat running log of what was learned, what was changed, and which artifact received the fix. Over time this log tells you which parts of your process are producing the most friction, and where the system is getting reliably better.

---

## What PM-OS is not trying to do

PM-OS is not trying to replace GSD, Superpowers, or Nelson. These are excellent tools. PM-OS borrows from all of them — the TDD skill from Superpowers, the risk tier framework from Nelson, the context engineering patterns from GSD — and adds the PM layer above them.

PM-OS is not for people who want to go fast and break things. If you want zero process and maximum speed for a throwaway prototype, use GSD's quick mode and skip this entirely.

PM-OS is for people who have shipped real products with real teams and want to bring that discipline to solo AI-driven development — because they know what happens when you don't.

---

## Who this is for

**Product managers who vibe code.** You understand discovery, briefs, kickoffs, sprint ceremonies, UAT, and rollout. You've always been limited by your ability to execute technically. PM-OS is the translation layer between what you know and what Claude can do.

**PMs who manage AI-assisted teams.** As Claude Code becomes part of real engineering teams, the PM role shifts toward providing Claude with the same structured inputs you'd give a human team — plus reviewing Claude's outputs at the same gates you'd review a human's. PM-OS makes that workflow explicit.

**Developers who want PM discipline.** If you've built things that solved the wrong problem, or shipped features nobody used, or made architectural decisions you couldn't explain six months later — the PM gates exist for you too.

---

## Repository structure

```
pm-os/                          ← GitHub template repo (new projects)
│
├── .claude/
│   ├── CLAUDE.md               ← Progressive disclosure: tells Claude where to find things
│   ├── settings.json           ← Permissions, model profiles, hooks config
│   ├── agents/
│   │   ├── architect.md        ← System design review, RFC generation
│   │   ├── designer.md         ← Reads mocks, produces design-context.md
│   │   ├── reviewer.md         ← Code review with risk tier awareness
│   │   └── pm.md               ← Brief extraction, initiative scoping
│   ├── commands/
│   │   ├── pm-new-initiative.md    ← Discovery conversation → brief.md
│   │   ├── pm-kickoff.md           ← Runs architect + designer agents
│   │   ├── pm-start-feature.md     ← Loads brief, creates plan + tasks
│   │   ├── pm-checkpoint.md        ← End-of-session handoff
│   │   ├── pm-done.md              ← Review, PR, ADR creation
│   │   ├── pm-retro.md             ← After-action review, system improvement
│   │   ├── pm-next-initiative.md   ← Load ADRs, start new brief
│   │   └── pm-status.md            ← Dashboard: all initiatives, current state
│   ├── hooks/
│   │   ├── pre-commit              ← Types + tests + lint, blocks on red
│   │   └── post-session            ← Prompts checkpoint if tasks.md is stale
│   └── skills/
│       ├── tdd.md                  ← RED-GREEN-REFACTOR enforcement
│       ├── yagni-dry.md            ← Complexity reduction guardrails
│       └── risk-tiers.md           ← Station 0-3 controls for irreversible actions
│
├── .pm/                        ← PM artifact layer (committed to git)
│   ├── initiatives/
│   │   └── [slug]/
│   │       ├── brief.md            ← Problem, why, constraints, success metrics
│   │       ├── spec.md             ← RFC from architect agent
│   │       ├── design-context.md   ← UX/UI intent from designer agent
│   │       ├── plan.md             ← Implementation plan, human-approved
│   │       ├── tasks.md            ← Running checklist, updated each session
│   │       └── adr.md              ← Post-ship decisions and carry-forwards
│   ├── adrs/                   ← Flat index for cross-initiative loading
│   ├── lessons.md              ← Running log of retro findings and artifact fixes
│   └── state.md                ← Current initiative, last session, open blockers
│
├── install.sh                  ← Shell script for adding to existing repos
├── README.md                   ← This file
└── PHILOSOPHY.md               ← Deeper treatment of the design decisions
```

---

## Installation

### New project (GitHub template)

1. Click **"Use this template"** on the PM-OS GitHub repo
2. Clone your new repo
3. Run `claude` in the project root
4. Type `/pm:new-initiative` to start

### Existing project (shell script)

```bash
curl -sSL https://raw.githubusercontent.com/[your-handle]/pm-os/main/install.sh | bash
```

The script copies the `.claude/` structure and `.pm/` scaffold into your project without touching your existing code or git history. It will not overwrite an existing `CLAUDE.md` — it will ask you to merge manually.

---

## Relation to the broader ecosystem

PM-OS stands on the shoulders of excellent prior work:

- **Superpowers** (obra) — TDD skill and subagent execution patterns. If you want a developer-first workflow that pairs with PM-OS's execution layer, install Superpowers alongside it.
- **GSD** (gsd-build) — The context engineering discipline, XML-structured plans, and the insight that fresh subagent contexts beat bloated main sessions.
- **Nelson** (harrymunro) — The risk tier system (Station 0-3) for classifying tasks by blast radius, and the Admiral/Captain coordination hierarchy.
- **Randall Bennett** ([Build less, ship more](https://randallb.com/p/build-less-ship-more-the-three-pillars)) — Two specific ideas: the *escalation conditions* field in the brief (when Claude must stop and ask rather than assume forward), and the *initiative assessment* structure in the retro (was autonomous Claude action inside or outside intent?). PM-OS doesn't adopt his full framework — the military framing is his, not ours — but these two contributions sharpen the brief and the retro in ways nothing else in the ecosystem does.

The PM layer — brief, kickoff, trio artifacts, cross-initiative ADRs, and the retro loop — is what PM-OS adds.

---

## Roadmap

**Milestone 1 — Scaffold + CLAUDE.md** *(current)*
Folder structure, progressive-disclosure CLAUDE.md, settings template, three core agents (architect, reviewer, pm). The skeleton everything hangs on.

**Milestone 2 — PM Command Chain**
`/pm:new-initiative`, `/pm:kickoff`, `/pm:start-feature`, `/pm:checkpoint`, `/pm:done`, `/pm:retro`. The full artifact chain including the feedback loop. Tested against a real initiative.

**Milestone 3 — Multi-Initiative Memory**
`/pm:next-initiative`, `/pm:status`, ADR flat index, cross-initiative context loading. The portfolio OS layer.

**Milestone 4 — Team Mode**
Human-review checkpoints. Formatted outputs for TL and DL handoff. Reviewer agent output designed to be read in a PR, not just by Claude.

---

## The blog post version of this

*"I've spent my career running product teams — writing PRDs, running kickoffs with tech leads and designers, managing sprints, shipping features. When Claude Code arrived I tried to just vibe code my way through projects. It was chaos — fast at first, then increasingly broken and impossible to pick up between sessions.*

*I realized the problem wasn't Claude. The problem was that I'd abandoned the process I knew worked and expected Claude to compensate. So I encoded my process into a Claude Code system. This is that system.*

*If you're a PM who wants to vibe code with discipline — or a developer who wants to understand why PM process exists and how to apply it to AI-driven development — PM-OS is built for you."*

---

## Contributing

PM-OS is early. The philosophy is settled. The implementation is evolving.

If you're a PM who builds with Claude Code, your feedback on the workflow gates and document formats is the most valuable thing you can contribute. Open an issue with your experience — what the brief conversation missed, what the ADR didn't capture, what gate felt unnecessary.

If you're a developer who wants to contribute tooling, the install script and the hooks are the highest-leverage areas.

PRs that add complexity without clear necessity will be declined. YAGNI applies to the system itself.

---

## License

MIT. Build with it, fork it, extend it, share it.

---

*PM-OS is built by a product manager, for product managers. It assumes you know how to run a product process. It just gives Claude Code the structure to participate in one.*
