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
- **Captures don't persist in normal chat.** That sandbox is ephemeral, so
  "remember this" only sticks when done at home in Claude Code (real files +
  git). In chat, Claude hands back the updated text to fold in at home.

## Privacy
This repo is **private**. The corpus is never sent anywhere external. Uploading
`dist/voice.zip` to your own Claude account keeps it within Claude, not on any
third-party host — but it does leave this repo, so treat the upload as private.
