---
name: mytelescope-category-positioning
description: >
  Use this skill when the user asks how their brand sits within its category
  or wants to understand their positioning relative to total category demand.
  Trigger for: "How does my brand sit relative to the category?", "What share
  of category demand do I own?", "Where is my brand in the category?", "Show
  me where [brand] sits in [category]", "What part of the category does [brand]
  own?", "Where are the gaps in the category?", or any request to map a brand's
  position within the full category demand landscape.
---

# Category Positioning

## What this skill does

Answers "How does my brand sit relative to the category?" by mapping the brand's
demand signals against the full category demand landscape - showing what share
the brand owns, where it clusters, and where significant demand exists that the
brand does not currently capture. The output is a visual positioning dashboard
the user can customize and save to MyTelescope.

The two tools that drive this skill:
- `calculate_demand_priorities` - surfaces the full priority-ranked category landscape and the brand's position within it
- `get_demand_volume` - measures absolute size of brand signals vs category signals

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand** - the brand being positioned
- **Category** - the full category to map against (infer from brand if not stated)
- **Location** - country or region (ask if missing)
- **Language** - infer from location; ask only if ambiguous

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Call `get_location_details` to resolve the location to an ID.

---

## Step 2: Discover category signals

Call `search_signals` to map the full category demand landscape. Use the broad
category term and several variations to ensure complete coverage. Then call
`search_signals` again specifically for the brand to identify its distinct
demand signals.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category variant]", location_id="<id>")
search_signals(query="[brand]", location_id="<id>")
```

Separate the results into two pools:
- **Category signals** - the full landscape of what consumers want in this space
- **Brand signals** - signals where consumer demand is specifically directed at this brand

Deduplicate across pools. If brand signals also appear in the category set,
keep them in both - they represent overlap between what the brand owns and
what the category needs.

---

## Step 3: Measure volume and priorities

Call `get_demand_volume` on all signals combined to get comparable volume
numbers.

```
get_demand_volume(
    keywords=["category signals...", "brand signals..."],
    location_id="<id>",
    language_id="<language>"
)
```

Then call `calculate_demand_priorities` on the full combined signal set to
understand which signals matter most across the whole category.

```
calculate_demand_priorities(
    keywords=["all signals combined"],
    location_id="<id>"
)
```

Use the results to calculate:
- **Total category demand** - sum of all category signal volumes
- **Brand-owned demand** - sum of volumes for signals the brand captures
- **Brand demand share** - brand-owned demand as a percentage of total category
- **Coverage gaps** - high-priority category signals where the brand has no presence

Group the category into natural demand clusters (2-5 clusters by theme or
intent). Calculate the brand's share within each cluster. This shows not just
total share but where within the category the brand is strong and where it
is absent.

---

## Step 4: Identify positioning gaps and opportunities

Before building the artifact, assess:
- Which category clusters does the brand own strongly?
- Which high-priority category clusters does the brand not appear in?
- Are the gaps in growing or contracting parts of the category?
- Is the brand concentrated in one cluster or spread across the category?

Gaps in growing clusters are opportunities. Gaps in contracting clusters are
less urgent. Concentration in one cluster is a focus risk.

---

## Step 5: Build the positioning dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. The visual focus is on
the brand's position within the total category space. Make the share picture
clear and the gaps obvious. Choose chart types that show coverage vs absence
well - consider a treemap of the category with the brand's signals highlighted,
a share breakdown by cluster, or a bubble chart plotting signal volume against
the brand's presence score.

The artifact must convey:
- How big each part of the category is (the full landscape)
- Where the brand has demand presence and how much
- The brand's overall share of total category demand
- The highest-priority gaps - large category clusters the brand does not own

Make the opportunity gaps visually distinct from the owned territory. The user
should immediately see where they are strong and where the white space is.

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how your positioning
> shifts as the category evolves? Just say **save it**."

If yes:
1. Call `create_signal_collection` with category signals grouped by cluster,
   with brand signals tagged as a separate group
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always cover the full category, not just the brand.** The point of this skill
is to show the brand within the category. A brand-only signal set misses the
whole analysis.

**Always calculate demand share explicitly.** The percentage the brand owns of
total category demand is the core metric here. Never present the data without
this number.

**Always identify and call out coverage gaps.** High-priority category signals
where the brand has no presence are the most actionable output of this skill.
Never omit them.

**Always group category signals into clusters.** A flat list of category signals
does not show position. Clustering is required.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "Demand signals", "demand share", "category demand", "consumer
interest" - never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `search_signals` | 2 | Discover full category signals and brand signals |
| `get_demand_volume` | 3 | Volume for all signals on a comparable scale |
| `calculate_demand_priorities` | 3 | Priority ranking across the category |
| `create_signal_collection` | 7 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 7 | Attach the HTML artifact |
| `generate_platform_link` | 7 | Link to the live dashboard |