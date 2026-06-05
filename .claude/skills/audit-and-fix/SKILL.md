---
name: audit-and-fix
description: Structured audit-then-remediate workflow: investigate read-only, write findings to a research file, then apply fixes via cost-routed subagents. Use when the user asks to analyse / audit / review something and (potentially) fix the issues found. Enforces human-approval gates before editing and before committing.
---

# Audit and Fix

A repeatable workflow for "analyse X, tell me what's wrong, and fix it." It
separates investigation from change, routes each kind of work to the
cheapest model that can do it well, and stops for the user's approval at three
fixed points.

## When to use

- "Analyse / audit / review my <config|module|codebase> and fix the issues."
- Any task that is *investigation first, changes second*, where the changes
  depend on what the investigation turns up.

Do **not** use for: a single known edit, a pure question with no remediation, or
work where the user has already decided exactly what to change.

## Core principles

- **Investigation is read-only.** No edits, no setup changes, no commits until
  Gate 1 is passed.
- **The research file is the deliverable of the analysis**, not the chat
  message. Write it before you summarise (see CLAUDE.md "Research & findings").
- **Right model for the job** (see cheatsheet below): keep reasoning on the
  strong model, push mechanical work down to the cheapest model that can do it.
- **Verify conclusions yourself.** Subagent summaries are leads, not proof — for
  any nuanced finding (a conflict, a clobbered option, a subtle bug) read the
  actual `file:line` before asserting it.
- **The user drives scope and decisions.** Never expand scope or pick between
  user-facing options unilaterally.

## Workflow

### Phase 1 — Investigate (read-only, fan-out)

1. Frame the questions the audit must answer (the user's explicit asks plus the
   obvious adjacent ones — e.g. misconfig, overlap/conflict, redundancy).
2. Fan out **read-only Explore subagents in parallel (max 3)** to map structure
   and gather the relevant config/code. Give each a distinct focus. Use 1 agent
   if the scope is small/known.
3. Pull the critical files into the main context and read them yourself to
   confirm anything you intend to report as a finding.

### Phase 2 — Write findings → research file

Write to `.claude/research/yyyy-mm-dd-title.md`. Structure it so each finding has:
**what**, **where** (`file:line`), **why it matters**, and a **proposed fix**.
Group by severity (real bugs / redundant / overlaps-conflicts / opportunities).
Include any "leave as-is, intentional" notes so the user knows you considered
them. End with a suggested order of work.

### 🛑 GATE 1 — Scope sign-off (REQUIRED, before any change)

Summarise the findings in chat, link the research file, then use
**AskUserQuestion** to settle:
- report-only vs. apply fixes,
- which findings to action,
- appetite for any larger refactors / migrations surfaced.

Make **no edits** until this is answered.

### Phase 3 — Resolve decisions

Turn each approved fix into an exact change. Where a fix involves a genuine
**judgement call the user owns** — a keybinding, a config value, a name, a
trade-off between options — do not guess.

### 🛑 GATE 2 — Decision sign-off (REQUIRED if any such choices exist)

Batch every open choice into a single **AskUserQuestion** (recommended option
first, labelled). Only skip this gate if the approved fixes are purely
mechanical with no user-facing choice.

### Phase 4 — Apply fixes (delegated, lightest model)

1. Convert the approved, decided fixes into **exact, unambiguous edit specs**
   (precise `old → new` strings, or full file contents) — the spec must carry
   all the judgement so the executor needs none.
2. Delegate execution to **one** general-purpose subagent. Batch fixes that
   share files/context under that single agent — do not spawn an agent per file.
3. Pick the model per the cheatsheet below: Haiku for fully-specified mechanical
   edits; keep anything still needing reasoning on the main agent or a Sonnet
   subagent.

### Phase 5 — Verify

- Run the project's formatter / linter / syntax check (for this repo: `stylua .`
  from the nvim config dir; syntax-check Lua where useful).
- **Revert incidental out-of-scope changes** (e.g. a formatter touching files
  you didn't intend to change) so the diff stays scoped to the task.
- Review the diff yourself and confirm each hunk matches the intended fix.

### 🛑 GATE 3 — Commit sign-off (REQUIRED)

Report what changed (concise per-fix summary + `git diff --stat`). **Do not
commit unless the user asks.** Offer to commit on a branch; let the user review
and commit.

## Model selection cheatsheet

| Work | Who | Model | Why |
|---|---|---|---|
| Orchestration, analysis, framing the fixes, judgement | main agent (this session) | strong (Opus / session default) | needs reasoning and holds the running context |
| Broad read-only search / codebase mapping | Explore subagents, ≤3 in parallel | Sonnet (or inherit) | cheap, good synthesis, cannot edit |
| Mechanical, fully-specified edits | one general-purpose subagent | Haiku | cheapest; the spec removes the need to reason |
| An edit needing judgement a spec can't capture | main agent, or a Sonnet subagent | Sonnet+ | correctness over cost for the ambiguous bit |
