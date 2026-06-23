# Topic Discovery

Answers "What topics should I be creating content about?" by discovering demand signals in the brand's space, identifying which are rising fastest, and ranking the full set by opportunity score — highest emerging momentum combined with strong volume. Output is a tiered content topic ranking.

---

## Step 1: Understand the request

Extract:
- **Brand or topic space** - the area to find content topics for
- **Location** - country or region (ask if missing)
- **Content type or channel** - if the user mentions a specific format, note it for framing but do not limit topic discovery

Call `get_location_details` to resolve the location ID.

---

## Step 2: Discover signals in the content space

Call `search_signals` with the brand's topic area and 2-3 variations. Cast wide — narrow down by data, not by assumption.

```
search_signals(query="[brand topic]", location_id="<id>")
search_signals(query="[related topic]", location_id="<id>")
search_signals(query="[topic variant]", location_id="<id>")
```

Deduplicate results. Aim for 20-40 signals before scoring — too few signals means the ranking will miss real opportunities.

---

## Step 3: Score for emerging demand

Call `calculate_emerging_demand` on the full signal set to find which topics are rising fastest relative to their baseline.

```
calculate_emerging_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Extract per signal: emergence score (growth velocity relative to baseline) and whether the signal is brand new or recently accelerating.

---

## Step 4: Measure current volume

Call `get_demand_volume` to measure the current absolute consumer interest for all signals.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract per signal: latest monthly volume and YoY trend direction.

---

## Output

Present the tiered content topic ranking followed by 2-3 key insights.

**Topic Discovery — [Brand] — [Market] — [Date]**

| Tier | Topic / signal | Emergence score | Monthly volume | Trend | Why now |
|------|---------------|----------------|---------------|-------|---------|
| 1 - Prime | [signal] | 91 | 18k | Growing | High momentum + established audience |
| 1 - Prime | [signal] | 87 | 12k | Growing | Rising fast, still has runway |
| 2 - Rising bet | [signal] | 83 | 3k | Growing | Building early — get ahead of the trend |
| 2 - Rising bet | [signal] | 76 | 1.8k | Growing | New signal — first-mover window open |
| 3 - Steady staple | [signal] | 42 | 35k | Flat | Consistent demand — good for evergreen |
| 4 - Low priority | [signal] | 18 | 2k | Contracting | Deprioritize |

Opportunity tiers:
- **Tier 1 - Prime**: High emergence + strong volume — top content priority
- **Tier 2 - Rising bets**: High emergence + lower volume — get ahead of the trend
- **Tier 3 - Steady staples**: Lower emergence + strong volume — evergreen content
- **Tier 4 - Low priority**: Low emergence + low volume — deprioritize or skip

Below the table, state:
- The top 3 topics to create now and why
- The best rising bet for getting ahead of an emerging trend
- Any evergreen signal that represents a content gap worth filling

---

## Rules

- Always run all three tools — volume alone does not identify opportunity; emerging demand separates rising topics from established ones
- Always tier the results — a flat ranked list is not actionable
- Never surface only the largest signals — high volume without growth momentum is a saturated topic, not an opportunity
- Vocabulary: "demand signals", "consumer interest", "content topics" - never "keywords", "search volume", "SEO"