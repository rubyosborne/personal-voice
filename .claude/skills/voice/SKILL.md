---
name: voice
description: >-
  Ruby's personal writing-voice system. Use this skill whenever Ruby wants to
  (a) SAVE a piece of her own writing as a style sample — triggers like "add
  this to my writing", "add to my linkedin voice", "remember how I wrote this",
  "save this to my informal/formal voice"; or (b) DRAFT new text in her voice —
  triggers like "write this in my voice", "write a linkedin post in my voice",
  "make this sound like me", "draft this formally/informally like I would". The
  skill learns three voices (linkedin, informal, formal) layered on a shared
  base, and can blend them.
---

# Ruby's Voice System

This repo IS Ruby's writing memory. There is no model training — her voice
lives as readable rules + real examples that you read as context. You do two
jobs: **capture** (learn) and **write** (apply). Always confirm which voice.

## Layout
SHARED.md Core traits true across ALL of Ruby's writing
linkedin/STYLE.md Distilled rules for the LinkedIn voice
linkedin/corpus/ Raw LinkedIn samples (dated .md files)
informal/STYLE.md Distilled rules for the informal voice
informal/corpus/ Raw informal samples
formal/STYLE.md Distilled rules for the formal voice
formal/corpus/ Raw formal samples


The three voices are layers on top of SHARED.md. When writing in any voice,
you ALWAYS load SHARED.md first, then that voice's STYLE.md, then a few of
its corpus samples. This is how the voices "interact" — they share a spine.

---

## Where this runs (portable skill)

This skill is built to run in TWO places, with the SAME files bundled alongside
this SKILL.md (SHARED.md + each voice's STYLE.md and corpus):

- **Claude Code, in the real repo** — full local files + git. Both jobs work:
  capture saves new samples and re-distills; you commit and push.
- **A normal Claude chat (claude.ai web / Desktop app), as an uploaded skill** —
  runs in an ephemeral sandbox over the bundled copies. You can READ everything
  to draft, but you CANNOT save changes permanently.

Resolve every path below relative to wherever this SKILL.md lives (the repo
root in Claude Code; the skill's own folder when uploaded) — the data sits
beside it in both cases.

---

## Job 1 — CAPTURE ("add this to my <voice> writing")

When Ruby gives you a sample to remember:

1. **Identify the voice.** If she named one (linkedin / informal / formal), use
   it. If not, ask which of the three — never guess.
2. **Save the raw sample.** Write it verbatim to
   <voice>/corpus/NNNN-<short-slug>.md where NNNN is the next zero-padded
   number in that folder. Put a one-line header with the date and (if known)
   where it was used, then the text exactly as she wrote it. Do not "improve" it.
3. **Re-distill the profile (the "relearn" step).** Re-read that voice's
   existing STYLE.md plus the new sample, and update STYLE.md so it accurately
   reflects the voice including the new sample. Use concrete, evidence-backed
   observations — quote real fragments.
4. **Promote shared traits.** If a trait shows up across multiple voices (a
   habitual word, a value, a thing she never does), add it to SHARED.md so all
   three voices inherit it. Keep SHARED.md small and high-signal.
5. **Persist the change.**
   - In Claude Code (real repo): commit and push.
   - In a normal chat (uploaded skill): you CANNOT save automatically. Output the
     updated STYLE.md (and any new sample) as text, and tell Ruby plainly that
     the change won't stick until she updates the skill bundle at home and
     re-uploads the ZIP. Never imply it was saved when it wasn't.
6. Tell Ruby in one line what you learned/changed.

### What each STYLE.md should capture
- Tone & stance (warm/direct/wry/measured…)
- Sentence rhythm (length, fragments, how clauses chain)
- Vocabulary & signature phrases — real recurring words/expressions
- Punctuation & formatting habits (em-dashes, lists, line breaks, emoji?)
- Structure (how she opens, develops, closes)
- Avoids — words, clichés, or moves she never makes
- 2–4 short exemplar lines quoted from the corpus

---

## Job 2 — WRITE ("write this in my <voice> voice")

1. **Confirm the voice** (or the blend, e.g. "70% formal, warmer like informal").
2. **Load context in order:** SHARED.md → <voice>/STYLE.md → 2–4 most relevant
   <voice>/corpus/ samples. For a blend, load each voice's STYLE.md. This is the
   "look across" step — the live examples ground the draft.
3. **Draft** following the rules and matching the rhythm of the real samples.
   Match her, don't caricature her. Honor every "Avoids".
4. **Deliver the draft**, then offer to (a) tweak, or (b) save the final version
   back into the corpus — which makes the voice sharper next time.

## Job 3 — REVIEW ("show my <voice> profile")

Print the relevant STYLE.md (and SHARED.md) so Ruby can hand-edit it.
Her edits are authoritative — never overwrite a hand-edited rule on a re-distill
without flagging the conflict.

---

## Principles
- The corpus is private. Never paste samples into anything external.
- Real examples beat assumptions. When unsure how she'd phrase something, read
  the corpus, don't invent.
- Keep profiles concise and evidence-backed. Quoted fragments and specific
  habits are gold; vague adjectives are useless.
- More samples = better. Gently encourage capturing good writing as it happens.
