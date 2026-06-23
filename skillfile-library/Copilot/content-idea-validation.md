# Content Idea Validation

Answers "Is there actual demand for this content idea?" with a direct yes or no backed by real consumer interest data. Gives the user the monthly volume, trend direction, and competitive density of the idea's space so they can decide whether to invest in creating it.

---

## Step 1: Understand the content idea

Extract:
- **The content idea** - the specific topic, angle, or question the content would address
- **Location** - country or region (ask if missing)

If the idea is vague, ask one clarifying question: "Just to make sure I find the right signals — is this aimed at [interpretation A] or [interpretation B]?"

Call `get_location_details` to resolve the location ID.

---

## Step 2: Search for matching demand signals

Call `search_signals` with the core content idea and 1-2 variations.

```
search_signals(query="[content idea]", location_id="<id>")
search_signals(query="[content idea variant]", location_id="<id>")
```

Keep only semantically relevant matches — discard tangential signals that share a keyword but represent a different intent. If no matching signals are found, tell the user directly: "I could not find measurable demand signals that match this idea. That is a strong signal that consumer interest is very low or does not exist yet."

---

## Step 3: Measure volume and trend

Call `get_demand_volume` on the matching signals.

```
get_demand_volume(
    keywords=["matching signal 1", "matching signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract: monthly volume (latest month), total aggregate volume, YoY trend (Growing / Contracting / Flat), YoY change %, and how many strong signals exist (proxy for competitive density).

---

## Output

Present the verdict and supporting data as a concise scorecard.

**Content Idea Validation — "[Idea]" — [Market] — [Date]**

**Verdict: [Yes / Yes (niche) / Marginal / No]**

| Signal | Monthly volume | YoY trend | YoY change |
|--------|---------------|-----------|------------|
| [signal 1] | 12k | Growing | +28% |
| [signal 2] | 8k | Growing | +15% |
| [signal 3] | 3k | Flat | +2% |
| **Total** | **23k** | **Growing** | **+21%** |

Verdict thresholds:
- **Yes** - meaningful aggregate volume, Growing or Flat trend, clear signal matches
- **Yes (niche)** - low volume but strongly Growing — rising space, worth creating early
- **Marginal** - volume present but Contracting — demand exists but is declining
- **No** - very low or zero signals — no meaningful audience yet

Close with a one-sentence recommendation.

---

## Rules

- Always give a direct verdict — do not present data and leave the user to decide
- Never pad the report — if the answer is no, say so clearly and briefly
- Format volumes correctly: use `1.2k` not `1200`, always include YoY sign: `+24%` or `-8%`
- Vocabulary: "demand signals", "consumer interest", "monthly volume" - never "keywords", "search volume", "SEO"