---
name: mytelescope-source-breakdown
description: >
  Use this skill when the user asks where demand is coming from across
  platforms or sources. Trigger for: "Where is this demand coming from?",
  "Is this more Google or YouTube?", "How does Amazon compare to Google for
  this topic?", "Which platform has the most demand for [topic]?", "Show me
  the source breakdown for [category]", or any request to understand how
  consumer interest distributes across different platforms or data sources
  in a market.
---

# Source Breakdown

## What this skill does

Answers "Where is this demand coming from?" by identifying which platforms
carry the most consumer interest for a topic, then comparing them side by side.
The output is a visual dashboard that shows the demand distribution across
sources so the user can see where to focus.

The two tools that drive this skill:
- `get_location_details` - identifies which data sources are available for the market
- `get_demand_volume` - measures demand for the topic separately per source

---

## Step 1: Resolve location and available sources

Extract from the user's message:
- **Topic** - what they want to analyze
- **Location** - country or region (ask if missing)

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to get the location ID and, critically, to see
which data sources are available for that market. Not all sources are available
in all markets. Use only the sources returned for this location — never assume
a source exists.

---

## Step 2: Measure demand per source

Call `get_demand_volume` separately for each available source, passing the same
topic signals each time. Running separate calls per source ensures the volume
figures reflect each platform's scale independently.

```
get_demand_volume(
    keywords=["topic signal 1", "topic signal 2", ...],
    location_id="<id>",
    language_id="<language>",
    source="google"
)
get_demand_volume(
    keywords=["topic signal 1", "topic signal 2", ...],
    location_id="<id>",
    language_id="<language>",
    source="youtube"
)
```

Repeat for each available source. For each source extract:
- Total demand volume across signals
- 12-month trend direction for this source
- Year-on-year change %
- Monthly time series (to show whether each platform is growing or declining
  for this topic)

---

## Step 3: Build the source comparison picture

Before building, do the analysis:
- Rank sources by total demand (largest to smallest)
- Calculate what share of total cross-platform demand each source holds
- Flag which source is growing fastest for this topic
- Note any source where demand is contracting — platform-level decline for
  this topic is a meaningful signal

---

## Step 4: Build the source breakdown dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make the source comparison
the visual centerpiece. Choose chart types that make platform distribution
immediately readable: stacked bar charts, donut charts showing share, or
side-by-side volume bars. Use a multi-line trend chart to show how each
source's demand has moved over the past 12 months.

The artifact must convey:
- Which source carries the most demand for this topic
- Each source's share of total cross-platform demand
- Trend direction per source — which platforms are growing for this topic
- Any platform where demand is notably declining

---

## Step 5: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 6: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how these sources
> shift over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with the topic signals as trackers
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always call `get_location_details` first.** The list of available sources is
market-specific. Never assume which sources exist for a given location.

**Always call `get_demand_volume` separately per source.** Aggregating sources
in a single call hides the per-platform picture. Each source needs its own call.

**Only show sources that returned data.** If a source is available for the
market but returns no volume for this topic, exclude it from the dashboard
silently. Do not tell the user a source returned nothing — just omit it.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "sources", "platforms" —
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location ID and list available sources |
| `get_demand_volume` | 2 | Demand volume per source (one call per source) |
| `create_signal_collection` | 6 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 6 | Attach the HTML artifact |
| `generate_platform_link` | 6 | Link to the live dashboard |