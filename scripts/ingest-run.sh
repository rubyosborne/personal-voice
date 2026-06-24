#!/usr/bin/env bash
# Drain inbox/ on the home Mac: pull, and if real samples are queued, run the
# voice skill's Job 4 (INGEST INBOX) headlessly to distill + commit + push.
# Safe to run on a schedule or by hand. Empty inbox => no-op, no Claude call.

set -euo pipefail

REPO="/Users/rubyosborne/ClaudeDisk/personal-voice"
cd "$REPO"

# Log everything (outside the repo, so it never dirties git).
LOG="$HOME/Library/Logs/voice-ingest.log"
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
echo "=== ingest run $(date -u +%FT%TZ) ==="

# Single-flight: refuse to overlap with another run.
LOCK="$REPO/.ingest.lock"
if ! mkdir "$LOCK" 2>/dev/null; then
  echo "another ingest is running; skipping"
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT

# Get current. Don't auto-merge a divergence — just skip and try next time.
if ! git pull --ff-only; then
  echo "git pull --ff-only failed (diverged?) — skipping this run"
  exit 0
fi

# Count real queued samples (everything under inbox/ except housekeeping files).
shopt -s nullglob
queued=()
for f in inbox/*.md; do
  base="$(basename "$f")"
  [ "$base" = "README.md" ] && continue
  queued+=("$f")
done
# .gitkeep has no .md extension so it's already excluded by the glob.

if [ ${#queued[@]} -eq 0 ]; then
  echo "inbox empty — nothing to ingest"
  exit 0
fi
echo "found ${#queued[@]} queued sample(s): ${queued[*]}"

# Hand off to the skill's Job 4 via headless Claude Code. Point Claude straight
# at the instructions so it doesn't depend on skill auto-invocation in -p mode.
claude -p "Read .claude/skills/voice/SKILL.md and carry out 'Job 4 — INGEST \
INBOX' exactly. Process every queued inbox/*.md file (ignore inbox/.gitkeep and \
inbox/README.md): save each into the correct voice's corpus with the standard \
dated header, re-distill that voice's STYLE.md, promote any cross-voice trait to \
SHARED.md, delete each ingested inbox file, then make ONE commit and push. Skip \
(don't delete) any file with a missing/invalid voice and report it. If the inbox \
has no real samples, do nothing." \
  --permission-mode acceptEdits \
  --allowedTools "Read,Edit,Write,Bash(git*),Bash(./scripts/build-skill-bundle.sh)"

echo "=== ingest done $(date -u +%FT%TZ) ==="
