# Competitive Demand

Answers "How does my brand compare to competitors?" by measuring demand signals for the user's brand alongside each competitor, then showing who is gaining ground and who is losing it. Output is a comparative ranking with clear winner/loser framing.

---

## Step 1: Understand the request

Extract:
- **Brand** - the user's own brand or product
- **Competitors** - brands to compare against (ask if missing: "Which competitors should I compare against? List up to 5.")
- **Location** - country or region (ask if missing)

Call `get_location_details` to resolve the location ID.

---

## Step 2: Discover signals for each entity

Call `search_signals` separately for the user's brand and for each competitor. Separate calls ensure distinct demand signals per entity rather than conflated results.

```
search_signals(query="[brand]", location_id="<id>")
search_signals(query="[competitor 1]", location_id="<id>")
search_signals(query="[competitor 2]", location_id="<id>")
```

For each entity, keep 3-8 signals that clearly reflect consumer interest in that specific brand or product. Discard generic or ambiguous signals that could apply to multiple entities.

---

## Step 3: Measure volume for all signals together

Call `get_demand_volume` once with all signals across all entities combined. Passing them together ensures numbers are on the same scale and directly comparable.

```
get_demand_volume(
    keywords=["brand signal 1", "brand signal 2", "comp1 signal 1", ...],
    location_id="<id>",
    language_id="<language>"
)
```

For each entity, aggregate volume across its signals to get a total demand figure. Extract: total current demand per entity, 12-month trend direction (Growing / Contracting / Flat), YoY change %, and the momentum leader (growing fastest).

---

## Output

Present the competitive ranking table followed by 2-3 key findings.

**Competitive Demand — [Category] — [Market] — [Date]**

| Rank | Entity | Total demand | Trend | YoY change | Status |
|------|--------|-------------|-------|------------|--------|
| 1 | [Brand A] | 85k | Growing | +24% | Leader |
| 2 | [Brand B] | 62k | Flat | +3% | Holding |
| 3 | [Your brand] | 41k | Growing | +18% | Gaining |
| 4 | [Brand C] | 28k | Contracting | -12% | Losing |

Below the table, state:
- Who is winning (largest total demand) and who has the most momentum (fastest YoY growth)
- Whether the user's brand is gaining or losing relative to each named competitor
- Any competitor growing faster than all others — the momentum threat

---

## Rules

- Always run `search_signals` separately for each entity — searching all brands in one query conflates signals
- Always call `get_demand_volume` once with all signals combined — never call it separately per entity
- Always rank entities — a competitive output without a clear ranking is not useful
- Vocabulary: "demand signals", "consumer interest", "competitive demand" - never "keywords", "search volume", "SEO"