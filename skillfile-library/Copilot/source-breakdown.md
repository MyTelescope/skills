# Source Breakdown

Shows where consumer demand for a topic is coming from across platforms (Google, YouTube, Amazon, and others available for the market). Compares volume and trend per source so the user knows where to focus.

---

## Step 1: Resolve location and available sources

Extract:
- **Topic** - what to analyse
- **Location** - country or region (ask if missing)

If location is missing, ask: "Which market should I look at?"

Call `get_location_details` to get the location ID and the list of data sources available for that market. Only use sources returned for this location - never assume a source exists.

---

## Step 2: Measure demand per source

Call `get_demand_volume` separately for each available source, passing the same topic signals each time.

```
get_demand_volume(keywords=[...], location_id="<id>", language_id="<language>", source="google")
get_demand_volume(keywords=[...], location_id="<id>", language_id="<language>", source="youtube")
```

Repeat for every available source. Extract per source: total volume, trend direction, YoY change %, monthly time series.

---

## Step 3: Build the comparison picture

Before outputting:
- Rank sources by total volume
- Calculate each source's share of total cross-platform demand
- Identify the fastest-growing source for this topic
- Flag any source where demand is contracting

---

## Step 4: Output

Present a markdown table followed by 2-3 key takeaways.

**Source Breakdown — [Topic] — [Market] — [Date]**

| Platform | Monthly volume | Share of total | Trend | YoY change |
|----------|---------------|----------------|-------|------------|
| Google | 45k | 62% | Growing | +18% |
| YouTube | 21k | 29% | Growing | +34% |
| Amazon | 6k | 8% | Flat | +2% |

Below the table, state:
- Which platform dominates and whether that is changing
- The fastest-growing platform and what it means for where to invest
- Any platform showing decline and whether that is category-wide or platform-specific

---

## Rules

- Always call `get_location_details` first - available sources vary by market
- Always call `get_demand_volume` separately per source - never aggregate in a single call
- Only show sources that returned data - omit silently if no volume found
- Vocabulary: "demand signals", "consumer interest", "platforms", "sources" - never "keywords", "SEO", "search volume"