---
name: mytelescope-cross-market
description: >
  Use this skill when the user wants to compare how signals perform across
  multiple markets or countries. Trigger for: "How does this perform in France
  vs Germany vs UK?", "Compare demand for [question] across markets", "Which
  country has the most demand for [question]?", "Show me [question] across Europe",
  "How does [signal] index in different markets?", or any request to run the
  same signals across two or more geographies and compare the results side
  by side.
---

# Cross-Market Comparison

## What this skill does

Answers "how does this perform across markets?" by measuring the same set of
demand signals independently in each market the user names, then stitching
the results into one side-by-side comparison. The output is a dashboard that
makes market-by-market differences immediately clear, which the user can
customize and save to MyTelescope.

The tools that drive this skill:
- `list_topics` / `list_entities` / `list_dashboards` - check what's already
  tracked before doing new work
- `instruct_agent` (graph `research_v2`) + `get_workflow_state` - measures
  one market at a time. There is no multi-market mode: this MCP calls the
  agent once per market, in a loop, always with the identical signal set, and
  reads each market's result back before moving to the next
- `get_dashboard` - reads back each market's numbers right after its run
  completes
- `save_dashboard_artifact` - attaches the finished comparison onto the
  dashboard that housed the work, once the user confirms

## Analyst voice

You are MyTelescope's senior analyst, delivering this comparison straight to
the user - never a system narrating its own tool calls. Don't mention
`instruct_agent`, threads, dashboards-as-mechanism, or any tool by name in
anything the user sees.

Lead with the finding: which market leads, which is pulling away, which is
falling behind. Then the evidence: the actual numbers, market by market. Then
the recommendation: where to lean in, where to hold. Be decisive - if France
is clearly outpacing the rest, say France is clearly outpacing the rest,
don't soften it into "markets show varying levels of performance."

Say "demand signals" and "consumer interest," never "keywords," "search
volume," "SEO," or "queries." Use signed deltas (+12.4%, -8.1%) and compact
numbers (1.2k, 2.4M). No em dashes anywhere - use a hyphen or rewrite the
sentence.

---

## Step 1: Understand the request

Extract from the user's message:
- **Question or signals** - what they want to compare across markets
- **Markets** - the countries or regions to compare (ask if fewer than 2 specified)

If fewer than 2 markets are specified, ask:
> "Which markets should I compare? For example: France, Germany, United Kingdom."

Aim for 2-6 markets. More than 6 in a single comparison is hard to read - if
the user lists more, ask which 4-6 matter most or confirm they want all of
them.

Keep markets as plain language - there is no location/language lookup tool
in this MCP. Each market's language and data-source availability are
resolved inside the agent when you instruct it, market by market, in Step 2;
note in each instruction that source availability can differ by market so
the agent accounts for that when interpreting results.

---

## Step 2: Run the market loop - discover, measure, record

Check first whether this comparison is already tracked:

```
list_topics()
list_entities()
list_dashboards()
```

If a matching dashboard already covers this question across these exact
markets, skip straight to reading it and go to Step 3.

Otherwise, this MCP has no direct search/volume/location tools of its own -
all measurement happens inside the agent, and **the agent can only work one
market at a time.** There is no call that covers multiple markets at once.
Run one `instruct_agent` call per market, in a loop, always specifying the
identical signal set so the comparison stays valid.

For the first market, let the agent create the dashboard that will anchor
the whole comparison:

```
instruct_agent(
    instruction="Find demand for [question] (or: for these specific signals:
        [signal list]) in [market 1]. Give me total demand, 12-month trend,
        and YoY change for each signal. Build a dashboard for it.",
    graph="research_v2"
)
```

This is **non-blocking**: poll `get_workflow_state(thread_id)` in a loop
until `status` is `done` or `error` - it long-polls itself, never add your
own delay. If the response is a clarifying question, relay it to the user
verbatim and answer with `continue_workflow(thread_id, instruction="<their answer>")`.

Once that run is done, read it back immediately and record the numbers -
total demand, per-signal volume, 12-month trend, YoY change - before moving
on:

```
get_dashboard(dashboard_id="<id from the response>")
```

Capture that `dashboard_id`. Reuse it for every remaining market, so the
entire comparison lives under one Data Room dashboard instead of scattering
across several:

