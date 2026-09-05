#!/usr/bin/env bash
# Simulated Maven reactor build — demo stage for alexmskills recordings.
#
# Prints a realistic multi-module `mvn clean install` transcript. If
# PROGRESS_CLI is set (the command that invokes progress-channel's
# progress.py), the run registers itself as 'maven build' on the progress
# channel and steps once per reactor module. Without it, plain script.
#
#   DELAY=1.5 ./workloads/maven-build.sh     # ~1.5s per build phase
set -euo pipefail

DELAY=${DELAY:-0.4}
MODULES=(parent core model persistence api service web dist)
VERSION="1.4.0-SNAPSHOT"

T=""
if [ -n "${PROGRESS_CLI:-}" ]; then
  T=$($PROGRESS_CLI start --name 'maven build' --total "${#MODULES[@]}")
  trap '[ -n "$T" ] && $PROGRESS_CLI finish "$T" --fail "reactor aborted"' ERR
fi

echo "[INFO] Scanning for projects..."
echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Reactor Build Order:"
for m in "${MODULES[@]}"; do
  printf '[INFO]   acme-%s\n' "$m"
done

for m in "${MODULES[@]}"; do
  echo "[INFO] ------------------------------------------------------------------------"
  printf '[INFO] Building acme-%s %s\n' "$m" "$VERSION"
  sleep "$DELAY"
  printf '[INFO] --- maven-compiler-plugin:3.13.0:compile (default-compile) @ acme-%s ---\n' "$m"
  sleep "$DELAY"
  printf '[INFO] --- maven-surefire-plugin:3.2.5:test (default-test) @ acme-%s ---\n' "$m"
  ntests=$(( ( ${#m} * 7 ) % 40 + 12 ))
  printf '[INFO] Tests run: %d, Failures: 0, Errors: 0, Skipped: 0\n' "$ntests"
  sleep "$DELAY"
  printf '[INFO] --- maven-jar-plugin:3.4.1:jar (default-jar) @ acme-%s ---\n' "$m"
  if [ -n "$T" ]; then
    $PROGRESS_CLI step "$T" --count ok=1 --detail "acme-$m" || true
  fi
done

echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] BUILD SUCCESS"
echo "[INFO] ------------------------------------------------------------------------"
printf '[INFO] Total modules: %d\n' "${#MODULES[@]}"

if [ -n "$T" ]; then
  $PROGRESS_CLI finish "$T"
fi
