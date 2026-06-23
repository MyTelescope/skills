# Weekly Pulse

Answers "What happened this week?" by reading weekly signal data from an existing collection and surfacing what moved, by how much, and in which direction. Output is a concise weekly movement summary. This workflow reads an existing signal collection — it does not create a new one.

---

## Step 1: Identify the collection

Ask the user which signal collection to read if they have not specified one: "Which collection should I pull the weekly signals for? If you have more than one, let me know which one you want."

If the user is not sure which collections they have, call `list_user_signal_collections` to show them what is available, then ask them to pick one. Once identified, note the collection ID.

---

## Step 2: Fetch weekly signals

Call `get_weekly_signals` with the collection ID.

```
get_weekly_signals(collection_id="<id>")
```

Extract per signal: week-on-week score change (this week vs last week), year-on-year change % (this week vs same week last year), and direction (up, down, or flat). Group signals by movement direction: rising this week, falling this week, flat. Within each group, rank by magnitude of movement.

---

## Step 3: Frame the weekly picture

Identify: the top 3 risers this week (largest positive WoW change), the top 3 fallers this week (largest negative WoW change), any signals with strong YoY change that adds context to the weekly move, and the overall mood (broadly up, broadly down, or mixed).

---

## Output

Present the weekly pulse table followed by 2-3 key takeaways.

**Weekly Pulse — [Collection name] — Week of [date]**

| Signal | WoW change | YoY change | Direction | Notable? |
|--------|-----------|-----------|-----------|---------|
| [Top riser] | +18% | +42% | Up | Yes - biggest mover |
| [Second riser] | +12% | +28% | Up | |
| [Flat signal] | +1% | +8% | Flat | |
| [Faller] | -9% | -14% | Down | |
| [Top faller] | -22% | -31% | Down | Yes - biggest drop |
| ... | ... | ... | ... | |

**Overall direction: [Up / Down / Mixed]**

Below the table, state:
- The biggest riser and what is driving its momentum (YoY context)
- The biggest faller and whether the YoY trend confirms a broader decline
- Whether this was an overall up, down, or mixed week across the collection

---

## Rules

- Never create a new signal collection — this workflow reads an existing one; `create_signal_collection` is not used here
- Always ask which collection if not specified — never guess or default to one
- Always show both WoW and YoY — week-on-week without year-on-year context can be misleading
- Keep it concise — this is a weekly digest, not a deep landscape; prioritize the movers and overall direction
- Vocabulary: "demand signals", "consumer interest", "weekly movement" - never "keywords", "search volume", "SEO"