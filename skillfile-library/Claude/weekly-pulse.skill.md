---
name: mytelescope-weekly-pulse
description: >
  Use this skill when the user asks about what happened this week, wants to
  see their weekly signals, or asks for a weekly update on a signal collection.
  Trigger for: "What happened this week?", "Show me my weekly signals",
  "How did my signals move this week?", "Give me a weekly update", "What moved
  this week in [collection]?", or any request for a week-on-week view of
  signal movement from an existing collection. This skill reads an existing
  signal collection — it does not create a new one.
---

# Weekly Pulse

## What this skill does

Answers "What happened this week?" by reading weekly signal data from an
existing collection and surfacing what moved, by how much, and in which
direction. The output is a visual weekly movement dashboard the user can
optionally save as an artifact.

The one tool that drives this skill:
- `get_weekly_signals` - retrieves week-on-week scores and year-on-year changes for a collection

Note: this skill does NOT create a new signal collection. It reads from one
that already exists. The create/save collection flow is skipped entirely.

---

## Step 1: Identify the collection

Ask the user which signal collection to read if they have not specified one:
> "Which collection should I pull the weekly signals for? If you have more
> than one, let me know which one you want."

If the user is not sure which collections they have, call
`list_user_signal_collections` to show them what is available, then ask them
to pick one.

Once identified, note the collection ID — this is required for
`get_weekly_signals`.

---

## Step 2: Fetch weekly signals

Call `get_weekly_signals` with the collection ID to retrieve the latest weekly
data.

```
get_weekly_signals(collection_id="<id>")
```

From the response, extract for each signal:
- Week-on-week score change (this week vs last week)
- Year-on-year change % (this week vs same week last year)
- Direction: up, down, or flat
- Any signals flagged as notable movers (largest WoW movement in either direction)

Group signals by movement direction: rising this week, falling this week, flat.
Within each group, rank by magnitude of movement.

---

## Step 3: Frame the weekly picture

Before building, identify:
- The top 3 risers this week (largest positive WoW change)
- The top 3 fallers this week (largest negative WoW change)
- Any signals with strong YoY change that adds context to the weekly move
- The overall mood of the week: was it a broadly up week, a broadly down week,
  or mixed?

This framing shapes the dashboard headline and how the data is presented.

---

## Step 4: Build the weekly pulse dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make weekly movement the
visual focus — the user should see at a glance what moved and how much. Use
bar charts with positive/negative coloring to show WoW changes, and include
a secondary view of YoY context so the weekly move reads against a longer
baseline.

The artifact must convey:
- What rose most this week and by how much
- What fell most this week and by how much
- YoY context for each notable mover
- The overall direction of the week — is demand broadly up or broadly down

Keep it punchy. This is a weekly update, not a deep analysis. The user should
be able to read it in under 30 seconds.

---

## Step 5: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 6: Offer to save the artifact

After customization (or after the user declines changes), offer to save just
the artifact:

> "Want me to save this week's snapshot? Just say **save it** and I'll
> attach it to your collection."

If yes, call `save_dashboard_artifact` with the final HTML artifact and the
collection ID. Do NOT call `create_signal_collection` — the collection already
exists. Do NOT call `generate_platform_link` unless the save returns a new link.

---

## Hard rules

**Never create a new signal collection.** This skill reads an existing one.
`create_signal_collection` is not used here under any circumstance.

**Always ask which collection if not specified.** Never guess or default to
a collection without the user confirming it.

**Always show both WoW and YoY.** Week-on-week without year-on-year context
can be misleading. Always include both dimensions.

**Keep it concise.** This is a weekly digest, not a deep landscape. Prioritize
the movers and the overall direction — do not include every signal if the
collection is large.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "weekly movement" —
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `list_user_signal_collections` | 1 | List available collections if user is unsure |
| `get_weekly_signals` | 2 | Retrieve WoW scores and YoY changes for the collection |
| `save_dashboard_artifact` | 6 | Save the weekly snapshot artifact (no new collection) |