# Marketing Health

Answers "What is the marketing health of this brand?" by measuring demand signals for the brand, the full category, and key competitors in parallel, then building a comparative view of who is growing, who is contracting, and where the brand stands. Output is a health scorecard with category context.

---

## Step 1: Understand the request

Extract:
- **Brand** - the brand under review
- **Competitors** - brands to compare against (ask for up to 3 if not specified: "Which competitors should I include? Name up to 3 brands in the same category.")
- **Location** - country or region (ask if missing)

Call `get_location_details` to resolve the location ID.

---

## Step 2: Discover signals for brand, category, and competitors

Run `search_signals` separately for each entity to build distinct signal sets.

```
search_signals(query="[brand]", location_id="<id>")
search_signals(query="[category]", location_id="<id>")
search_signals(query="[competitor 1]", location_id="<id>")
search_signals(query="[competitor 2]", location_id="<id>")
```

For the category, cast wide — use the broad category term to capture total demand. For each brand and competitor, keep signals that most clearly represent consumer interest in that specific entity.

---

## Step 3: Measure volume and priority across all signals

Call `get_demand_volume` once with all signals combined so numbers are on the same scale.

```
get_demand_volume(
    keywords=["brand signals...", "category signals...", "competitor signals..."],
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

Extract: total aggregated demand per entity, total category demand, demand share for each entity as a percentage of category, YoY trend per entity (Growing / Contracting / Flat), and which entity holds the highest priority signals.

---

## Output

Present the marketing health table followed by 2-3 key findings.

**Marketing Health — [Brand] — [Market] — [Date]**

| Entity | Demand volume | Category share | Trend | YoY change | Status |
|--------|-------------|---------------|-------|------------|--------|
| [Your brand] | 41k | 18% | Growing | +18% | Gaining share |
| [Competitor 1] | 85k | 38% | Growing | +24% | Leader |
| [Competitor 2] | 62k | 28% | Flat | +3% | Holding |
| [Competitor 3] | 28k | 12% | Contracting | -12% | Losing share |
| **Category total** | **224k** | 100% | Growing | +14% | Expanding |

Below the table, state:
- Whether the brand is growing or contracting relative to the category
- Whether the brand is gaining or losing demand share against each named competitor
- Which competitor is the momentum leader and what that means for the brand

---

## Rules

- Always include category signals — brand health without category context is incomplete
- Always call `get_demand_volume` with all signals in one call — separate calls produce non-comparable numbers
- Always frame growth direction before presenting data — know whether the brand is gaining or losing
- A brand growing in a contracting category is a different story from a brand contracting in a growing category — always call this out
- Vocabulary: "demand signals", "demand share", "consumer interest" - never "keywords", "search volume", "SEO"