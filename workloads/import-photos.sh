#!/usr/bin/env bash
# Simulated photo-import workload — demo stage for alexmskills recordings.
#
# If PROGRESS_CLI is set (the command that invokes progress-channel's
# progress.py, e.g. "python3 /path/to/progress.py"), the run registers itself
# on the progress channel via the shell start/step/finish trio. Without it,
# this is a plain script with no dependencies.
#
#   TOTAL=60 DELAY=0.15 ./workloads/import-photos.sh
set -euo pipefail

TOTAL=${TOTAL:-60}
DELAY=${DELAY:-0.15}

T=""
if [ -n "${PROGRESS_CLI:-}" ]; then
  T=$($PROGRESS_CLI start --name 'photo import' --total "$TOTAL")
  trap '[ -n "$T" ] && $PROGRESS_CLI finish "$T" --fail "aborted at item $i"' ERR
fi

for i in $(seq 1 "$TOTAL"); do
  printf 'importing IMG_%04d.jpg\n' "$i"
  sleep "$DELAY"
  if [ -n "$T" ]; then
    $PROGRESS_CLI step "$T" --count ok=1 --detail "$(printf 'IMG_%04d.jpg' "$i")" || true
  fi
done

if [ -n "$T" ]; then
  $PROGRESS_CLI finish "$T"
fi
echo "imported $TOTAL photos"
