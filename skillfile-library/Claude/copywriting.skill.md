---
name: mytelescope-copywriting
description: >
  Use this skill when the user asks to write copy, headlines, or messaging for
  a brand or campaign. Trigger for: "Write copy for this piece", "Write a
  headline for X", "Give me copy for [ad or asset]", "Write the messaging for
  [campaign]", "Draft body copy for [brief]", "Give me headline options for
  [product]", or any request to produce copywriting that should be grounded in
  real consumer language and brand positioning. This skill searches the
  knowledge base before writing anything.
---

# Copywriting

## What this skill does

Answers "Write copy for this piece" by searching the brand's knowledge base
for the brief, brand context, and tone of voice before writing a single word.
All copy is grounded in the actual language consumers use - pulled from demand
signal names - and aligned to the brand's positioning. The output is a
structured copy deliverable with headline options, body copy, and proof points.
No dashboard.

The one tool that drives this skill:
- `knowledge_search` - retrieves brief, brand context, tone of voice guides, and
  any prior copy direction from the knowledge base

---

## Step 1: Understand the brief

Extract from the user's message:
- **The piece** - what needs to be written (ad, headline, email, landing page,
  social post, etc.)
- **The brand or product** - what it is for
- **The audience** - who it is talking to (infer from brand if not stated)
- **The objective** - what the copy should make the audience think, feel, or do
- **Any constraints** - character limits, channel rules, format requirements

If the objective is unclear, ask one question:
> "What should this copy make the reader think, feel, or do?"

---

## Step 2: Search the knowledge base

Call `knowledge_search` to retrieve all relevant brand materials before writing.
Run multiple targeted queries to surface different content types.

```
knowledge_search(query="[brand] brief")
knowledge_search(query="[brand] tone of voice")
knowledge_search(query="[brand] brand positioning")
knowledge_search(query="[brand] audience")
knowledge_search(query="[product] benefits proof points")
```

Extract from the results:
- The brief or campaign objective if one exists
- The brand's tone of voice guidelines and any specific vocabulary rules
- Proof points, product benefits, or reason-to-believe statements
- Any existing copy or messaging the brand has approved or rejected
- The target audience description

If the knowledge base returns relevant materials, use them as the copy
foundation. If the knowledge base is empty, note it and proceed using only
the demand signal language available.

---

## Step 3: Ground the copy in consumer language

The copy must use the actual language consumers use when expressing interest in
this category. Do not invent brand language from scratch - instead, look at the
demand signal names retrieved from the knowledge base or from what the user
has shared, and use those phrases as anchors.

If the knowledge base does not contain demand signal language, ask the user:
> "Do you have any specific phrases or language your consumers use that I
> should work with? Or I can pull demand signals from the platform if you
> share the category."

Consumer language examples:
- If the brand is in weight management and the knowledge base shows signals like
  "lose weight fast" and "sustainable weight loss", write toward "fast" and
  "sustainable" - those are what consumers are actually expressing.
- If the knowledge base shows "affordable luxury", use that tension directly.

---

## Step 4: Write the copy

Produce the copy deliverable structured as follows:

**Headline options**
3-5 options. Each one different in angle, not just in wording. Label the angle:
e.g. (benefit-led), (tension-led), (aspiration-led), (proof-led). Make clear
which one best matches the brief and why.

**Body copy**
One complete version of the body copy at the requested length or format. If no
length was specified, write to the most common format for the piece type. Keep
it clean - no padding, no filler phrases.

**Proof points**
2-4 supporting statements the copy can draw on. Each one traceable to either
a knowledge base document or a specific demand signal. No invented claims.

**Tone notes**
One short paragraph explaining how this copy aligns with the brand's tone of
voice as found in the knowledge base. If no tone guide was found, note what
tone was assumed and why.

---

## Step 5: Present and offer revisions

Present the full copy deliverable. After presenting, ask:
> "Would you like me to adjust the tone, try a different angle on any of the
> headlines, or rewrite the body copy for a different channel or length?"

If the user wants changes, apply them and present the revised version. Be
specific about what changed and why.

---

## Hard rules

**Always search the knowledge base before writing.** Copy written without
checking the brief and tone of voice guide is copy that could violate brand
rules or miss the target. The knowledge base search is not optional.

**Always give multiple headline options with labeled angles.** A single
headline option forces the user into a binary yes/no. Multiple options with
distinct angles let the user choose a direction.

**Never invent proof points.** Every claim in the body copy must be traceable
to the knowledge base or to explicit demand signal data. If there is no evidence
for a claim, do not make it.

**No dashboard.** This skill delivers a copy document. Do not offer to save
a signal collection or render a chart artifact.

**Never use em dashes.** Use a hyphen or rewrite the sentence.

**Vocabulary.** When referring to the underlying consumer data, say "consumer
language" and "the language consumers use". Never say "keywords" or "search
volume" to the user.

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `knowledge_search` | 2 | Retrieve brief, tone of voice, and brand context |