---
name: mytelescope-demand-landscape
description: >
  Use this skill when the user asks what is happening in a topic, category, or
  market in a specific location. Trigger for: "What's happening in [topic] in
  [location]?", "Give me an overview of [category] in [market]", "What does
  demand look like for [topic]?", "Show me the [topic] landscape in [country]",
  "What are people searching for around [topic]?", or any request for a broad
  demand overview of a space. This skill discovers what signals exist, how big
  each one is, and what matters most - then renders a prioritized landscape
  visualization ready to save as a dashboard.
---

# Demand Landscape

## What this skill does

Answers "What's happening in [topic] in [location]?" by discovering all demand
signals in the space, measuring their size, and ranking them by priority. The
output is a visual landscape artifact the user can read and optionally save as
a MyTelescope dashboard.

The three tools that drive this skill:
- `search_signals` - finds what exists in the space
- `get_demand_volume` - measures how big each signal is
- `calculate_demand_priorities` - surfaces what matters most

---

## Brand & Visual Rules

Defer to **`brand-rendering.skill.md`** for all visual rules. Minimum required:

- Fonts: Instrument Serif for headings and numbers; Inter 300/400/500 for body
- Colors: `#00CCFF` positive/growing, `#FF6B6B` negative/contracting, `#323F5F` neutral
- Cards: 6px radius, 0.5px `#D6D8DF` border, no shadows, no gradients
- Status enum: Growing / Contracting / Flat only
- Vocabulary: "demand signals", "consumer interest", "demand" - never "search volume", "keywords", "SEO"
- Volumes: `1.2k` not `1200`; always include sign on changes: `+12.4%`

---

## Step 1: Understand the request

Extract from the user's message:
- **Topic** - the market, category, or subject they want to explore
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous

If location is missing, ask before proceeding:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID and confirm
which data sources are available.

---

## Step 2: Discover what exists

Call `search_signals` with the topic to find all matching demand signals in
the space. Cast wide - use the core topic term plus 2-3 variations to surface
the full landscape.

```
search_signals(query="[topic]", location_id="<id>")
search_signals(query="[topic variant]", location_id="<id>")
```

Deduplicate results. Group signals into natural clusters by theme or intent
(e.g. for "weight loss": medication signals, diet signals, exercise signals,
surgery signals). These clusters become the trackers in the final dashboard.

If `search_signals` returns fewer than 5 signals, broaden the query. If it
returns more than 40, filter to the most semantically relevant.

---

## Step 3: Measure signal size

Call `get_demand_volume` for all discovered signals to get monthly volume
time-series data.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract for each signal:
- Latest monthly volume
- 12-month trend direction (Growing / Contracting / Flat)
- Year-on-year change %

If a signal returns no volume data, drop it from the landscape - do not show
signals with no measurable demand.

---

## Step 4: Calculate priorities

Call `calculate_demand_priorities` on the full signal set to understand which
signals matter most relative to each other.

```
calculate_demand_priorities(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Use the priority scores to:
- Rank signals within each cluster
- Identify the top 3 priority signals across the entire landscape
- Flag any high-priority signals that are also fast-growing (opportunity signals)

---

## Step 5: Build the landscape visualization

Build an interactive HTML artifact using Chart.js. This is the primary output.

Make it visual, colorful, and easy to read at a glance. Prioritize charts,
color-coded cards, and visual hierarchy over text blocks and long lists. A
user should understand the shape of the market in seconds without reading
paragraphs. Choose the chart types that best communicate the data — treemap,
bubble chart, bar chart, donut — whatever fits the signal set best.

The artifact must convey:
- What signals exist and how they cluster by theme
- How big each signal is relative to the others
- Which signals matter most (priority)
- Any opportunity signals (high-priority + fast-growing)

Keep it concise. No long text sections. No raw data dumps.

---

## Step 6: Ask for customization

Before building the artifact, say:
> "Let me render an initial dashboard draft."

Then build and show it. Immediately after, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:

> "Want me to save this to MyTelescope so you can track how this landscape
> evolves over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with the signal clusters from Step 2 as trackers
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always run all three tools.** `search_signals` alone is not a demand
landscape. Volume and priority data are required before building the artifact.

**Never show signals with no volume data.** If `get_demand_volume` returns
nothing for a signal, drop it silently. Do not tell the user "no data found" -
simply exclude it.

**Always group into clusters.** A flat list of 30 signals is not a landscape.
Cluster by theme before rendering. 3-6 clusters is the right range.

**Show the artifact before asking to save.** Never ask "do you want a
dashboard?" without showing the landscape first and giving the user a chance
to customize it.

**Never skip the customization question.** Always ask "would you like to change
anything?" after showing the artifact. Never go straight to saving.

**Vocabulary.** "Demand signals", "consumer interest", "demand landscape",
"signal clusters". Never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover signals in the space |
| `get_demand_volume` | 3 | Monthly volume per signal |
| `calculate_demand_priorities` | 4 | Priority ranking across signals |
| `create_signal_collection` | 7 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 7 | Attach the HTML artifact |
| `generate_platform_link` | 7 | Link to the live dashboard |
