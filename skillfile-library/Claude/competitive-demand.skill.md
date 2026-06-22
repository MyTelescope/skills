---
name: mytelescope-competitive-demand
description: >
  Use this skill when the user asks how their brand or product compares to
  competitors in demand. Trigger for: "How does my brand compare to
  competitors?", "Who is winning in [category]?", "Am I gaining or losing
  ground against [competitor]?", "Compare demand for [brand A] vs [brand B]",
  "Who has more consumer interest in [market]?", or any request to benchmark
  one brand or product against others using demand signals.
---

# Competitive Demand

## What this skill does

Answers "How does my brand compare to competitors?" by measuring demand signals
for the user's brand alongside each competitor, then visualizing who is gaining
ground and who is losing it. The output is a comparative dashboard with clear
winner/loser framing that the user can customize and save to MyTelescope.

The two tools that drive this skill:
- `search_signals` - finds demand signals for the brand and each competitor
- `get_demand_volume` - measures volume for all signals together to get comparable numbers

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand** - the user's own brand or product
- **Competitors** - the brands or products to compare against (ask if missing)
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous

If competitors are missing, ask:
> "Which competitors should I compare against? List up to 5 brands or products."

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Discover signals for each entity

Call `search_signals` separately for the user's brand and for each competitor.
This ensures you capture the distinct demand signals associated with each entity
rather than conflating them.

```
search_signals(query="[brand]", location_id="<id>")
search_signals(query="[competitor 1]", location_id="<id>")
search_signals(query="[competitor 2]", location_id="<id>")
```

For each entity, keep the most representative signals — typically 3-8 signals
that clearly reflect consumer interest in that brand or product. Discard
generic or ambiguous signals that could apply to multiple entities.

---

## Step 3: Measure volume for all signals together

Call `get_demand_volume` once with all signals across all entities combined.
Passing them together ensures volume numbers are on the same scale and
directly comparable.

```
get_demand_volume(
    keywords=["brand signal 1", "brand signal 2", "comp1 signal 1", ...],
    location_id="<id>",
    language_id="<language>"
)
```

For each entity, aggregate the volume across its signals to get a total demand
figure. Then extract:
- Total current demand per entity
- 12-month trend direction (Growing / Contracting / Flat)
- Year-on-year change % per entity
- Monthly time series for each entity (to show momentum)

---

## Step 4: Frame the competitive picture

Before building, do the analysis:
- Rank entities by total current demand (largest to smallest)
- Identify who is gaining (positive YoY trend) and who is losing (negative YoY)
- Flag if the user's brand is gaining or losing relative to each named competitor
- Note any competitor that is growing faster than all others — the momentum leader

This framing shapes the dashboard. Be direct about winners and losers.

---

## Step 5: Build the competitive dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make it visual and direct —
the user should see in seconds who is winning and who is not. Choose chart types
that make the comparison obvious: grouped bar charts, share-of-demand donut
charts, multi-line trend charts, or side-by-side volume cards. Layer in trend
direction using color so growth and decline read instantly.

The artifact must convey:
- Current demand size for each entity (who is biggest)
- Who is gaining and who is losing ground (trend direction)
- The overall competitive order — clear ranking
- Any momentum shift — a smaller player growing faster than the leader

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track this competitive picture
> over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with signals grouped by entity (one tracker
   group per brand/competitor)
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always run `search_signals` separately for each entity.** Searching for all
brands in one query conflates signals. Each entity needs its own discovery pass.

**Always call `get_demand_volume` once with all signals combined.** Volume
numbers must be on the same scale to be comparable. Never call it separately
per entity and compare the results.

**Always rank.** A competitive dashboard without a clear winner/loser ranking
is not useful. Always surface who is first and who is last.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "competitive demand" —
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover signals per brand and per competitor |
| `get_demand_volume` | 3 | Volume for all signals on a comparable scale |
| `create_signal_collection` | 7 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 7 | Attach the HTML artifact |
| `generate_platform_link` | 7 | Link to the live dashboard |