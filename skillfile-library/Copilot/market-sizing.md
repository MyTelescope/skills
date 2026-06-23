# Market Sizing

Answers "How big is this category?" by casting wide across the full demand landscape, measuring total volume across all signals, and calculating the relative weight of each segment. Output is a sized market with clear dominance framing showing where demand actually lives.

---

## Step 1: Understand the request

Extract:
- **Category** - the market or space to size
- **Location** - country or region (ask if missing)

Call `get_location_details` to resolve the location ID.

---

## Step 2: Cast wide across the category

Call `search_signals` with multiple queries to surface the full signal set. Market sizing requires breadth — cast wider than necessary to avoid missing significant segments.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category segment A]", location_id="<id>")
search_signals(query="[category segment B]", location_id="<id>")
```

Use 3-5 search queries to cover the space from multiple angles. Deduplicate the results. Aim for 20-60 signals. Group signals into natural market segments before proceeding — 4-8 segments is the right range. Name each segment so it is meaningful (e.g. for "skincare": basic moisturizers, anti-aging, SPF, professional treatments, organic/natural).

---

## Step 3: Calculate demand priorities

Call `calculate_demand_priorities` on the full signal set to understand which signals — and by extension which segments — carry the most weight.

```
calculate_demand_priorities(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Sum the priority weight per segment to get a segment-level dominance score. Rank segments by total demand weight (largest to smallest). Identify which single segment dominates the market and flag any segment that is large but under-served relative to its size.

---

## Output

Present the market sizing table followed by 2-3 key findings.

**Market Sizing — [Category] — [Market] — [Date]**

| Segment | Signal count | Priority weight | Market share | Status |
|---------|-------------|----------------|-------------|--------|
| [Segment 1 — e.g. Anti-aging] | 12 | 38 | 34% | Dominant |
| [Segment 2 — e.g. SPF] | 8 | 24 | 22% | Large |
| [Segment 3 — e.g. Moisturizers] | 15 | 21 | 19% | Large |
| [Segment 4 — e.g. Organic] | 7 | 18 | 16% | Growing |
| [Segment 5 — e.g. Professional] | 5 | 10 | 9% | Niche |
| **Total** | **47** | **111** | **100%** | |

Below the table, state:
- Which segment dominates and what share of total demand it holds
- The second-largest segment and whether it is growing or contracting
- Any segment that is large but appears under-served relative to its size

---

## Rules

- Cast wide — a market sizing that misses a major segment is wrong; run multiple `search_signals` queries
- Always group into segments — showing individual signals without aggregating does not answer "how big is this market?"
- Always rank by dominance — surface the dominant segment clearly and explicitly
- Vocabulary: "demand signals", "consumer interest", "market segments", "demand weight" - never "keywords", "search volume", "SEO"