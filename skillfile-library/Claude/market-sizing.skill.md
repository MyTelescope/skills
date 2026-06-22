---
name: mytelescope-market-sizing
description: >
  Use this skill when the user asks how big a category or market is, or wants
  to understand the relative weight of segments within a space. Trigger for:
  "How big is this category?", "What's the total size of this market?", "What
  dominates demand in [space]?", "Show me the full demand landscape for
  [category]", "Which segments are biggest in [market]?", "What share does
  each part of [category] hold?", or any request to size a market and
  understand what dominates within it.
---

# Market Sizing

## What this skill does

Answers "How big is this category?" by casting wide across the full demand
landscape, measuring total volume across all signals, and calculating the
relative weight of each segment. The output is a visual dashboard with size
and dominance framing that shows the user where demand actually lives.

The two tools that drive this skill:
- `search_signals` - discovers the full signal landscape across the category
- `calculate_demand_priorities` - determines the relative weight and dominance of each segment

---

## Step 1: Understand the request

Extract from the user's message:
- **Category** - the market or space they want to size
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Cast wide across the category

Call `search_signals` with multiple queries to surface the full signal set
across the category. Market sizing requires breadth — cast wider than you think
necessary to avoid missing significant segments.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category segment A]", location_id="<id>")
search_signals(query="[category segment B]", location_id="<id>")
```

Use 3-5 search queries to cover the space from multiple angles. Deduplicate
the results. Aim for a signal set of 20-60 signals — enough to represent the
full category without noise.

Group signals into natural market segments before proceeding. A market sizing
exercise needs segments, not a flat list. 4-8 segments is the right range.
Name each segment so it is meaningful to the user (e.g. for "skincare": basic
moisturizers, anti-aging, SPF, professional treatments, organic/natural).

---

## Step 3: Calculate demand priorities

Call `calculate_demand_priorities` on the full signal set to understand which
signals — and by extension which segments — carry the most weight in this
market.

```
calculate_demand_priorities(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Use the priority scores to:
- Sum the priority weight per segment to get a segment-level dominance score
- Rank segments by total demand weight (largest to smallest)
- Identify which single segment dominates the market
- Flag any segment that is large but under-served relative to its size

---

## Step 4: Build the market sizing dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Size and proportion are
the visual story — the user needs to feel the relative scale of each segment
instantly. Choose chart types that communicate scale and dominance well:
treemaps, large donut or pie charts, or ranked horizontal bar charts. Show
each segment's share of total market demand alongside its absolute priority
weight.

The artifact must convey:
- Total market scope — how many signals, how many segments
- Which segment dominates (largest share of demand)
- The relative size of each segment — what portion of the market each holds
- Any notable gaps or under-served segments

Avoid showing individual signal-level data unless the market has fewer than
10 signals. At market sizing scale, segment aggregates tell the story.

---

## Step 5: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 6: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how this market
> evolves over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with signals grouped by market segment
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Cast wide.** A market sizing that misses a major segment is wrong. Run
multiple `search_signals` queries to cover the full category — not just the
most obvious angle.

**Always group into segments.** Showing individual signals without aggregating
into segments does not answer "how big is this market?" The segment view is
the whole point.

**Always rank by dominance.** The user needs to know what is biggest. Always
surface the dominant segment clearly and explicitly.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "market segments",
"demand weight" — never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover full signal set across the category |
| `calculate_demand_priorities` | 3 | Segment-level dominance and priority weight |
| `create_signal_collection` | 6 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 6 | Attach the HTML artifact |
| `generate_platform_link` | 6 | Link to the live dashboard |