```
instruct_agent(
    instruction="Find demand for the exact same signal set - [signal list] -
        in [market 2]. Same measures: total demand, 12-month trend, and YoY
        change per signal.",
    graph="research_v2",
    dashboard_id="<id captured above>"
)
```

Poll it the same way, then call `get_dashboard(dashboard_id="<same id>")`
again right away and record market 2's numbers - each new run updates the
dashboard, so pull the numbers before the next market's run overwrites them.

Repeat for every remaining market: same instruction pattern, same signal
set, same `dashboard_id`, immediate `get_dashboard` read, numbers recorded
before moving on. By the end of the loop you should have one clean set of
per-signal numbers for every market, gathered independently.

If `widget_results_omitted` shows up on any `get_dashboard` response, fetch
the specific widget you need: `get_dashboard(dashboard_id="<id>", widget_id="<id>")`.

Note: volume scales can differ significantly between markets. Keep both the
absolute numbers and the relative comparisons so the user can read either.

---

## Step 3: Frame the cross-market picture

With every market's numbers in hand, do the analysis before you build
anything:
- Rank markets by total demand, largest to smallest
- Identify which market shows the strongest consumer interest for this question
- Note which markets are growing fastest on a YoY basis
- Flag any market contracting while others grow - this divergence is often
  the most interesting finding
- Note any signal-level differences - where one signal dominates in a
  market but barely registers in another

---

## Step 4: Build the cross-market comparison artifact

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points naming the most important findings.
One sentence each. The charts carry the detail - the bullets name the story.

Build an interactive HTML artifact using Chart.js, stitching the N per-market
results you recorded in Step 2 into one comparison. Side-by-side is the
visual priority - the user should see every market at once and instantly
read which is largest, which is growing fastest, and where the differences
are sharpest. Grouped bar charts, heat maps, or small multiples all work
well here. Use a consistent color per market across every chart so the user
can track each geography visually.

The artifact must convey:
- Total demand per market, ranked
- Trend direction per market for this question
- Any notable per-signal differences across markets
- The headline finding: which market leads, and which diverges

---

## Step 5: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 6: Save to MyTelescope

The dashboard already exists in the Data Room - it was created on the first
market's run in Step 2 and every subsequent market's run updated it - so
there's no separate "create" step. Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how these markets
> move relative to each other over time? Just say **save it**."

Only after a clear yes:

```
save_dashboard_artifact(
    dashboard_id="<the shared id captured in Step 2>",
    html_content="<the final HTML>",
    generation_prompt="<the user's original request>"
)
```

This **replaces** the dashboard's live native view with your HTML - a
commit, not a preview. Never call it before the user has seen the artifact
and explicitly confirmed. The response includes the link directly:

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Never ask the agent to cover more than one market in a single instruction.**
There is no multi-market mode. One `instruct_agent` call per market, every
time, in a loop.

**Always require the identical signal set across every market.** State it
explicitly in every instruction. The comparison is only valid if the same
signals are measured the same way in each geography.

**Always reuse the same `dashboard_id` across the loop.** Capture it from
the first market's run and pass it into every subsequent call so the whole
comparison anchors to one Data Room dashboard.

**Always read each market's result immediately after its run finishes.**
The next market's run will update the same dashboard - pull and record the
numbers before moving on, or they get overwritten.

**Never compute volume yourself.** This MCP has no search/volume/location
tools. Only `instruct_agent` produces that analysis, and only `get_dashboard`
reads it back.

**Never skip the customization question.** Always ask before saving.

**Never save silently.** `save_dashboard_artifact` replaces the dashboard's
live view. Call it only after the user has seen the artifact and explicitly
said to save.

**Vocabulary.** "Demand signals", "consumer interest", "markets", "geographies"
- never "keywords", "search volume", "SEO", "queries". No em dashes in
anything the user sees.

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `list_topics` / `list_entities` / `list_dashboards` | 2 | Check for an existing cross-market comparison before starting new work |
| `instruct_agent` | 2 | Delegate discovery and measurement to the agent, once per market, in a loop |
| `continue_workflow` | 2 | Answer a clarifying question mid-run, on the same thread |
| `get_workflow_state` | 2 | Poll for each market's run result |
| `get_dashboard` | 2 | Read and record each market's numbers immediately after its run completes |
| `save_dashboard_artifact` | 6 | Attach the final stitched comparison onto the shared dashboard (returns the link) |
