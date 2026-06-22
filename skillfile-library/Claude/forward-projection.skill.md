---
name: mytelescope-forward-projection
description: >
  Use this skill when the user asks where demand is heading or wants to see
  a forecast. Trigger for: "Where is this heading?", "What will demand look
  like in 6 months?", "Will this grow or decline?", "Show me the trajectory
  for [topic]", "Project demand for [category] forward", "What's the outlook
  for [topic] in [market]?", or any request for a forward-looking view of
  demand trajectory with a forecast horizon.
---

# Forward Projection

## What this skill does

Answers "Where is this heading over the next 6 months?" by measuring historical
demand for each signal and then running a 6-month forecast. The output is a
visual dashboard focused on trajectory and forecast confidence, which the user
can customize and save to MyTelescope.

The two tools that drive this skill:
- `get_demand_volume` - pulls historical demand data for each signal
- `forecast_demand` - generates a 6-month projection per signal

---

## Step 1: Understand the request

Extract from the user's message:
- **Topic or signals** - what they want projected
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

If the user has not specified signals, use `search_signals` to discover the most
relevant signals in the space before proceeding, then confirm the signal set
with the user or proceed directly if the topic is clear.

---

## Step 2: Pull historical demand

Call `get_demand_volume` to retrieve the historical monthly time series for all
signals. This data is the baseline the forecast model uses — the longer the
history, the more confident the projection.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract for each signal:
- Full monthly time series (as many months as returned)
- Current volume level
- Recent trend direction (last 3 months vs prior 3 months)

If a signal has fewer than 6 months of history, note it — forecasts on very
short histories carry lower confidence.

---

## Step 3: Generate 6-month forecasts

Call `forecast_demand` for all signals to generate forward projections.

```
forecast_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>",
    periods=6
)
```

Extract for each signal:
- Projected monthly values for each of the 6 forecast months
- Forecast confidence range (upper and lower bounds if returned)
- Overall forecast direction: will this signal grow, flatten, or contract?

Group signals by forecast outcome: growing, flattening, contracting. This
grouping shapes the dashboard framing.

---

## Step 4: Build the forward projection dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make trajectory the visual
focus — the user should see at a glance what is heading up and what is not.
Use line or area charts that show historical data flowing into the forecast
period, with the forecast portion visually distinguished (dashed line, shaded
confidence band, or lighter color). One chart per signal or a multi-series
chart works depending on the number of signals.

The artifact must convey:
- Where each signal is today vs where it is projected to be in 6 months
- The confidence range for each projection
- Which signals have the strongest growth trajectory
- Which signals are projected to flatten or decline

Keep the visual honest — do not make low-confidence forecasts look more certain
than they are.

---

## Step 5: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 6: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how the forecast
> evolves as new data comes in? Just say **save it**."

If yes:
1. Call `create_signal_collection` with the projected signals as trackers
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always pull historical data before forecasting.** `forecast_demand` on its
own does not show the user where the signal has been. Historical context is
required to make the projection meaningful.

**Always distinguish the forecast period visually.** Historical data and
forecast data must look different in the chart. Never render them the same way
— users need to know what is observed vs projected.

**Always show confidence.** If confidence bounds are returned, display them.
If they are not returned, note in the dashboard that forecasts carry inherent
uncertainty.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "trajectory", "forward
projection" — never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 1 | Discover signals if not specified by user |
| `get_demand_volume` | 2 | Historical monthly time series per signal |
| `forecast_demand` | 3 | 6-month forward projection per signal |
| `create_signal_collection` | 6 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 6 | Attach the HTML artifact |
| `generate_platform_link` | 6 | Link to the live dashboard |