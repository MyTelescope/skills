---
name: mytelescope-strategic-brief
description: >
  Use this skill when the user asks for a strategic brief for a brand or
  product. Trigger for: "Build me a strategic brief for this brand",
  "Create a strategy brief for [brand]", "Write a brief for [product]",
  "Give me a strategic platform for [brand]", "What should [brand] stand for?",
  or any request to produce a grounded strategic brief, creative platform, or
  brand positioning document. This skill grounds the brief in real demand data
  rather than assumptions.
---

# Strategic Brief

## What this skill does

Answers "Build me a strategic brief for this brand" by searching the brand's
knowledge base for existing context, then grounding every section of the brief
in real demand signal language. The output is a structured brief document
written in the words consumers actually use, not agency-invented language. No
dashboard.

The two tools that drive this skill:
- `knowledge_search` - retrieves brand context, documents, and prior positioning from the knowledge base
- `search_signals` + `get_demand_volume` - discovers what consumers are actually saying about the brand's category

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand or product** - what the brief is for
- **Location** - country or region (ask if missing)
- **Audience or objective** - any brief, campaign, or audience constraints the user has mentioned

If location is missing, ask:
> "Which market should this brief cover? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Search the brand knowledge base

Call `knowledge_search` to retrieve any existing brand documents, prior briefs,
tone of voice guides, research, or positioning materials in the knowledge base.
Run multiple queries to surface different angles.

```
knowledge_search(query="[brand] brand positioning")
knowledge_search(query="[brand] target audience")
knowledge_search(query="[brand] tone of voice")
knowledge_search(query="[brand] product benefits")
```

Extract from the results:
- Any stated brand purpose or positioning
- Known audience descriptions
- Product or service benefits and proof points
- Any existing strategic or creative direction

If the knowledge base returns nothing useful, note that the brief will be built
from demand signals alone, and proceed.

---

## Step 3: Pull demand signals for the category

Call `search_signals` to discover what consumers are expressing in the brand's
category. Use the brand's core territory as the query.

```
search_signals(query="[brand category]", location_id="<id>")
search_signals(query="[brand product type]", location_id="<id>")
```

Then call `get_demand_volume` on the discovered signals to understand which
are largest and most relevant.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Use the signal names and volume patterns to:
- Understand what language consumers use (this becomes the brief's vocabulary)
- Identify the dominant consumer need in the category
- Find the single biggest tension or unmet desire in the demand data
- Spot which benefit or outcome drives the most consumer interest

---

## Step 4: Build the strategic brief

Assemble the brief document using only language grounded in the demand data
and knowledge base. Structure it as follows:

**The challenge**
One sentence. What tension or problem does the brand exist to solve? Use the
demand signal language to name it precisely.

**Human insight**
One to two sentences. What does the demand data reveal about how consumers
actually feel about this category? Reference the dominant signals and volumes
to ground it. This is not a made-up insight - it is what the data shows.

**Single-minded idea**
One sentence. The brand's response to the insight. Written in plain language,
not adspeak.

**Reason to believe**
Two to four points. Each one sourced from either the knowledge base documents
or the demand signal data. No unsubstantiated claims.

**Consumer language**
A short list of the actual phrases consumers use when expressing demand in this
category. Pulled directly from the top-volume signal names. These are the words
the brief's creative output should echo.

**What to avoid**
Any language, territories, or positions that the demand data shows consumers
associate with competitors, or that appear to have flat or contracting demand.

---

## Step 5: Build the brief dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact. Make it visually structured and easy to read.

The artifact must show:
- The challenge and human insight as a highlighted card at the top
- The single-minded idea as the largest, most prominent element on the page
- Reasons to believe as a clean numbered list with source labels
- Consumer language as a visual word cluster or tag cloud showing the actual phrases consumers use, sized by volume
- What to avoid as a clearly separated section

This is a strategic brief that a creative team can read and act on immediately.

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your brief is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always search the knowledge base first.** A brief built without checking
what the brand already knows is a brief built blind. Even if the knowledge base
returns little, the attempt must be made.

**Always pull demand signals.** The brief vocabulary must come from real
consumer language. Never write the human insight or single-minded idea without
first checking what the demand data says about the category.

**Never use made-up insights.** Every insight claim must be traceable to
either a knowledge base document or a specific signal and its volume. If the
data does not support a claim, do not make it.

**Vocabulary.** "Demand signals", "consumer interest", "consumer language" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `knowledge_search` | 2 | Retrieve brand context and documents |
| `search_signals` | 3 | Discover category demand signals |
| `get_demand_volume` | 3 | Volume and trend per signal |