# Getting Started with PM-OS

This guide gets you from zero to your first initiative in four steps.
Total setup time: about 20 minutes.

If you've never used Claude Code before, start at Step 0.
If Claude Code is already installed, skip to Step 1.

---

## Step 0 — Install Claude Code

Claude Code is Anthropic's command-line tool. It runs in your terminal
and connects directly to your project files.

**Install:**
```bash
npm install -g @anthropic/claude-code
```

**Authenticate:**
```bash
claude
```

This opens a browser window to connect your Anthropic account.
You need a Claude Pro or Max subscription, or API access.

**Verify it works:**
```bash
claude --version
```

If you see a version number, you're ready. If not, check
[Claude Code's official docs](https://docs.anthropic.com/en/docs/claude-code)
for troubleshooting.

> **First time in a terminal?** Claude Code runs in Terminal (Mac),
> Command Prompt or PowerShell (Windows), or any terminal app you prefer.
> Navigate to a folder with `cd ~/projects/my-project` and run `claude` there.

---

## Step 1 — Set up your global preferences

Your global CLAUDE.md is a file that travels with you across every project.
It tells Claude who you are, how you like to work, and your personal defaults.
You only do this once.

**Create the file:**
```bash
mkdir -p ~/.claude
curl -sSL https://raw.githubusercontent.com/[your-handle]/pm-os/main/templates/global-CLAUDE.md \
  -o ~/.claude/CLAUDE.md
```

**Edit it:**
```bash
open ~/.claude/CLAUDE.md
```

Work through each section. The comments explain what goes where.
The whole thing should take about 10 minutes.

**What you're filling in:**
- Who you are and your background (one sentence)
- Communication style — pick Option A, B, or C
- Autonomy level — pick Option A, B, or C
- Your projects list (you can add more later)
- Your global always/never rules

**When you're done,** delete the placeholder text and comment blocks
you don't need. Aim for under 60 lines of actual content.

---

## Step 2 — Start a new project with PM-OS

**Option A: Brand new project**

Click **"Use this template"** on the PM-OS GitHub repo,
give it a name, then clone it locally:

```bash
git clone https://github.com/[your-username]/[your-project-name].git
cd [your-project-name]
```

**Option B: Add PM-OS to an existing project**

Navigate to your existing project and run the install script:

```bash
cd ~/projects/your-existing-project
curl -sSL https://raw.githubusercontent.com/[your-handle]/pm-os/main/install.sh | bash
```

The script adds the `.claude/` and `.pm/` folders without touching
your existing code or git history. If you already have a `CLAUDE.md`,
it will ask you to merge manually rather than overwrite.

---

## Step 3 — Fill in your project CLAUDE.md

Every project has its own `CLAUDE.md` in the project root. This is
separate from your global file — it's project-specific context
that Claude needs every session.

Open it:
```bash
open CLAUDE.md
```

Fill in three things:

**What this project is** — one or two sentences. What does it do
and who is it for? This is the why. Write it like you're explaining
to a new team member in 30 seconds.

**Tech stack** — language, runtime, framework, database, testing tool.
One line each. Only what Claude needs to make technology decisions.

**How to verify work** — the exact commands to run tests, typecheck,
and lint. Claude runs these before marking any task complete.

**Then add two or three non-negotiables** — rules that are true in
every session for this project without exception. The template has
examples to guide you.

Leave the PM-OS system section as-is. It's already wired up to point
Claude at your `.pm/` folder and the PM-OS commands.

---

## Step 4 — Start your first initiative

Launch Claude Code in your project:

```bash
cd ~/projects/your-project
claude
```

Then type:

```
/pm:new-initiative
```

Claude will walk you through a structured conversation to capture:

- The problem you're solving and who it's for
- Why now — what's driving this initiative
- Success conditions — what done looks like
- Constraints and explicit non-goals
- Tradeoffs already decided
- Escalation conditions — when Claude should stop and ask
- Rough phases

At the end, Claude writes your `brief.md` and shows it to you for
approval. Read every word. Change anything that doesn't sound right.
When you approve it, you're ready to run:

```
/pm:kickoff
```

This launches the Architect agent to review the brief and produce
a system design spec, and the Designer agent if you have mocks to
share. You review both outputs. When approved, you move into planning.

---

## The full command sequence

Once set up, here's the flow for every initiative:

```
/pm:new-initiative    → write and approve the brief
/pm:kickoff           → architect + designer agents produce spec and design context
/pm:start-feature     → Claude proposes plan.md, you approve, tasks.md is created
                        → Claude builds, session by session
/pm:checkpoint        → end of session: updates tasks.md, writes session summary
/pm:done              → final review, PR description, ADR written
/pm:retro             → after-action review, system improvement

/pm:status            → dashboard: all initiatives and current state
/pm:next-initiative   → start the next one with ADR context loaded
```

You don't need to memorize these. Type `/pm:` at any time in a
Claude Code session to see the available commands.

---

## Resuming work after a break

Context doesn't carry between sessions. Every time you start a new
session, Claude starts fresh. This is by design — it prevents
accumulated noise from degrading quality.

The PM-OS system handles this for you. When resuming, just run:

```bash
cd ~/projects/your-project
claude
```

Then say:

```
Resume work on [initiative-name]. Read .pm/state.md and 
tasks.md before we start.
```

Claude reads the state file and picks up exactly where you left off,
without you re-explaining the context.

---

## A note on working style

PM-OS works best when you treat the brief seriously.

The most common failure mode in AI-assisted development isn't
a bad model or a buggy tool — it's an underspecified intent.
When Claude doesn't know the why, the success conditions, and
the constraints, it fills those gaps with assumptions. Sometimes
the assumptions are right. Often they aren't, and you don't find
out until you're three sessions in.

The 10-15 minutes you spend writing a good brief is the highest-
leverage time you'll spend on any initiative. Everything downstream
— the spec, the plan, the tasks, the code — derives from it.

If you're tempted to skip the brief and just start building,
that's the moment to slow down, not speed up.

---

## Getting help

**Something isn't working:** Open an issue at [github.com/your-handle/pm-os]

**Want to understand the system more deeply:** Read `README.md`
for the full philosophy and workflow, or `PHILOSOPHY.md` for the
deeper treatment of why the system is designed the way it is.

**Want to contribute your own patterns:** The brief template and
retro triage ladder are the best places to start.
See `CONTRIBUTING.md`.
