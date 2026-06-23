# Demand Landscape

Answers "What's happening in [topic] in [location]?" by discovering all demand signals in the space, measuring their size, and ranking them by priority. Output is a prioritized landscape the user can read at a glance.

---

## Step 1: Understand the request

Extract:
- **Topic** - the market, category, or subject to explore
- **Location** - country or region (ask if missing: "Which market should I look at? For example: United States, Germany, United Kingdom.")

Call `get_location_details` to resolve the location ID and confirm which data sources are available.

---

## Step 2: Discover what exists

Call `search_signals` with the topic and 2-3 variations to surface the full landscape.

```
search_signals(query="[topic]", location_id="<id>")
search_signals(query="[topic variant]", location_id="<id>")
```

Deduplicate results. Group signals into natural clusters by theme or intent (e.g. for "weight loss": medication signals, diet signals, exercise signals, surgery signals). If `search_signals` returns fewer than 5 signals, broaden the query. If it returns more than 40, filter to the most semantically relevant.

---

## Step 3: Measure signal size

Call `get_demand_volume` for all discovered signals.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract per signal: latest monthly volume, 12-month trend direction (Growing / Contracting / Flat), and YoY change %. Drop any signal that returns no volume data.

---

## Step 4: Calculate priorities

Call `calculate_demand_priorities` on the full signal set.

```
calculate_demand_priorities(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Use priority scores to rank signals within each cluster, identify the top 3 priority signals across the full landscape, and flag any high-priority signals that are also fast-growing (opportunity signals).

---

## Output

Present the landscape table followed by 2-3 key insights.

**Demand Landscape — [Topic] — [Market] — [Date]**

| Signal | Cluster | Monthly volume | Trend | YoY change | Priority | Opportunity? |
|--------|---------|---------------|-------|------------|----------|--------------|
| [signal 1] | [cluster] | 45k | Growing | +32% | High | Yes |
| [signal 2] | [cluster] | 28k | Flat | +4% | High | No |
| [signal 3] | [cluster] | 12k | Contracting | -11% | Low | No |
| ... | ... | ... | ... | ... | ... | ... |

Below the table, state:
- The top 3 priority signals and why they matter most
- The biggest opportunity signal (high priority + fast growing)
- Which cluster dominates total demand in this space

---

## Rules

- Always run all three tools — volume and priority data are required before any output
- Never show signals with no volume data — drop them silently
- Always group into clusters — 3-6 clusters is the right range; a flat list is not a landscape
- Vocabulary: "demand signals", "consumer interest", "demand landscape", "signal clusters" - never "keywords", "search volume", "SEO"