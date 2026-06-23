# Content Calendar

Answers "Build me a 90-day content calendar" by pulling priority demand signals and emerging signals, then mapping them to a sequenced 90-day schedule. High-priority stable signals fill evergreen slots; rising emerging signals fill timely slots timed to their momentum.

---

## Step 1: Understand the request

Extract:
- **Brand or topic space** - the area to plan content for
- **Location** - country or region (ask if missing)
- **Start date** - when the 90-day window begins (default to today if not specified)
- **Content cadence** - pieces per week (ask if not specified, default to 3)

Call `get_location_details` to resolve the location ID.

---

## Step 2: Discover signals in the brand's space

Call `search_signals` to map the demand landscape the calendar will draw from.

```
search_signals(query="[brand topic]", location_id="<id>")
search_signals(query="[related topic]", location_id="<id>")
```

Aim for 20-40 signals before scoring. These become the raw material for both evergreen and timely content slots.

---

## Step 3: Calculate priorities and emerging demand

Call `calculate_demand_priorities` to identify high-priority stable signals:

```
calculate_demand_priorities(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Call `calculate_emerging_demand` to identify rising signals:

```
calculate_emerging_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Sort signals into two pools: **Evergreen** (high priority, stable or growing — content that remains relevant over time) and **Timely** (high emergence, rising momentum — trend-responsive content timed to consumer interest peaks).

---

## Step 4: Sequence the 90-day calendar

Map signals to weeks: Weeks 1-4 anchor with top 3-4 evergreen signals. Weeks 5-8 introduce timely signals as the first wave of trend-responsive content, mixed with ongoing evergreen slots. Weeks 9-12 surface remaining emerging signals timed to their momentum peaks, then reintroduce top evergreen signals. Apply the user's content cadence to distribute slots accordingly.

---

## Output

Present the 90-day schedule as a week-by-week table.

**Content Calendar — [Brand] — [Market] — [Start Date]**

| Week | Date range | Topic / signal | Type | Suggested angle | Demand rationale |
|------|-----------|---------------|------|-----------------|-----------------|
| 1 | [dates] | [signal name] | Evergreen | [angle] | [volume + trend] |
| 2 | [dates] | [signal name] | Evergreen | [angle] | [volume + trend] |
| 3 | [dates] | [signal name] | Timely | [angle] | [emergence score, rising] |
| ... | ... | ... | ... | ... | ... |

Below the table, state:
- How many evergreen vs timely slots are in the calendar
- The highest-opportunity timely topic and when to publish it
- Any signal whose demand peaks in a specific month — note the ideal publish window

---

## Rules

- Always run both scoring tools — priority fills evergreen slots, emerging data fills timely slots
- Always sequence the calendar — a flat list of topics is not a calendar
- Evergreen first — do not front-load timely signals; establish core content territory in weeks 1-4
- Vocabulary: "demand signals", "consumer interest", "content topics" - never "keywords", "search volume", "SEO"