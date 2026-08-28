#!/usr/bin/env bash
# Simulated clip-transcode workload — demo stage for alexmskills recordings.
#
# Unlike import-photos.sh's steady rate and single ok=1 counter, this demos
# a bursty rate (every 4th item is slow, like a bigger clip) and categorical
# outcomes (ok / skipped / failed) via progress-channel's --count.
#
# If PROGRESS_CLI is set (the command that invokes progress-channel's
# progress.py, e.g. "python3 /path/to/progress.py"), the run registers itself
# on the progress channel via the shell start/step/finish trio. Without it,
# this is a plain script with no dependencies.
#
#   TOTAL=40 DELAY=0.12 ./workloads/transcode-clips.sh
set -euo pipefail

TOTAL=${TOTAL:-40}
DELAY=${DELAY:-0.12}   # base unit; every 4th item sleeps 4x this

T=""
if [ -n "${PROGRESS_CLI:-}" ]; then
  T=$($PROGRESS_CLI start --name 'clip transcode' --total "$TOTAL")
  trap '[ -n "$T" ] && $PROGRESS_CLI finish "$T" --fail "aborted at item $i"' ERR
fi

ok=0; skipped=0; failed=0
for i in $(seq 1 "$TOTAL"); do
  file=$(printf 'clip_%03d.mp4' "$i")

  if (( i % 17 == 0 )); then
    cat=failed; note='corrupt frame'
  elif (( i % 11 == 0 )); then
    cat=skipped; note='already transcoded'
  else
    cat=ok; note=''
  fi

  if (( i % 4 == 0 )); then
    d=$(awk -v b="$DELAY" 'BEGIN{printf "%.3f", b*4}')
  else
    d="$DELAY"
  fi

  if [ -n "$note" ]; then
    printf 'transcoding %s... %s (%s)\n' "$file" "$cat" "$note"
  else
    printf 'transcoding %s... %s\n' "$file" "$cat"
  fi
  sleep "$d"

  case "$cat" in
    ok) ok=$((ok+1)) ;;
    skipped) skipped=$((skipped+1)) ;;
    failed) failed=$((failed+1)) ;;
  esac

  if [ -n "$T" ]; then
    $PROGRESS_CLI step "$T" --count "$cat"=1 --detail "$file" || true
  fi
done

if [ -n "$T" ]; then
  $PROGRESS_CLI finish "$T"
fi
echo "transcoded $TOTAL clips ($ok ok, $skipped skipped, $failed failed)"
