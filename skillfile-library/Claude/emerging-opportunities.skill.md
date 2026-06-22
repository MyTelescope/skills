---
name: mytelescope-emerging-opportunities
description: >
  Use this skill when the user asks what is growing, rising, or emerging in a
  space. Trigger for: "What's growing fast in [space]?", "What's emerging in
  [category]?", "Show me rising signals in [market]", "What are the
  first-mover opportunities in [topic]?", "What's taking off in [location]?",
  or any request focused on fast-rising demand and early opportunities.
---

# Emerging Opportunities

## What this skill does

Answers "What's growing fast in [space]?" by discovering demand signals in the
space and identifying which ones are rising fastest — before they peak. The
output is a visual dashboard focused on growth velocity and first-mover
opportunity, which the user can customize and save to MyTelescope.

The two tools that drive this skill:
- `search_signals` - finds what exists in the space
- `calculate_emerging_demand` - identifies which signals are rising fastest

---

## Step 1: Resolve location

Call `get_location_details` to get the location ID. If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

---

## Step 2: Discover signals

Call `search_signals` with the topic and 2-3 variations to surface the full
signal set in the space.

```
search_signals(query="[topic]", location_id="<id>")
search_signals(query="[topic variant]", location_id="<id>")
```

Deduplicate results. Aim for 15-40 signals — enough to surface genuine
emerging patterns.

---

## Step 3: Calculate emerging demand

Call `calculate_emerging_demand` on the full signal set to identify which
signals are rising fastest relative to their baseline.

```
calculate_emerging_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Use the results to:
- Rank signals by emergence score (fastest rising first)
- Identify signals that are brand new (little to no historical baseline)
- Flag first-mover signals — high emergence score but still relatively low
  absolute volume (opportunity window is open)
- Note signals that are rising fast but already high volume (momentum, but
  window may be closing)

---

## Step 4: Build the emerging opportunities dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make it visual, colorful,
and focused on growth and momentum. A user should immediately see which signals
are rising and how much runway each one has. Prioritize charts and visual
hierarchy over text blocks and lists.

The artifact must convey:
- Which signals are rising fastest (emergence ranking)
- How new each signal is — brand new vs recently accelerating
- Which signals represent true first-mover opportunities (rising fast + low
  current volume = open window)
- Which signals are already peaking (rising fast + already high volume = late)

Choose chart types that best show growth velocity and opportunity windows —
think growth rate charts, bubble charts plotting volume vs emergence score,
or race-style bar charts. Make the opportunity vs late-mover distinction
visually obvious.

---

## Step 5: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 6: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track these emerging signals
> over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with the emerging signals as trackers,
   grouped by opportunity tier (first-mover / accelerating / peaking)
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

- Always run both tools before building the artifact
- Never show a flat list of signals — the emergence ranking and opportunity
  framing is the whole point
- Make the first-mover vs peaking distinction clear and visual
- Never skip the customization question
- Vocabulary: "demand signals", "emerging demand", "consumer interest" —
  never "keywords", "search volume", "SEO"

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover signals in the space |
| `calculate_emerging_demand` | 3 | Identify fastest-rising signals |
| `create_signal_collection` | 6 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 6 | Attach the HTML artifact |
| `generate_platform_link` | 6 | Link to the live dashboard |