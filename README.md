# personal-voice — Ruby's private writing-voice system

A private corpus + a Claude Code skill that learns how I write and drafts in my
voice. Works anywhere I open this repo in Claude Code. GitHub is the sync layer.

## How it works
- **The memory** is this repo. Three voices — linkedin/, informal/, formal/ —
  each with a distilled STYLE.md and a corpus/ of real samples, all layered on a
  shared SHARED.md spine.
- **The brain** is the voice skill in .claude/skills/voice/. It does two things:
  - **Capture / "relearn":** say "add this to my linkedin voice" → it saves the
    sample and updates that voice's profile right then.
  - **Write / "look across":** say "write this in my formal voice" → it reads the
    shared spine + that voice's profile + a few real samples, and drafts.
- No model training. My voice is readable rules + examples, editable by hand.

## Using it
Open this repo in Claude Code, then just talk:
- add this to my informal voice (paste the text)
- write a linkedin post about X in my voice
- draft this formally, but a bit warmer like my informal voice
- show my linkedin profile (to read/edit the rules)

## Using it everywhere (phone, work laptop, normal Claude chats)
The same skill runs as an **uploaded Agent Skill** in normal Claude chats
(claude.ai web + Desktop app), not just in Claude Code — so I can use my voice on
devices that can't clone this repo.

- **Home (this device) is the source of truth.** Claude Code reads the live
  files here, so it always uses the most recent voice. Capturing runs
  `git pull --ff-only` first, then commits/pushes.
- **The upload bundle** is `dist/voice.zip` (gitignored, regenerated). A
  post-commit hook rebuilds it after every commit, so it's always current.
  Build manually with `./scripts/build-skill-bundle.sh`; install the hook on a
  new machine with `./scripts/install-hooks.sh`.
- **To use it on another device:** in Claude → Settings → Customize → Skills →
  Upload → pick `dist/voice.zip` (enable code execution under Capabilities).
  Then just talk in any chat — "write this in my LinkedIn voice" — and Claude
  loads the bundled voice and drafts.

### Two limits to know
- **No auto-sync.** Re-uploading the ZIP *is* the sync. After I capture new
  writing at home, re-upload the freshly rebuilt `dist/voice.zip` on each device.
- **Captures in normal chat don't persist on their own** (the sandbox is
  ephemeral) — which is exactly what the capture pipeline below fixes.

## Capturing from any device (the inbox pipeline)
So the voice can *learn* from writing done on a locked-down device (no git,
GitHub, iCloud), capture flows through a queue instead of needing local files:

1. **Capture** — talk to Claude on any device with the **voice-inbox MCP
   connector** enabled: "save this to my linkedin voice: …". The connector writes
   the raw sample into `inbox/` in this repo (via the GitHub API). It can also be
   tested by hand-dropping a file in `inbox/` (format in `inbox/README.md`).
2. **Queue** — the GitHub repo *is* the queue. Samples wait in `inbox/` until
   home ingests them; nothing is lost if the Mac is off.
3. **Learn** — on the home Mac, a weekly **launchd** job (Mondays 17:00; runs on
   next wake if asleep) calls `scripts/ingest-run.sh`, which runs the skill's
   **Job 4 — INGEST INBOX** via headless `claude -p`: each queued sample is saved
   to the right `<voice>/corpus/`, the `STYLE.md` is re-distilled, the inbox file
   is deleted, and it all commits/pushes (the hook rebuilds `dist/voice.zip`).
   Trigger it any time without waiting by saying **"process my voice inbox"** in
   Claude Code, or `launchctl kickstart -k gui/$(id -u)/com.ruby.voice-ingest`.

Setup: `./scripts/install-schedule.sh` (weekly job; `--remove` to undo). The
connector itself lives in a separate repo (`voice-mcp-server`, a Cloudflare
Worker). Cadence latency: a sample captured mid-week is learned at the next
Monday run. Idle weeks cost nothing — an empty inbox exits before calling Claude.

## Privacy
This repo is **private**. The corpus is never sent anywhere external. Uploading
`dist/voice.zip` to your own Claude account keeps it within Claude, not on any
third-party host — but it does leave this repo, so treat the upload as private.
