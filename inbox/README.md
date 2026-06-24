# inbox/ — the capture queue

Samples captured from any device land here as individual files, then get drained
into the voice corpus by **Job 4 — INGEST INBOX** (see
`../.claude/skills/voice/SKILL.md`). This folder is normally **empty** (just
`.gitkeep` + this README) — a queued file means "not yet learned."

## How files get here
- The **MCP connector** (`save_voice_sample`) writes them via the GitHub API.
- Or you can drop one by hand to test ingestion.

## File convention
Name: `<ISO-UTC, colons/dots stripped>--<voice>--<6hex>.md`
e.g. `2026-06-24T0314Z--linkedin--a1b2c3.md`

Contents — YAML frontmatter, then the verbatim sample after the closing `---`:

```markdown
---
voice: linkedin          # REQUIRED — one of: linkedin | informal | formal
source: claude-ios        # optional — where it was captured
received: 2026-06-24T03:14:00Z   # optional — ISO timestamp
slug: techweek-recap      # optional — Job 4 derives one if absent
desc: LinkedIn post recapping the Techweek panel   # optional — used in the header
---
The exact text of the sample, untouched. Em-dashes, :) and !! all fine.
```

Only `voice` is required. The body is never edited on ingest. A file with a
missing/invalid `voice` is skipped (left here) and reported, never guessed.
