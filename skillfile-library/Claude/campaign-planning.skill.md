---
name: mytelescope-campaign-planning
description: >
  Use this skill when the user asks to plan a campaign for a product or brand.
  Trigger for: "Plan a campaign for this product", "Help me plan a campaign for
  [brand]", "Build a campaign plan for [product launch]", "What should my
  campaign look like for [objective]?", "Create a campaign strategy for [brand]",
  or any request to produce a structured campaign plan grounded in real demand
  data and competitive messaging intelligence. This skill audits what competitors
  own before recommending territories.
---

# Campaign Planning

## What this skill does

Answers "Plan a campaign for this product" by auditing competitor messaging
and active campaigns, then cross-referencing with demand data to validate
message-market fit. The output is a structured campaign plan document - channel
selection, validated message territories, timing grounded in demand seasonality,
and what competitors already own so you know what to avoid..

The four tools that drive this skill:
- `web_search` + `web_fetch` - audits competitor messaging and active campaigns
- `search_signals` - discovers demand signals in the product's category
- `get_demand_volume` - validates message-market fit with real volume and seasonality data

---

## Step 1: Understand the request

Extract from the user's message:
- **Product or brand** - what the campaign is for
- **Campaign objective** - what the campaign should achieve (awareness, conversion,
  retention, launch). Ask if not specified.
- **Target audience** - who the campaign is talking to. Ask if not specified.
- **Competitors** - brands to audit for messaging and positioning (ask for up to
  4 if not specified)
- **Location** - country or region (ask if missing)
- **Timeline** - campaign duration or flight window (ask if not specified)

If objective is missing, ask:
> "What should this campaign achieve - brand awareness, product launch, driving
> conversions, or something else?"

If location is missing, ask:
> "Which market is this campaign running in? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Audit competitor messaging and campaigns

For each competitor, use `web_search` to find their current messaging, active
campaigns, and recent advertising activity.

```
web_search(query="[competitor] campaign [year] advertising")
web_search(query="[competitor] [product category] messaging positioning")
web_search(query="[competitor] [campaign] [channel] ad")
```

For the most relevant results, call `web_fetch` to read the full content rather
than relying on snippets.

For each competitor, extract:
- The core campaign message or tagline currently running
- The channel mix they appear to be investing in
- The audience they are talking to explicitly
- Any seasonal or product-led campaign activity
- What they are not saying - notable gaps in their messaging

Build a messaging map: which territories each competitor has claimed, and how
loudly. This is the occupied ground the campaign must navigate around or
directly challenge.

---

## Step 3: Discover demand signals for the product category

Call `search_signals` with the product category and relevant variants to find
what consumers are actually looking for.

```
search_signals(query="[product category]", location_id="<id>")
search_signals(query="[product use case]", location_id="<id>")
```

Then call `get_demand_volume` to understand both the volume and the seasonality
of each signal.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

From the volume data, extract:
- Which signals have the highest current consumer interest
- Monthly volume patterns across the year - when does demand peak and trough?
- YoY trend direction per signal
- Which signals best match the campaign's intended message territory

Use the monthly patterns to identify the optimal campaign timing window:
when is consumer demand highest for the product's benefit territory?

---

## Step 4: Validate message-market fit

Cross-reference the intended campaign message against the demand data:
- Is there real consumer interest in the message territory the campaign wants
  to own?
- Which signals from the demand data most closely match the proposed message?
  What is their combined volume?
- Is this territory growing or contracting in consumer interest?
- Does any competitor already own this territory loudly?

A message territory is well-validated if it has: strong demand signals, a
growing or stable trend, and no competitor clearly owns it. A territory with
all three is the optimal play. Surface any message territories that fail one
or more criteria and explain the risk.

---

## Step 5: Build the campaign plan

Deliver a structured document with the following sections:

**Campaign objective**
One sentence restating what the campaign must achieve, grounded in the brief.

**Message territories**
2-3 validated territories the campaign can choose from. For each, state: the
territory name, the demand evidence supporting it (signals and volumes), and
whether a competitor owns it or not. Recommend which territory to lead with
and why.

**What to avoid**
Territories already owned by a competitor clearly and loudly. Name the
competitor and the territory. Do not enter owned ground without a compelling
reason.

**Recommended channels**
3-4 channels with a one-sentence rationale for each. Base channel selection
on where the audience for this category is most active and on what the
competitor audit shows in terms of their channel investments.

**Campaign timing**
Recommended launch window and flight duration grounded in the demand
seasonality data. If consumer interest peaks in a specific month, the campaign
should be live before that peak builds, not after it crests.

**Consumer language**
The actual phrases from the demand signal names that the campaign copy should
use. These are the words consumers use when expressing interest - the creative
should echo them, not replace them with invented language.

---

## Step 6: Build the campaign dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make it visual and campaign-ready.

The artifact must show:
- Top 2-3 message territories with their demand evidence, color-coded by strength
- A channel mix visual showing recommended channels and rationale
- A timing bar or calendar view showing when consumer demand peaks across the year, with the recommended campaign window highlighted
- A "what to avoid" section showing competitor-owned territories

A user should be able to brief a creative team from this dashboard.

---

## Step 7: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 8: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always audit competitors before recommending territories.** A message territory
recommendation without knowing what competitors own is a guess. The audit is
mandatory.

**Always ground timing in demand seasonality.** Campaign timing based on gut
feel or budget cycles is not enough when the demand data shows when consumers
peak. Always check the monthly volume patterns before recommending a launch window.

**Validate every message territory against both demand data and competitor
positioning.** A territory needs both real consumer interest AND competitive
white space to qualify as a recommendation.

**Never invent competitor activity.** Only report what the web search and
fetch results actually show. If a competitor's campaign activity is unclear,
say so.

**Vocabulary.** "Demand signals", "consumer interest", "message-market fit" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `web_search` | 2 | Find competitor messaging and active campaigns |
| `web_fetch` | 2 | Read competitor content in full |
| `search_signals` | 3 | Discover demand signals in the product category |
| `get_demand_volume` | 3 | Volume, trend, and seasonality per signal |