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

## Privacy
This repo is **private**. The corpus is never sent anywhere external.
