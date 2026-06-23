# Cross-Market Comparison

Answers "How does this perform across markets?" by running the same demand signals through each specified market and comparing results side by side. Output is a market-by-market comparison that makes geographic differences immediately clear.

---

## Step 1: Understand the request

Extract:
- **Topic or signals** - what to compare across markets
- **Markets** - the countries or regions to compare (ask if fewer than 2 specified: "Which markets should I compare? For example: France, Germany, United Kingdom.")

Aim for 2-6 markets. If the user lists more than 6, ask which 4-6 matter most.

Call `get_location_details` for each market to resolve the location ID and confirm which data sources are available per market.

---

## Step 2: Align signals across markets

If the user has specified signals, use them. If not, run `search_signals` on the primary market to discover relevant signals:

```
search_signals(query="[topic]", location_id="<primary market id>")
```

Use the same signal set across all markets — this is what makes the comparison valid. Do not use different signals per market. Settle on 5-15 signals.

---

## Step 3: Measure demand per market

Call `get_demand_volume` separately for each market, passing the same signal set each time.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<market 1 id>",
    language_id="<market 1 language>"
)
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<market 2 id>",
    language_id="<market 2 language>"
)
```

Repeat for each market. Extract per market: total demand volume across all signals, 12-month trend direction, and YoY change %.

---

## Output

Present the cross-market comparison table followed by 2-3 key findings.

**Cross-Market Comparison — [Topic] — [Date]**

| Signal | [Market 1] | [Market 2] | [Market 3] | Leader |
|--------|-----------|-----------|-----------|--------|
| [signal 1] | 18k | 9k | 24k | Market 3 |
| [signal 2] | 12k | 7k | 11k | Market 1 |
| ... | ... | ... | ... | ... |
| **Total** | **[sum]** | **[sum]** | **[sum]** | |
| **Trend** | Growing +14% | Flat +2% | Growing +31% | |

Below the table, state:
- Which market leads in total demand and which is growing fastest
- Any market where demand is contracting while others are growing (key divergence)
- Any signal that dominates in one market but not others — where the pattern differs

---

## Rules

- Always call `get_location_details` for every market — location IDs and available sources differ
- Always use the same signal set across all markets — the comparison is only valid if identical
- Always call `get_demand_volume` separately per market — do not combine markets in a single call
- Always account for language — pass the correct language ID for each call
- Vocabulary: "demand signals", "consumer interest", "markets", "geographies" - never "keywords", "search volume", "SEO"