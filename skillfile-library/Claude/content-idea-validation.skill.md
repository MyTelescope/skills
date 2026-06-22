---
name: mytelescope-content-idea-validation
description: >
  Use this skill when the user wants to validate whether there is real demand
  for a specific content idea. Trigger for: "Is there actual demand for this
  content idea?", "Will this content idea work?", "Is anyone interested in
  [topic]?", "Should I create content about [idea]?", "Is [topic] worth writing
  about?", "Does this content idea have an audience?", or any request to check
  whether a specific content topic or idea has measurable consumer interest
  before investing in creating it.
---

# Content Idea Validation

## What this skill does

Answers "Is there actual demand for this content idea?" with a direct yes or
no backed by real consumer interest data. Gives the user the monthly volume,
trend direction, and competitive density of the idea's space so they can decide
whether to invest in creating it. Quick and decisive..

The two tools that drive this skill:
- `search_signals` - finds demand signals that match the content idea
- `get_demand_volume` - measures the actual volume and trend for those signals

---

## Step 1: Understand the content idea

Extract from the user's message:
- **The content idea** - the specific topic, angle, or question the content
  would address
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous

If the idea is vague, ask one clarifying question to sharpen it:
> "Just to make sure I find the right signals - is this aimed at [interpretation A]
> or [interpretation B]?"

If location is missing, ask:
> "Which market should I check demand for? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Search for matching demand signals

Call `search_signals` with the core content idea and 1-2 variations to find
signals that match what the content would be about.

```
search_signals(query="[content idea]", location_id="<id>")
search_signals(query="[content idea variant]", location_id="<id>")
```

From the results, identify the signals that best match the content idea. Keep
only semantically relevant matches - discard tangential signals that share a
keyword but represent a different intent.

If no matching signals are found, tell the user directly:
> "I could not find measurable demand signals that match this idea. That is a
> strong signal that consumer interest is very low or does not exist yet."

---

## Step 3: Measure volume and trend

Call `get_demand_volume` on the matching signals to get actual numbers.

```
get_demand_volume(
    keywords=["matching signal 1", "matching signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract:
- Monthly volume for each signal (latest month)
- Total aggregate volume across all matching signals
- YoY trend direction: Growing / Contracting / Flat
- YoY change percentage
- How many strong signals exist (a proxy for how crowded the space is)

---

## Step 4: Make the call

Give a direct verdict. Do not hedge. Use the following thresholds as a guide:

**Yes - clear demand:**
Total aggregate volume is meaningful, trend is Growing or Flat, and there are
clear signals directly matching the idea. State the volume and the growth direction.

**Yes - but niche:**
Volume is low but the trend is strongly Growing. This is a rising space. Worth
creating if the brand wants to be early. State the volume, emphasize the growth
trajectory.

**Marginal - proceed with caution:**
Volume is present but the trend is Contracting. Demand existed but is declining.
Only worth creating if the brand has a specific reason to enter a shrinking space.

**No - insufficient demand:**
Volume is very low or zero signals found. The idea does not have a meaningful
audience yet. Do not invest in creating it unless the brand is intentionally
trying to create the demand category.

---

## Step 5: Build the validation dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact. Make it clean and decisive - the user needs a fast answer.

The artifact must show:
- A large, prominent verdict indicator at the top: Yes / Yes (niche) / Marginal / No - color-coded green, yellow, orange, or red
- Monthly consumer interest volume as a bold number
- Trend direction with a YoY change percentage and a directional arrow
- Signal match quality and competitive density as simple visual indicators
- One-sentence recommendation at the bottom

Keep it tight. This is a quick scorecard, not a deep analysis dashboard.

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always give a direct verdict.** Do not present the data and leave the user
to decide. Make the call and explain it briefly.

**Never pad the report.** If the answer is no, say no clearly and briefly.
Do not soften a negative result with unnecessary caveats or suggestions to
explore other ideas unless the user asks.

**Format volumes correctly.** Use `1.2k` not `1200`. Always include the
YoY change percentage with a sign: `+24%` or `-8%`.

**Vocabulary.** "Demand signals", "consumer interest", "monthly volume" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Find signals matching the content idea |
| `get_demand_volume` | 3 | Volume and trend for matching signals |