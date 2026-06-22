---
name: mytelescope-marketing-health
description: >
  Use this skill when the user asks about the marketing health or demand
  standing of a brand. Trigger for: "What is the marketing health of this
  brand?", "How is [brand] performing in demand?", "Is [brand] growing or
  declining?", "How does [brand] compare to the market and competitors?",
  "Show me how [brand] is doing vs the category", or any request to assess a
  brand's demand health relative to its category and competitive set. This
  skill compares the brand, category, and competitors side by side.
---

# Marketing Health

## What this skill does

Answers "What is the marketing health of this brand?" by measuring demand
signals for the brand, the full category, and key competitors in parallel, then
building a comparative view of who is growing, who is contracting, and where
the brand stands. The output is a visual dashboard the user can customize and
save to MyTelescope.

The three tools that drive this skill:
- `search_signals` - discovers demand signals for the brand, category, and competitors
- `get_demand_volume` - measures volume and trend for all signals together
- `calculate_demand_priorities` - surfaces what matters most across the full landscape

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand** - the brand under review
- **Competitors** - brands to compare against (ask for up to 3 if not specified)
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous

If competitors are missing, ask:
> "Which competitors should I include? Name up to 3 brands in the same category."

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Discover signals for brand, category, and competitors

Run `search_signals` separately for each entity to build distinct signal sets.

```
search_signals(query="[brand]", location_id="<id>")
search_signals(query="[category]", location_id="<id>")
search_signals(query="[competitor 1]", location_id="<id>")
search_signals(query="[competitor 2]", location_id="<id>")
```

For the category, cast wide - use the broad category term to capture the total
demand landscape, not just branded signals. For each brand and competitor, keep
the signals that most clearly represent consumer interest in that specific entity.

---

## Step 3: Measure volume and priority across all signals

Call `get_demand_volume` once with all signals combined so the numbers are on
the same scale and directly comparable.

```
get_demand_volume(
    keywords=["brand signals...", "category signals...", "competitor signals..."],
    location_id="<id>",
    language_id="<language>"
)
```

Then call `calculate_demand_priorities` on the full combined signal set to
understand relative importance.

```
calculate_demand_priorities(
    keywords=["all signals combined"],
    location_id="<id>"
)
```

Extract:
- Total aggregated demand per entity (brand, each competitor)
- Total category demand
- Demand share: each entity's volume as a percentage of total category demand
- YoY trend direction per entity: Growing / Contracting / Flat
- Which entity holds the highest priority signals

---

## Step 4: Frame the health picture

Before building, assess:
- Is the brand growing or contracting relative to the category?
- Is the brand gaining or losing demand share against each competitor?
- Which competitor is the momentum leader?
- Is the category itself growing or contracting - does the brand's trajectory
  reflect the category tide or is it moving against it?

This framing should lead the dashboard. A brand growing in a contracting
category is a different story from a brand contracting in a growing category.

---

## Step 5: Build the marketing health dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make it visually direct and
comparative - the user should see the brand's health relative to the market and
competitors in seconds. Use color to signal growth (positive) and contraction
(negative) immediately. Choose chart types that best show share, trajectory,
and competitive ranking together.

The artifact must convey:
- Current demand size for the brand vs each competitor vs total category
- The brand's demand share and how it has moved over the year
- Trend directions for each entity (color-coded)
- A clear competitive ranking from largest to smallest
- The category growth context so the brand's trajectory reads correctly

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track the brand's health
> over time? Just say **save it**."

If yes:
1. Call `create_signal_collection` with signals grouped by entity - one tracker
   group for the brand, one for each competitor, one for category
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always include category signals.** Brand health without category context is
incomplete. A brand growing in a declining category is very different from a
brand growing with the market.

**Always call `get_demand_volume` with all signals in one call.** Separate
calls produce non-comparable numbers. All signals must be measured together.

**Always frame growth direction before charting.** Know whether the brand is
gaining or losing relative to both the category and each competitor before
building the artifact.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "demand share", "consumer interest" -
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover signals per brand, category, and competitor |
| `get_demand_volume` | 3 | Volume for all signals on a comparable scale |
| `calculate_demand_priorities` | 3 | Priority ranking across all signals |
| `create_signal_collection` | 7 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 7 | Attach the HTML artifact |
| `generate_platform_link` | 7 | Link to the live dashboard |