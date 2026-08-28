# skillsample

The **demo stage** for [alexmskills](https://github.com/alexmond/alexmskills) — a tiny,
deliberately boring project that the marketplace's demo recordings (VHS tapes) run
against. Nothing in here is a skill; it exists so demos have something real to chew on
and stay reproducible.

## What's here

| Path | Purpose |
|---|---|
| `workloads/import-photos.sh` | A simulated batch workload (N items, steady rate). With `PROGRESS_CLI` set it registers itself on the [progress-channel](https://github.com/alexmond/alexmskills/tree/main/plugins/progress-channel) via the shell `start`/`step`/`finish` trio — the star of the marketplace's root demo GIF. |
| `workloads/transcode-clips.sh` | A bursty-rate batch workload (every 4th item is slower) with categorical outcomes (`ok`/`skipped`/`failed`) — demos progress-channel's `--count` categories and a non-steady rate feeding the learned ETA. Picked by a live [brainstorm-panel](https://github.com/alexmond/alexmskills/tree/main/plugins/brainstorm-panel) run recorded in this repo, then built and tested by the same panel's session. |

## Using a workload with progress-channel

```bash
export PROGRESS_CLI="python3 /path/to/progress-channel/scripts/progress.py"
./workloads/import-photos.sh &          # registers as 'photo import' on the channel
$PROGRESS_CLI watch                     # live TUI: progress bar, rate, learned ETA
```

Without `PROGRESS_CLI` the workloads run as plain scripts — no dependency on anything.

## Conventions

- Workloads are stdlib/bash only, deterministic in shape (`TOTAL` and `DELAY` env
  overrides), and safe to run anywhere.
- Recordings themselves (the `.tape` sources and rendered GIFs) live in
  [alexmskills](https://github.com/alexmond/alexmskills), next to what they demo —
  this repo is only the stage.
- Some demos record a **live Claude Code session running in this repo** (e.g. the
  brainstorm-panel demo). For those, `.claude/prompt-coach/config.json` disables the
  prompt-coach hook (`enabled: false`) so recordings show only the plugin being demoed,
  and `.gitignore` drops the mutable state skills write (roles registry, panel log)
  so every take starts from the same clean stage.

## License

[MIT](LICENSE) © Alex Mondshain
