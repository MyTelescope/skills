---
name: mytelescope-competitive-ai-comparison
description: >
  Use this skill when the user asks how their brand compares to competitors in
  AI-generated answers. Trigger for: "How do I compare to competitors in AI?",
  "Does ChatGPT mention my competitors more than me?", "Who is winning in AI
  answers in my space?", "Am I being cited as often as [competitor]?", "Which
  brands does AI recommend in [category]?", or any request to benchmark AI
  visibility across multiple brands.
---

# Competitive AI Comparison

## What this skill does

Answers "How do I compare to competitors in AI answers?" by running the same
set of queries for the user's brand and each competitor across AI platforms,
then comparing who gets cited, for which queries, and how often. The output is
a visual comparison dashboard the user can customize and save to MyTelescope.

The one tool that drives this skill:
- `web_search` - run equivalent queries for each brand across AI platforms
  and measure citation frequency and positioning

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand** - the user's own brand or product
- **Competitors** - the brands to compare against (ask if missing)
- **Category** - the space these brands compete in (infer if possible, ask
  if unclear)

If competitors are missing, ask:
> "Which competitors should I compare against? List up to 5 brands."

If the category is unclear, ask:
> "What category should I focus on? This helps me build the right query set."

---

## Step 2: Build a shared query set

Construct a set of 8-12 queries that a real user might ask an AI assistant
when researching this category. Make the queries neutral — they should not
name any specific brand. Use:
- Category queries: "Best [category] tools", "Top [category] companies"
- Problem queries: "How do I [problem these brands solve]?"
- Comparison queries: "Which [category] tool should I use?"
- Feature queries: "What [category] tool has [key feature]?"

The same query set is run for every brand. This ensures the comparison is
fair — every brand is evaluated against identical questions.

---

## Step 3: Run queries for each brand across AI platforms

For each query in the set, run a `web_search` scoped to each AI platform
(ChatGPT, Perplexity, Gemini, Grok) and record whether each brand is cited
in the response.

Do this systematically:
- Run query 1 for all brands across all platforms
- Run query 2 for all brands across all platforms
- Continue until the full query set is covered

Track for each brand per query:
- Cited or not cited on each platform
- Positioning: is the brand mentioned first, in the middle, or last?
- How the brand is described vs how competitors are described

---

## Step 4: Score and frame the comparison

Once all queries are run, calculate for each brand:
- **Citation rate** - how many of the queries trigger a mention, as a
  percentage of total queries
- **Platform coverage** - which of the four platforms cite this brand at all
- **Query coverage** - which query types trigger a mention (category, problem,
  comparison, feature)
- **Positioning score** - is the brand typically first, mid, or buried?

Identify the overall AI visibility leader across all platforms and query types.
Flag any brand that dominates a specific query type or platform even if it is
not the overall leader.

---

## Step 5: Build the comparison dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make the comparison
immediately legible — the user should see in seconds who is winning in AI
and who is not. Choose chart types that communicate the comparison clearly:
grouped bar charts for citation rates, heatmaps for query coverage vs
platform, or side-by-side cards for per-brand summaries. Avoid rendering all
data in one overcrowded chart.

The artifact must convey:
- Overall citation rate per brand (who gets mentioned most)
- Query coverage: which queries each brand wins
- Platform coverage: which platforms each brand appears on
- Positioning: whether the brand is typically cited first or buried
- A clear winner and a clear gap analysis for the user's own brand

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask
again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track how this AI competitive
> picture evolves? Just say **save it**."

If yes:
1. Call `create_signal_collection` with the brand and competitor signals as
   trackers
2. Call `save_dashboard_artifact` with the final HTML artifact
3. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always use the same query set for every brand.** Comparing brands on
different queries is not a fair comparison. Build the shared query set once
in Step 2 and use it for every brand without modification.

**Always cover all four AI platforms.** If a platform returns no coverage for
any brand, that absence is itself a finding. Report it, do not skip it.

**Always produce a ranking.** A comparison without a clear winner is not
useful. Surface who leads, who is in the middle, and who is missing.

**Never skip the customization question.** Always ask before saving.

**Vocabulary.** "AI citation", "AI visibility", "competitive AI presence" —
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `web_search` | 3 | Surface brand mentions per query per platform |
| `create_signal_collection` | 7 | Create the dashboard in MyTelescope |
| `save_dashboard_artifact` | 7 | Attach the HTML artifact |
| `generate_platform_link` | 7 | Link to the live dashboard |