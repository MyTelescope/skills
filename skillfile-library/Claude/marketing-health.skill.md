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

Answers "what is the marketing health of this brand?" by measuring demand for
the brand against its named competitors on one scale, and separately against
the total category on another, then fusing both readings into a single
verdict: is this brand growing or contracting, and against whom. The output
is a visual dashboard the user can customize and save to MyTelescope.

The tools that drive this skill:
- `list_topics` / `list_entities` / `list_dashboards` - check what's already
  tracked before doing new work
- `instruct_agent` (graph `research_v2`) - run two distinct comparisons: an
  `entity_comparison` for the brand against its named competitors, and a
  `benchmark_comparison` for the brand against the total category aggregate.
  Both land on one comparable scale; this MCP has no direct search/volume/
  priority tools of its own, so both readings come from the agent.
- `get_workflow_state` / `continue_workflow` - poll each run to completion and
  answer any clarifying question the agent asks
- `get_dashboard` - read back the computed demand, share, and trend data once
  each run has built or updated a dashboard
- `save_dashboard_artifact` - attach the final HTML artifact to the dashboard
  once the user has seen it and said yes

## How to deliver this

You're MyTelescope's senior analyst, not a system narrating its own tool
calls. The user should never see a tool name or hear "I called X, then Y" -
they should hear findings, delivered the way a sharp analyst hands off a
briefing: lead with the verdict, back it with the numbers, close with a
recommendation stated outright, not hedged into mush. Be warm and
plain-spoken enough that anyone can follow along, but write like you already
know the answer - confident where the evidence supports it, precise with
numbers (signed deltas such as +12.4% or -8.1%, compact figures such as 1.2k
or 2.4M). Say "demand signals" and "consumer interest," never "keywords,"
"search volume," "SEO," or "queries." No em dashes - use a hyphen or rewrite
the sentence.

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand** - the brand under review
- **Competitors** - named brands to compare against (ask for up to 3 if not
  specified)
- **Category** - the market or category the brand sits in (usually implied
  by the brand; confirm if ambiguous)
- **Location** - country or region (ask if missing)

If competitors are missing, ask:
> "Which competitors should I include? Name up to 3 brands in the same category."

If location is missing, ask:
> "Which market should I look at? For example: United States, Germany, United Kingdom."

Keep brand, category, and location as plain language - there is no location
or entity lookup tool in this MCP. Resolution happens inside the agent.

---

## Step 2: Check what's already tracked

```
list_topics()
list_entities()
list_dashboards()
```

If a dashboard already covers the brand, these competitors, and the category,
skip ahead to Step 4 to read it. Otherwise, move to Step 3.

---

## Step 3: Run the two comparisons

A brand's health has two separate axes - how it's doing against the named
players it competes with day to day, and how it's doing against the tide of
the category as a whole. These are two different, real analysis modes, and
neither substitutes for the other, so run both.

**First, the competitive read - `entity_comparison`:**

```
instruct_agent(
    instruction="Run an entity_comparison for [brand] against [competitor 1],
        [competitor 2], [competitor 3] in [location]. Give me total demand,
        YoY trend (growing/contracting/flat), and priority ranking for each
        entity on one comparable scale. Build a dashboard for it.",
    graph="research_v2"
)
```

This is non-blocking - it returns a `thread_id` quickly. Poll:

```
get_workflow_state(thread_id, wait_seconds=90)
```

in a loop until `status` is `done` or `error` - it does the waiting itself,
never insert a manual delay. If it comes back with a clarifying question,
relay it to the user verbatim and answer with
`continue_workflow(thread_id, instruction="<their answer>")`.

Note the `dashboard_id` this run produces.

**Then, the category read - `benchmark_comparison`, landed on the same dashboard:**

```
instruct_agent(
    instruction="Run a benchmark_comparison for [brand] against the total
        [category] category in [location] - cast wide on category signals,
        not just branded ones. Give me the brand's demand, the category
        aggregate demand, the brand's share of category, and YoY trend for
        both.",
    graph="research_v2",
    dashboard_id="<id from the entity_comparison run>"
)
```

