#!/usr/bin/env bash
# Build the uploadable "voice" skill bundle for Claude (web / Desktop chat).
# Produces dist/voice.zip — upload it via Settings > Customize > Skills > Upload.
#
# The ZIP contains a top-level folder `voice/` with SKILL.md at its root plus the
# bundled voice data (SHARED.md + each voice's STYLE.md and corpus), so the same
# instructions and files that power the local Claude Code skill travel with it.

set -euo pipefail
cd "$(dirname "$0")/.."   # repo root

OUT="dist/voice"
rm -rf dist
mkdir -p "$OUT"

# SKILL.md goes at the bundle root (Claude expects voice/SKILL.md).
cp .claude/skills/voice/SKILL.md "$OUT/SKILL.md"

# Bundle the voice data beside it, co-located so relative paths resolve.
cp SHARED.md "$OUT/SHARED.md"
for v in linkedin informal formal; do
  mkdir -p "$OUT/$v"
  cp "$v/STYLE.md" "$OUT/$v/STYLE.md"
  if [ -d "$v/corpus" ]; then
    cp -R "$v/corpus" "$OUT/$v/corpus"
  fi
done

# Zip from dist/ so the archive contains the `voice/` folder at its root.
( cd dist && zip -r -q voice.zip voice )

echo "Built dist/voice.zip"
unzip -l dist/voice.zip
