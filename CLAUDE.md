# skillsample

The demo stage for [alexmskills](https://github.com/alexmond/alexmskills) recordings.
Sessions in this repo are often being **recorded with VHS** (scripted keystrokes, no
human at the keyboard), so interaction has to stay drivable from a script.

## Recording etiquette

- Present any choice you'd normally offer interactively — a panel roster, an option
  list — as **plain text in the response**, and wait for a typed reply (e.g. "go").
  Never use an interactive selection dialog; scripted keystrokes can't drive one.
- Keep runs short: small teams, one round, terse output. The recording is the
  deliverable, not the artifact.

## Panel roles

- Keep panels small by default (3 seats) — recordings need short runs.
- In this repo, "brainstorm" always means the **brainstorm-panel** plugin skill —
  never any other brainstorming skill that may be installed.
- **Don't persist panel state here** (roles registry, panel log): `.claude/` state is
  gitignored and reset before every take, so writes would be lost anyway — and the
  write prompts stall recordings. Report learnings in the response instead.
