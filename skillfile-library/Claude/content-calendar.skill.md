---
name: mytelescope-content-calendar
description: >
  Use this skill when the user asks for a content calendar or content schedule.
  Trigger for: "Build me a 90-day content calendar", "Create a content schedule
  for [brand]", "Plan content for the next 3 months", "Give me a content
  roadmap for [quarter]", "Schedule content topics for [period]", or any
  request to map content topics to a time-based schedule grounded in demand
  data. This skill sequences content across a 90-day window by matching signal
  type to slot type.
---

# Content Calendar

## What this skill does

Answers "Build me a 90-day content calendar" by pulling priority demand signals
and emerging signals for the brand's space, then mapping them to a sequenced
90-day schedule. High-priority stable signals fill evergreen slots. Rising
emerging signals fill timely slots timed to their momentum. The output is a
visual 90-day calendar artifact the user can customize and save to MyTelescope.

The two tools that drive this skill:
- `calculate_demand_priorities` - surfaces the high-priority stable signals that should anchor evergreen content
- `calculate_emerging_demand` - identifies rising signals that should fill timely, trend-responsive slots

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand or topic space** - the area to plan content for
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous
- **Start date** - when the 90-day window begins (default to today if not specified)
- **Content cadence** - how many pieces per week (ask if not specified, default to 3)
- **Channels or formats** - any specific channel constraints (optional, does not limit discovery)

If location is missing, ask:
> "Which market should I plan content for? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Discover signals in the brand's space

Call `search_signals` to map the demand landscape the calendar will draw from.

```
search_signals(query="[brand topic]", location_id="<id>")
search_signals(query="[related topic]", location_id="<id>")
```

Aim for 20-40 signals before scoring. These become the raw material for
both the evergreen and timely content slots.

---

## Step 3: Calculate priorities and emerging demand

Run both scoring tools on the full signal set.

Call `calculate_demand_priorities` to identify the high-priority signals that
represent stable, consistently high consumer interest:

```
calculate_demand_priorities(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Call `calculate_emerging_demand` to identify the rising signals whose momentum
makes them well-suited for timely, trend-responsive content:

```
calculate_emerging_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

From the combined results, sort signals into two pools:
- **Evergreen signals** - high priority score, stable or growing demand. Suitable
  for content that will remain relevant and drive steady traffic over time.
- **Timely signals** - high emergence score, rising momentum. Suitable for
  trend-responsive content timed to the peak of consumer interest.

---

## Step 4: Sequence the 90-day calendar

Map signals to weeks using the following logic:

- Weeks 1-4: Anchor the calendar with the top 3-4 evergreen signals. Establish
  the brand's core content territory before riding emerging trends.
- Weeks 5-8: Introduce timely signals as the first wave of trend-responsive
  content. Mix with ongoing evergreen slots.
- Weeks 9-12: Surface remaining emerging signals timed to where their momentum
  curves suggest peak consumer interest. Reintroduce top evergreen signals for
  sustained presence.

If the user specified a content cadence (e.g. 3 pieces per week), distribute
accordingly. For a 90-day, 3-per-week cadence that gives approximately 36-39
content slots. Fill each slot with a signal, a suggested angle, and the
rationale (volume + growth direction) for why it is scheduled when it is.

---

## Step 5: Build the content calendar artifact

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact. Make it look like an actual calendar -
weeks laid out in sequence, topics mapped to specific slots, color-coded to
distinguish evergreen (stable) from timely (emerging) content. Each topic entry
should show the signal name, the suggested content angle, and the demand
rationale in brief.

The artifact must convey:
- The full 90-day schedule week by week
- Which slots are evergreen and which are timely
- The demand rationale for each topic (volume and growth direction)
- A clear visual distinction between content types

Keep it practical. This is a working planning tool, not a data visualization.

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how these topics
> perform as you publish? Just say **save it**."

If yes:
1. Call `create_signal_collection` with signals grouped by type - evergreen
   signals as one tracker group, emerging/timely signals as another
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always run both scoring tools.** Priority alone does not build a calendar -
it fills only the evergreen slots. Emerging demand data is needed to identify
the timely, trend-responsive content opportunities.

**Always sequence the calendar.** A flat list of topics is not a calendar. The
whole value of this skill is in the sequencing logic: which topics go when and
why.

**Evergreen first.** Do not front-load timely signals. Establish the core
content territory in weeks 1-4 before introducing emerging trend content.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "content topics" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover signals in the brand's content space |
| `calculate_demand_priorities` | 3 | Identify high-priority stable signals for evergreen slots |
| `calculate_emerging_demand` | 3 | Identify rising signals for timely slots |
| `create_signal_collection` | 7 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 7 | Attach the HTML artifact |
| `generate_platform_link` | 7 | Link to the live dashboard |