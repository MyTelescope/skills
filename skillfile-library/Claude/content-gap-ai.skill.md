---
name: mytelescope-content-gap-ai
description: >
  Use this skill when the user asks what content they should create to improve
  their AI citation. Trigger for: "What should I create to get cited by AI?",
  "What content will help me show up in AI answers?", "Where are the gaps in
  my AI coverage?", "What topics is AI missing about my brand?", "What content
  would increase my AI visibility?", or any request to identify high-priority
  content opportunities based on AI citation gaps and real demand.
---

# Content Gap Analysis for AI Citation

## What this skill does

Answers "What should I create to get cited by AI?" by combining prior AI
visibility audit findings (what AI is missing about the brand) with demand
signal data (what people are actually searching for in that space). The
output is a prioritized content recommendation list ranked by opportunity:
highest demand plus biggest AI citation gap equals top priority..

The two tools that drive this skill:
- `search_signals` - discover demand signals in the brand's category to
  understand what consumers are actually interested in
- `get_demand_volume` - measure how much real consumer interest exists for
  each signal

---

## Step 1: Understand the context

Extract from the user's message or prior conversation:
- **Brand** - the company or product
- **Category** - the space the brand operates in
- **Prior audit findings** - if the user has already run `brand-presence-ai`,
  `bot-access-audit`, or `machine-readable-check` earlier in this
  conversation, use those findings directly

If no prior audit findings exist in the conversation, ask:
> "Have you already run an AI visibility audit for your brand? If so I can
> use those findings. If not, I can work from a fresh analysis of your
> category."

If working without prior audit findings, note this at the top of the report
and base the gap analysis on the demand signal data and general AI citation
patterns for the category.

If location is missing, ask:
> "Which market should I focus on? For example: United States, Germany,
> United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Discover demand signals in the category

Call `search_signals` to find what consumers are actively interested in
within the brand's space. Cast wide to capture the full landscape.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category variant]", location_id="<id>")
```

Deduplicate and group into natural clusters by intent:
- Awareness signals (what is X, who is Y)
- Comparison signals (X vs Y, best X for Z)
- Problem signals (how do I, what solves)
- Feature signals (X with [feature], does X do [thing])
- Pricing and access signals (X cost, X free, X pricing)

These clusters will map directly to content types in the recommendations.

---

## Step 3: Measure consumer interest

Call `get_demand_volume` for all signals to get monthly volume data.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract for each signal:
- Current monthly demand volume
- 12-month trend direction (Growing / Contracting / Flat)
- Year-on-year change %

Drop signals with no measurable demand. Keep growing signals — they represent
where consumer interest is heading, not just where it is today.

---

## Step 4: Map demand signals to AI citation gaps

Cross-reference the demand signals with the AI audit findings from Step 1:
- Which high-demand signals correspond to topics where the brand is missing
  from AI answers?
- Which signals map to query types (awareness, comparison, problem) where AI
  is not citing the brand?
- Which signals correspond to content the brand does not currently have
  (identified by `machine-readable-check` or the absence of relevant pages)?

For each signal, assign:
- **Demand level**: volume bucket (High / Medium / Low)
- **AI citation gap**: is the brand cited when AI answers this topic? (Gap /
  Partial / Covered)
- **Content exists**: does the brand have content that AI could cite for this
  topic? (Yes / No / Weak)

Signals that score High demand + Gap + No content are the highest-priority
opportunities.

---

## Step 5: Build the content gap dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make it visual and focused on opportunity.

The artifact must show:
- A bubble chart or opportunity matrix plotting demand volume against AI citation gap size - biggest opportunity = largest or most prominent bubble
- Color coding by trend: growing signals highlighted differently from flat or contracting
- A prioritized list below the chart: top 8-15 recommendations grouped by cluster (awareness, comparison, problem, feature, pricing)
- For each recommendation: topic, content type, demand volume, trend, and one-sentence "why AI is missing it"

A user should immediately see which content gaps represent the biggest opportunities.

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track these gaps over time? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always rank by opportunity, not just demand.** A high-demand signal the
brand already covers well is not an opportunity. Prioritization must combine
demand volume with AI citation gap.

**Always explain why AI is missing the brand.** Telling a user "create content
on X" without explaining why AI is not citing them today is not actionable.
Every recommendation needs the why.

**Use prior audit findings if available.** If `brand-presence-ai`,
`bot-access-audit`, or `machine-readable-check` findings exist in the
conversation, incorporate them. Do not redo work already done.

**Never invent demand data.** Only use volume data returned by
`get_demand_volume`. If a signal has no measurable volume, exclude it from
the recommendations.

**Vocabulary.** "Demand signals", "consumer interest", "AI citation gap" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover demand signals in the brand's category |
| `get_demand_volume` | 3 | Monthly volume per signal |