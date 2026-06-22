---
name: mytelescope-cross-market
description: >
  Use this skill when the user wants to compare how signals perform across
  multiple markets or countries. Trigger for: "How does this perform in France
  vs Germany vs UK?", "Compare demand for [topic] across markets", "Which
  country has the most demand for [topic]?", "Show me [topic] across Europe",
  "How does [signal] index in different markets?", or any request to run the
  same signals across two or more geographies and compare the results side
  by side.
---

# Cross-Market Comparison

## What this skill does

Answers "How does this perform across markets?" by running the same demand
signals through each specified market and comparing the results side by side.
The output is a visual dashboard that makes market-by-market differences
immediately clear, which the user can customize and save to MyTelescope.

The two tools that drive this skill:
- `get_location_details` - resolves each market to an ID and confirms available sources
- `get_demand_volume` - measures demand for the same signals in each market separately

---

## Step 1: Understand the request

Extract from the user's message:
- **Topic or signals** - what they want to compare across markets
- **Markets** - the countries or regions to compare (ask if fewer than 2 specified)

If fewer than 2 markets are specified, ask:
> "Which markets should I compare? For example: France, Germany, United Kingdom."

Aim for 2-6 markets. More than 6 markets in a single comparison is hard to
read — if the user lists more, ask which 4-6 matter most or confirm they want
all of them.

Call `get_location_details` for each market to resolve it to a location ID and
to note which data sources are available per market. Different markets may have
different source availability — account for this when interpreting results.

---

## Step 2: Align signals across markets

If the user has specified signals, use them. If not, run `search_signals` on
the primary market (or the first listed market) to discover the relevant
signals for the topic.

```
search_signals(query="[topic]", location_id="<primary market id>")
```

Use the discovered signals as the consistent set across all markets. The same
signals should be measured in every market — this is what makes the comparison
valid. Do not use different signals per market.

Settle on 5-15 signals — enough to represent the topic without the comparison
becoming unreadable.

---

## Step 3: Measure demand per market

Call `get_demand_volume` separately for each market, passing the same signal
set each time. Separate calls per market are required — do not combine markets
in a single call.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<market 1 id>",
    language_id="<market 1 language>"
)
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<market 2 id>",
    language_id="<market 2 language>"
)
```

Repeat for each market. For each market extract:
- Total demand volume across all signals
- Per-signal volume
- 12-month trend direction
- Year-on-year change %

Note: volume scales may differ significantly between markets. Present absolute
numbers and relative comparisons so the user can read both.

---

## Step 4: Frame the cross-market picture

Before building, do the analysis:
- Rank markets by total demand (largest to smallest)
- Identify which market has the strongest consumer interest for this topic
- Note markets where demand is growing fastest (YoY)
- Flag any market where demand is contracting while others are growing —
  this divergence is often the most interesting finding
- Note any signal-level differences across markets — where a specific signal
  dominates in one market but not another

---

## Step 5: Build the cross-market dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Side-by-side comparison
is the visual priority — the user should be able to see all markets at once
and instantly read which is largest, which is growing fastest, and where the
differences are sharpest. Grouped bar charts, heat maps, or small multiples
all work well here. Use a consistent color per market across all charts so
the user can track each geography visually.

The artifact must convey:
- Total demand per market (ranked)
- Trend direction per market for this topic
- Any notable per-signal differences across markets (where the pattern differs)
- The headline finding: which market leads and which diverges

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how these markets
> move relative to each other over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with the signals as trackers — if the tool
   supports multi-market configuration, group by market; otherwise use the
   primary market
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always call `get_location_details` for every market.** Location IDs and
available sources differ per market. Never assume a location ID or source
availability.

**Always use the same signal set across all markets.** The comparison is only
valid if the same signals are measured in each geography. Do not swap signals
per market.

**Always call `get_demand_volume` separately per market.** Do not combine
markets in a single call. Results need to be independently attributable to
each geography.

**Always account for language.** Each market has a language. Pass the correct
language ID for each `get_demand_volume` call — do not use one language for
all markets.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "markets", "geographies"
— never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve each market to an ID and check sources |
| `search_signals` | 2 | Discover signals if not specified by user |
| `get_demand_volume` | 3 | Demand volume per market (one call per market) |
| `create_signal_collection` | 7 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 7 | Attach the HTML artifact |
| `generate_platform_link` | 7 | Link to the live dashboard |