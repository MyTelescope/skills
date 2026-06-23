# Emerging Opportunities

Answers "What's growing fast in [space]?" by discovering demand signals in the space and identifying which ones are rising fastest — before they peak. Output is a ranked list of emerging signals with opportunity framing that distinguishes first-mover windows from already-peaking trends.

---

## Step 1: Resolve location

Call `get_location_details` to get the location ID. If location is missing, ask: "Which market should I look at? For example: United States, Germany, United Kingdom."

---

## Step 2: Discover signals

Call `search_signals` with the topic and 2-3 variations to surface the full signal set.

```
search_signals(query="[topic]", location_id="<id>")
search_signals(query="[topic variant]", location_id="<id>")
```

Deduplicate results. Aim for 15-40 signals — enough to surface genuine emerging patterns.

---

## Step 3: Calculate emerging demand

Call `calculate_emerging_demand` on the full signal set.

```
calculate_emerging_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Use the results to: rank signals by emergence score (fastest rising first), identify brand-new signals (little to no historical baseline), flag first-mover signals (high emergence + still relatively low absolute volume — opportunity window is open), and note signals rising fast but already at high volume (momentum, but window may be closing).

---

## Output

Present the emerging opportunities table followed by 2-3 key findings.

**Emerging Opportunities — [Topic] — [Market] — [Date]**

| Signal | Emergence score | Current volume | Opportunity tier | Status |
|--------|----------------|---------------|-----------------|--------|
| [signal 1] | 94 | 2.1k | First-mover | Open window |
| [signal 2] | 87 | 18k | Accelerating | Closing window |
| [signal 3] | 71 | 1.2k | First-mover | Open window |
| [signal 4] | 58 | 45k | Peaking | Late mover |
| ... | ... | ... | ... | ... |

Opportunity tiers:
- **First-mover**: High emergence + low volume = window is open
- **Accelerating**: High emergence + growing volume = still valuable but moving fast
- **Peaking**: High emergence + already high volume = late to the trend

Below the table, state:
- The top 2-3 first-mover opportunities and what makes them actionable now
- Any signal that is rising fast but already at high volume (competitive and closing)
- The overall emerging theme across the top signals

---

## Rules

- Always run both tools before output
- Never show a flat list of signals — the emergence ranking and opportunity framing is the whole point
- Make the first-mover vs peaking distinction explicit in every output
- Vocabulary: "demand signals", "emerging demand", "consumer interest" - never "keywords", "search volume", "SEO"