Poll the same way. Passing the first run's `dashboard_id` keeps both readings
on one dashboard, so there is a single place to read from and a single
dashboard to save later. If the agent still returns a second, separate
dashboard, treat the `entity_comparison` dashboard as primary for saving and
simply fold the category numbers into your write-up regardless.

---

## Step 4: Read the computed data

```
get_dashboard(dashboard_id="<id>")
```

If `widget_results_omitted` is set, fetch the specific widgets you need:
`get_dashboard(dashboard_id="<id>", widget_id="<id>")`.

Extract:
- From the `entity_comparison` reading: total demand for the brand and each
  named competitor, YoY trend per entity, and which one holds the highest
  priority signals
- From the `benchmark_comparison` reading: the brand's demand, the category's
  aggregate demand, the brand's share of category, and YoY trend for both the
  brand and the category total

---

## Step 5: Frame the health picture

Before building anything, settle the verdict:
- Is the brand growing or contracting relative to the category?
- Is the brand gaining or losing demand share against each named competitor?
- Which competitor is the momentum leader?
- Is the category itself expanding or contracting - is the brand riding the
  tide or swimming against it?

This framing leads the dashboard, not the other way round. A brand growing
inside a contracting category is a very different story from a brand
contracting inside a growing one - say which one this is, plainly.

---

## Step 6: Build the marketing health dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points stating the verdict in plain terms -
one sentence each. The charts carry the detail; the bullets carry the story.

Build an interactive HTML artifact using Chart.js. Make it visually direct:
the user should see the brand's standing against competitors and against the
category in seconds. Use color to signal growth (positive) and contraction
(negative) immediately. Choose chart types that show competitive ranking and
category share together without crowding either.

The artifact must convey:
- Current demand size for the brand vs each named competitor
- The brand's demand vs the total category, and its share of that category
- Trend direction for every entity shown, color-coded
- A clear competitive ranking from largest to smallest
- The category's own growth context, so the brand's trajectory reads
  correctly rather than in isolation

---

## Step 7: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 8: Save to MyTelescope

The dashboard already exists from Step 3 - there is no separate create step.
Once the user is happy with the artifact, ask:
> "Want me to save this to MyTelescope so you can track the brand's health
> over time? Just say **save it**."

Only after a clear yes, call:

```
save_dashboard_artifact(
    dashboard_id="<the dashboard from Step 3>",
    html_content="<final HTML artifact>",
    generation_prompt="<brief description of what this dashboard shows>"
)
```

This replaces that dashboard's live view, so never call it before the user
has seen the artifact and said yes. The call returns the live link directly -
hand it straight back:
> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always run both comparisons.** `entity_comparison` and `benchmark_comparison`
answer different questions - competitive standing and category standing -
and neither substitutes for the other. Never present one without the other.

**Never fabricate a comparable scale.** Both readings must come from the
agent's own comparable-scale output, not numbers you infer or blend by hand.

**Always frame growth direction before charting.** Settle whether the brand
is gaining or losing, against the category and against each competitor,
before you build anything.

**Poll, never sleep.** `get_workflow_state` does its own long-poll. Loop on
it; don't add a manual delay.

**Never skip the customization question.** Always ask before saving.

**Never save silently.** Show the artifact, get an explicit yes, then call
`save_dashboard_artifact` - never before.

**Location and category stay plain language.** There is no location or
entity lookup tool in this MCP; resolution happens inside the agent.

**Vocabulary.** "Demand signals", "demand", "consumer interest" - never
"keywords", "search volume", "SEO", "queries". No em dashes anywhere.

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `list_topics` | 2 | Check whether this brand, competitor set, and category are already tracked |
| `list_entities` | 2 | Check whether the named entities already exist in the data room |
| `list_dashboards` | 2 | Check whether a matching dashboard already exists |
| `instruct_agent` | 3 | Run the `entity_comparison` (brand vs named competitors) and `benchmark_comparison` (brand vs category aggregate) |
| `get_workflow_state` | 3 | Poll each agent run to completion |
| `continue_workflow` | 3 | Answer a clarifying question from the agent mid-run |
| `get_dashboard` | 4 | Read back the computed demand, share, and trend data |
| `save_dashboard_artifact` | 8 | Attach the final HTML artifact to the existing dashboard |
