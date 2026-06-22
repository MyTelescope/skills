---
name: mytelescope-topic-discovery
description: >
  Use this skill when the user asks what topics to create content about.
  Trigger for: "What topics should I be creating content about?", "What should
  I write about?", "Give me content topics for [brand or category]", "What are
  the best content opportunities in [space]?", "What topics have the most
  demand right now?", "Show me content opportunities in [category]", or any
  request to discover and rank content topics based on real consumer demand and
  growth momentum.
---

# Topic Discovery

## What this skill does

Answers "What topics should I be creating content about?" by discovering demand
signals in the brand's space, identifying which are rising fastest, and ranking
the full set by opportunity score - highest emerging momentum combined with
strong volume. The output is a visual dashboard of content topics ranked by
priority that the user can customize and save to MyTelescope.

The three tools that drive this skill:
- `search_signals` - discovers all signals in the brand's content space
- `calculate_emerging_demand` - identifies which signals are rising fastest
- `get_demand_volume` - measures current consumer interest volume per signal

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand or topic space** - the area to find content topics for
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous
- **Content type or channel** - if the user mentions a specific format (blog,
  social, video), note it for the framing but do not limit the topic discovery

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Discover signals in the content space

Call `search_signals` with the brand's topic area and 2-3 variations to surface
the full range of what consumers are interested in. Cast wide at this stage -
narrow down by data, not by assumption.

```
search_signals(query="[brand topic]", location_id="<id>")
search_signals(query="[related topic]", location_id="<id>")
search_signals(query="[topic variant]", location_id="<id>")
```

Deduplicate results. Aim for 20-40 signals before scoring. Too few signals
means the ranking will miss real opportunities.

---

## Step 3: Score for emerging demand

Call `calculate_emerging_demand` on the full signal set to find which topics
are rising fastest relative to their baseline. This identifies what is building
momentum before it peaks - the optimal window for content investment.

```
calculate_emerging_demand(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>"
)
```

Extract for each signal:
- Emergence score (growth velocity relative to baseline)
- Whether the signal is brand new (no established baseline) or recently
  accelerating (established but growing fast)

---

## Step 4: Measure current volume

Call `get_demand_volume` to measure the current absolute consumer interest
for all signals.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Extract for each signal:
- Latest monthly volume
- YoY trend direction

---

## Step 5: Rank topics by opportunity

Calculate an opportunity score for each signal combining emergence and volume:
- **Tier 1 - Prime opportunities:** High emerging score + strong current volume.
  These topics have momentum and an established audience. Top content priority.
- **Tier 2 - Rising bets:** High emerging score + lower current volume. These
  topics are building. Good for getting ahead of a trend before it peaks.
- **Tier 3 - Steady staples:** Lower emerging score + strong current volume.
  These topics have consistent demand but are not accelerating. Good for
  evergreen content.
- **Tier 4 - Low priority:** Low emerging score + low volume. Deprioritize or
  skip.

Aim to surface 10-20 topics across tiers, with at least 3-5 in Tier 1.

---

## Step 6: Build the topic discovery dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make the opportunity
ranking visual and immediately scannable - a user should be able to pick their
next content topic in seconds. Show tier groupings clearly, volume and growth
direction per topic, and make the Tier 1 topics stand out. Choose chart types
that best show both volume and growth together - bubble charts, ranked bar
charts, or a scored list with visual indicators all work depending on the
signal count.

The artifact must convey:
- The full ranked list of content topics grouped by opportunity tier
- Current consumer interest volume per topic
- Growth direction per topic (rising, flat, or contracting)
- Why each top-tier topic is a priority now

Keep it action-oriented. The user should leave knowing exactly what to create.

---

## Step 7: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 8: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track which topics are
> rising over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with signals grouped by opportunity tier
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always run all three tools.** Volume alone does not identify opportunity -
emerging demand data is required to distinguish rising topics from established
ones. All three tool calls are mandatory.

**Always tier the results.** A flat ranked list of 30 signals is not actionable.
Group into opportunity tiers so the user has a clear prioritization to act on.

**Never surface only the largest signals.** High volume without growth momentum
is a saturated topic, not an opportunity. Emergence score is what separates a
content opportunity from a crowded space.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "consumer interest", "content topics" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover signals in the content space |
| `calculate_emerging_demand` | 3 | Identify fastest-rising topics |
| `get_demand_volume` | 4 | Current volume per topic |
| `create_signal_collection` | 8 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 8 | Attach the HTML artifact |
| `generate_platform_link` | 8 | Link to the live dashboard |