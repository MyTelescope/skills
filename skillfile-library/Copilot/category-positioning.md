# Category Positioning

Answers "How does my brand sit relative to the category?" by mapping the brand's demand signals against the full category demand landscape — showing what share the brand owns, where it clusters, and where significant demand exists that the brand does not currently capture.

---

## Step 1: Understand the request

Extract:
- **Brand** - the brand being positioned
- **Category** - the full category to map against (infer from brand if not stated)
- **Location** - country or region (ask if missing)

Call `get_location_details` to resolve the location ID.

---

## Step 2: Discover category and brand signals

Call `search_signals` to map both the full category demand landscape and the brand's distinct signals.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category variant]", location_id="<id>")
search_signals(query="[brand]", location_id="<id>")
```

Separate results into two pools: category signals (the full landscape) and brand signals (demand specifically directed at the brand). Deduplicate; signals appearing in both pools are overlap between what the brand owns and what the category needs.

---

## Step 3: Measure volume and priorities

Call `get_demand_volume` on all signals combined to get comparable volume numbers.

```
get_demand_volume(
    keywords=["category signals...", "brand signals..."],
    location_id="<id>",
    language_id="<language>"
)
```

Then call `calculate_demand_priorities` on the full combined set:

```
calculate_demand_priorities(
    keywords=["all signals combined"],
    location_id="<id>"
)
```

Calculate: total category demand, brand-owned demand, brand demand share (%), and the high-priority category signals where the brand has no presence. Group the category into 2-5 clusters by theme and calculate the brand's share within each.

---

## Output

Present the positioning table followed by 2-3 key insights.

**Category Positioning — [Brand] in [Category] — [Market] — [Date]**

| Cluster | Category volume | Brand signals in cluster | Brand share in cluster | Gap? |
|---------|-----------------|--------------------------|------------------------|------|
| [e.g. Product features] | 45k | "brand feature X", "brand Y feature" | 18% | No |
| [e.g. Alternatives] | 32k | none | 0% | Yes |
| [e.g. Pricing] | 21k | "brand pricing" | 6% | Yes |
| ... | ... | ... | ... | ... |
| **Total** | **[sum]** | | **[brand share %]** | |

Below the table, state:
- The brand's overall demand share as a percentage of total category demand
- The highest-priority gap (large cluster where the brand has no presence)
- Whether the gaps are in growing or contracting parts of the category

---

## Rules

- Always cover the full category, not just the brand — the point is to show the brand within the category
- Always calculate demand share explicitly as a percentage of total category demand
- Always identify and call out coverage gaps — these are the most actionable output
- Always group category signals into clusters — a flat list does not show position
- Vocabulary: "demand signals", "demand share", "category demand", "consumer interest" - never "keywords", "search volume", "SEO"