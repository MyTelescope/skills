# Copywriting

Answers "Write copy for this piece" by searching the brand's knowledge base for the brief, brand context, and tone of voice before writing a single word. All copy is grounded in the actual language consumers use — pulled from demand signal names — and aligned to the brand's positioning.

---

## Step 1: Understand the brief

Extract:
- **The piece** - what needs to be written (ad, headline, email, landing page, social post, etc.)
- **The brand or product** - what it is for
- **The audience** - who it is talking to (infer from brand if not stated)
- **The objective** - what the copy should make the audience think, feel, or do
- **Any constraints** - character limits, channel rules, format requirements

If the objective is unclear, ask: "What should this copy make the reader think, feel, or do?"

---

## Step 2: Search the knowledge base

Call `knowledge_search` to retrieve all relevant brand materials before writing. Run multiple targeted queries.

```
knowledge_search(query="[brand] brief")
knowledge_search(query="[brand] tone of voice")
knowledge_search(query="[brand] brand positioning")
knowledge_search(query="[brand] audience")
knowledge_search(query="[product] benefits proof points")
```

Extract: the brief or campaign objective, tone of voice guidelines and vocabulary rules, proof points and product benefits, any existing approved or rejected copy, and the target audience description. If the knowledge base is empty, note it and proceed using only the user's inputs.

---

## Step 3: Ground the copy in consumer language

The copy must use the actual language consumers use when expressing interest in this category. Do not invent brand language from scratch — use the demand signal names from the knowledge base as anchors. If no demand signal language is available, ask the user: "Do you have specific phrases or language your consumers use that I should work with?"

---

## Output

Present the full copy deliverable structured as follows.

**Copy — [Piece type] — [Brand] — [Date]**

**Headline options**

| # | Headline | Angle |
|---|----------|-------|
| 1 | [headline text] | benefit-led |
| 2 | [headline text] | tension-led |
| 3 | [headline text] | aspiration-led |
| 4 | [headline text] | proof-led |

Recommend which headline best matches the brief and why.

**Body copy**

[Full body copy at the requested length or standard format for the piece type]

**Proof points**

1. [Claim — source: knowledge base document or demand signal]
2. [Claim — source: knowledge base document or demand signal]
3. [Claim — source: knowledge base document or demand signal]

**Tone notes**

One short paragraph explaining how this copy aligns with the brand's tone of voice as found in the knowledge base. If no tone guide was found, state the assumed tone and why.

---

## Rules

- Always search the knowledge base before writing — the search is not optional
- Always give multiple headline options with labeled angles — one option forces a binary yes/no
- Never invent proof points — every claim must be traceable to the knowledge base or demand signal data
- No dashboard or chart artifact — this skill delivers a copy document only
- Never use em dashes — use a hyphen or rewrite the sentence
- Vocabulary: "consumer language", "the language consumers use" - never "keywords" or "search volume"