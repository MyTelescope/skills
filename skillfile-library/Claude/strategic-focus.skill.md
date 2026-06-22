---
name: mytelescope-strategic-focus
description: >
  Use this skill when the user asks where to focus strategically or where to
  compete. Trigger for: "What should I focus on?", "Where should I play?",
  "What space should [brand] own?", "Where is there white space for [brand]?",
  "What positioning is available in [category]?", "Where can I win against
  competitors?", or any request to identify the most strategically viable space
  for a brand given what competitors already own and where real consumer demand
  exists but is not yet claimed.
---

# Strategic Focus

## What this skill does

Answers "Where should I play?" by cross-referencing what competitors already
own in messaging and positioning against where real consumer demand exists but
remains unclaimed. The output is a structured strategic recommendation document
- where to play, how to win - grounded in both demand evidence and competitor
white space analysis..

The four tools that drive this skill:
- `web_search` + `web_fetch` - audits what competitors own in messaging and positioning
- `search_signals` - discovers where consumer demand actually lives
- `get_demand_volume` - measures the size of each demand space

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand** - whose strategic focus is being defined
- **Category** - the space to map (infer from brand if not stated)
- **Competitors** - who to audit (ask for up to 4 if not specified)
- **Location** - country or region (ask if missing)

If competitors are missing, ask:
> "Which competitors should I audit for positioning and messaging? Name up to 4."

If location is missing, ask:
> "Which market should this cover? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Audit competitor positioning and messaging

For each competitor, use `web_search` to find their current positioning,
taglines, campaign messages, and content themes.

```
web_search(query="[competitor] brand positioning messaging [year]")
web_search(query="[competitor] advertising campaign [category]")
```

For the most relevant results, call `web_fetch` to read the actual content
rather than relying on search snippets alone.

For each competitor, extract:
- The core positioning territory they own (e.g. "performance", "sustainability",
  "affordability", "premium quality")
- The specific language and claims they repeat consistently
- Any audience they explicitly target in messaging
- What they do not talk about - notable absences from their messaging

Build a positioning map: a simple list of which territories each competitor
has planted a flag in. This is the occupied ground.

---

## Step 3: Discover demand signals in the category

Call `search_signals` with the category and relevant variants to map the full
consumer demand landscape.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category variant]", location_id="<id>")
```

Then call `get_demand_volume` to understand which demand spaces are largest
and which are growing.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Group signals into demand spaces (3-6 thematic clusters). For each cluster,
note its total volume and trend direction.

---

## Step 4: Find the white space

Cross-reference the competitor positioning map against the demand clusters.
For each demand cluster, ask:

- Does a competitor own this space clearly and loudly?
- Is the demand in this cluster growing, flat, or contracting?
- Could the brand credibly compete here given what the knowledge base says
  about its strengths?

A genuine white space is a demand cluster where:
1. Consumer demand is real and measurable
2. No competitor currently owns this space with consistent, clear messaging
3. The brand could credibly enter

Distinguish between true white spaces (nobody owns it), soft white spaces
(competitors are present but weakly or inconsistently), and owned territory
(a competitor owns it clearly - entering would be a direct fight).

---

## Step 5: Build the strategic recommendation

Deliver a structured document with the following sections:

**Where to play**
Name 1-3 specific demand spaces that represent the strongest opportunity.
For each, state: the demand cluster, its volume and growth direction, and why
competitors have not claimed it convincingly.

**How to win**
For each recommended space, a specific positioning angle or message direction
the brand could own. Ground this in the consumer language from the demand
signal names - use the words consumers actually use, not invented brand language.

**What to avoid**
Territories already owned strongly by a competitor. Name the competitor and
the specific territory. Entering owned ground without a significant reason is
expensive and rarely successful.

**The competitive context**
A brief summary of the positioning map - what each key competitor currently
stands for, in one sentence each.

Keep each section concise. Bullet points are fine. This is a working document,
not a narrative essay.

---

## Step 6: Build the strategic focus dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make it visual and strategic.

The artifact must show:
- A positioning map or bubble chart: demand spaces plotted by volume (size) and competitive density (color) - white spaces are visually obvious
- Recommended spaces highlighted with a clear "Play here" label
- Competitor territories shown as occupied zones
- Consumer language from the top demand signals displayed as a word cluster or tag list

A brand strategist should be able to see the opportunity in seconds without reading a document.

---

## Step 7: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 8: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always audit competitors before looking at demand.** The whole point is to
find where demand exists and competitors are absent. Auditing demand without
knowing what competitors own produces useless recommendations.

**Ground every recommendation in both evidence types.** A demand space qualifies
as an opportunity only if it has measurable consumer demand AND is not clearly
owned by a competitor. One without the other is not enough.

**Never invent competitor positioning.** Only report what the web search and
fetch results actually show. If a competitor's positioning is unclear from the
results, say so rather than guessing.

**Vocabulary.** "Demand signals", "demand spaces", "consumer interest" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `web_search` | 2 | Find competitor positioning and messaging |
| `web_fetch` | 2 | Read competitor content in full |
| `search_signals` | 3 | Discover demand spaces in the category |
| `get_demand_volume` | 3 | Volume and trend per demand space |