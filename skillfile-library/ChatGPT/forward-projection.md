# Forward Projection

Answers "Where is this heading over the next 6 months?" by measuring historical demand for each signal and then running a 6-month forecast. Output is a trajectory view showing where each signal is today vs where it is projected to be, with confidence context.

---

## Step 1: Understand the request

Extract:
- **Topic or signals** - what to project
- **Location** - country or region (ask if missing)

Call `get_location_details` to resolve the location ID. If the user has not specified signals, use `search_signals` to discover the most relevant signals in the space before proceeding.

---

## Step 2: Pull historical demand

Call `get_demand_volume` to retrieve the historical monthly time series for all signals. This data is the baseline the forecast model uses.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract per signal: full monthly time series, current volume level, and recent trend direction (last 3 months vs prior 3 months). Note any signal with fewer than 6 months of history — forecasts on very short histories carry lower confidence.

---

## Step 3: Generate 6-month forecasts

Call `forecast_demand` for all signals.

```
forecast_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>",
    periods=6
)
```

Extract per signal: projected monthly values for each of the 6 forecast months, confidence range (upper and lower bounds if returned), and overall forecast direction (growing, flattening, or contracting). Group signals by forecast outcome.

---

## Output

Present the forward projection table followed by 2-3 key insights.

**Forward Projection — [Topic] — [Market] — [Date]**

| Signal | Current volume | 6-month projection | Direction | Confidence | Change |
|--------|---------------|-------------------|-----------|------------|--------|
| [signal 1] | 28k | 38k | Growing | High | +36% |
| [signal 2] | 15k | 14k | Flattening | Medium | -7% |
| [signal 3] | 8k | 12k | Growing | Low | +50% |
| ... | ... | ... | ... | ... | ... |

The historical period should be visually or textually distinguished from the projected period — make clear what is observed data vs forecast.

Below the table, state:
- Which signal has the strongest growth trajectory over 6 months
- Which signals are projected to flatten or decline
- Any low-confidence forecasts the user should treat as directional only

---

## Rules

- Always pull historical data before forecasting — historical context is required to make the projection meaningful
- Always distinguish historical data from forecast data clearly in the output
- Always show confidence — if confidence bounds are returned, include them; if not, note inherent uncertainty
- Vocabulary: "demand signals", "consumer interest", "trajectory", "forward projection" - never "keywords", "search volume", "SEO"