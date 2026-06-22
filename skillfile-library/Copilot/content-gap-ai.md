# Content Gap Analysis for AI Citation

Identifies which content a brand should create to improve its AI visibility. Combines real consumer demand data with AI citation gaps to produce a prioritised list of content opportunities.

---

## Step 1: Understand the context

Extract:
- **Brand** - the company or product
- **Category** - the space it operates in
- **Location** - country or region (ask if missing)
- **Prior audit findings** - if a brand-presence-ai or bot-access-audit was already run in this conversation, use those findings directly

If location is missing, ask: "Which market should I focus on?"

Call `get_location_details` to resolve the location ID.

---

## Step 2: Discover demand signals

Call `search_signals` with the brand's category to find what consumers are actively searching for.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category variant]", location_id="<id>")
```

Group signals by intent cluster: awareness, comparison, problem, feature, pricing.

---

## Step 3: Measure demand volume

Call `get_demand_volume` on the discovered signals.

```
get_demand_volume(keywords=[...], location_id="<id>", language_id="<language>")
```

Extract: monthly volume, trend direction (Growing / Flat / Contracting), YoY change %.

---

## Step 4: Map demand to AI citation gaps

For each signal cluster, assess:
- Is there measurable consumer demand? (from Step 3)
- Is the brand cited when AI answers this topic? (from prior audit or general knowledge)
- Does the brand have content that AI could cite for this topic?

Assign each signal: Demand level (High / Med / Low) + AI gap (Gap / Partial / Covered) + Content exists (Yes / No / Weak).

---

## Step 5: Output

Present a prioritised table (highest demand + biggest gap first), then 2-3 takeaways.

**Content Gap Report — [Brand] — [Market] — [Date]**

| Topic | Monthly demand | Trend | AI gap | Content exists | Priority | Recommended content type |
|-------|---------------|-------|--------|----------------|----------|--------------------------|
| [Topic] | 12k | +24% Growing | Gap | No | High | Comparison page |
| [Topic] | 8k | Flat | Partial | Weak | Medium | FAQ / how-to |
| [Topic] | 3k | +180% Growing | Gap | No | High | Dedicated landing page |

Below the table, state:
- The single highest-impact content piece to create first
- Which intent cluster has the biggest overall gap
- Whether the gap is a content problem or a technical visibility problem (blocked crawlers, no structured data)

---

## Rules

- Always rank by opportunity score: demand + gap, not demand alone
- Always explain why AI is missing the brand for each recommendation
- Never invent demand data - only use figures from get_demand_volume
- Vocabulary: "demand signals", "consumer interest", "AI citation gap" - never "keywords", "SEO", "search volume"