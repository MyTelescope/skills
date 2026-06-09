---
name: mytelescope-marketing-health
description: >
  Use this skill when a user asks any question that amounts to "how is my
  marketing doing?" Trigger variants include: "how am I doing vs competition",
  "how did my latest campaign go", "is my brand growing", "what is my share of
  search", "how is our awareness tracking", "are we losing ground to
  competitors", "how is our content performing", "show me my marketing
  performance", "give me a marketing health check", "am I reaching the right
  people", "how visible are we", "what does my demand look like", or any
  question where the user wants a holistic view of marketing performance across
  brand, demand, competitive position, and AI visibility. This skill runs a
  structured intake questionnaire first, then delivers the answer as a
  multi-panel visual covering Google demand trends, cross-source demand, AI visibility, and
  competitive share. Never skip the questionnaire. Never assume what the user
  wants to measure.
allowed-tools: Bash, Read, Grep, Glob
---

# MyTelescope Marketing Health Check

## Purpose

This skill answers one question: **how is my marketing doing?**

It handles every variant of that question -- from "am I growing" to "how did
my campaign perform" to "how do I compare to competitors." The intake
questionnaire determines exactly what to measure and which modules to include
in the answer.

The answer is delivered as a single visual with five panels:
1. Brand vs category demand (are you growing with or against the market?)
2. Product and service demand (are your specific offers gaining or losing ground?)
3. Cross-source demand (where is your audience attention concentrated?)
4. Competitive position (how does your demand share compare to competitors?)
5. AI visibility (are AI systems citing you, and for the right things?)

---

## MANDATORY GATE -- Questionnaire Before Any Tool Call

When this skill triggers, the FIRST response is the questionnaire ONLY.
No tools. No data pulls. No narration. Just the questions.

You MUST NOT call any of these until the user has answered:
- `get_location_details`
- `search_signals`
- `get_demand_volume`
- `web_search` (AI Search)
- `ai_search`
- Any other tool

The questionnaire exists because "how is my marketing doing" can mean ten
different things. Without answers, you cannot know which signals to pull,
which competitors to benchmark, or which question actually needs answering.

---

## The Questionnaire -- Guided One Question at a Time

Ask ONE question per turn. Wait for the answer. Acknowledge it briefly (one
short sentence -- no praise, no filler). Then ask the next question.

Never ask two questions in the same message. Never show a numbered list of all
questions upfront. The experience should feel like a short intake conversation,
not a form.

Pre-fill any question you can answer from context already in the conversation.
If a field is known, state it and move on: "I have your market as Sweden --
moving on." Do not ask for information already given.

**The 8 questions in order:**

Q1 -- Brand name
> "Let's start -- what is the name of your brand, product, or company?"

Q2 -- Website
> "What is your website URL? I need this for the AI visibility part."

Q3 -- Market
> "Which market should I measure? (Defaulting to [user location] -- just
> confirm or give me a different country and language.)"

Q4 -- Single-Minded Idea
> "What do you want to be known for -- in one sentence, what is the single
> thing your brand should own in the market?"
> If the user is unsure: "Take your best shot -- we can refine it later."

Q5 -- Products or services
> "Which specific products or services are you pushing right now? List 2-4.
> (If you're not sure, I'll identify the top searched categories in your
> market.)"

Q6 -- Competitors
> "Who are your main competitors? Name 2-4. (If unsure, I'll find them from
> the demand data.)"

Q7 -- The real question
> "What triggered this? Which of these is closest to what you want to know?"
> - a) Is my brand growing or declining overall?
> - b) How am I doing vs specific competitors?
> - c) Did a recent campaign or launch move the needle?
> - d) Am I visible in AI-generated answers like ChatGPT or Perplexity?
> - e) All of the above -- give me the full picture.

Q8 -- Time window
> "How far back should I look -- 3 months, 6 months, or 12 months?
> (Defaulting to 12 months.)"

Q9 -- Campaign periods
> "Have you run any campaigns or launches in this window I should know about?
> Give me the month they started -- I'll measure whether demand moved."
> (If none: "No campaigns -- noted. Moving on.")

Q10 -- Active channels
> "Which channels are you active on? For example: paid search, LinkedIn,
> Meta, influencer, PR, email, organic content. This tells me where to look
> for signals beyond Google."

Q11 -- Budget direction
> "Last one -- are you spending more, the same, or less on marketing than
> 12 months ago? No exact numbers needed -- just directional. This helps me
> tell the difference between demand growing because of your marketing and
> demand growing despite flat investment."

After Q11 is answered, say:
> "Got everything I need. Give me a moment."

Then begin the data collection phase. No further questions until the answer
is delivered.

---

## Escape Clause

If the user says "skip questions / just go / quick check / observational mode":
proceed but open the answer with:

> "Running in observational mode -- findings are not benchmarked against
> intended positioning. Provide your Single-Minded Idea to sharpen the
> AI visibility panel."

---

## After the Questionnaire -- Data Collection Phase

Once the user answers, run the following in order. Do not narrate what you are
doing. Show only results.

### Step 1 -- Resolve location

```
get_location_details(location="[user's country]")
```

Extract: `locationId`, `languageId`, available data sources.

### Step 2 -- Discover category context

```
ai_search(query="[brand] [category] market [country] demand trends")
ai_search(query="[brand] competitors [category] [country]")
```

Use this to confirm: the correct category framing, the real competitor set
(validate or replace the user's list), and any major recent market movements
to be aware of.

If the user named campaign periods in Q9, also run:

```
ai_search(query="[brand] campaign [launch month/year] results OR launch OR announcement")
```

This surfaces any external coverage or market reaction to the campaign.

### Step 3 -- Pull demand signals

Run these in parallel:

```
search_signals(query="[brand name]", locationId=<id>)
search_signals(query="[category]", locationId=<id>)
search_signals(query="[product/service 1]", locationId=<id>)
search_signals(query="[product/service 2]", locationId=<id>)
[repeat for each product/service the user listed]
search_signals(query="[competitor 1]", locationId=<id>)
search_signals(query="[competitor 2]", locationId=<id>)
[repeat for each competitor]
```

Also pull signals for the user's active channels where demand signals exist:

```
search_signals(query="[brand] + [channel]", locationId=<id>)
```

For example: "[brand] LinkedIn", "[brand] paid search", "[brand] podcast" -- only
pull these if the channel is one the user confirmed active in Q10.

Identify: brand signal, category signal, one signal per product/service,
one signal per competitor, one per active channel where available.

If the user did not supply products or services, use AI Search results from
Step 2 to infer the top 2-3 most searched product or service types in the
category and pull signals for those instead. Flag this in the answer:
"I identified these product signals from category data -- confirm or replace
them."

### Step 4 -- Pull volume data

```
get_demand_volume(signalId=<brand signal>, ...)
get_demand_volume(signalId=<category signal>, ...)
get_demand_volume(signalId=<product/service 1 signal>, ...)
get_demand_volume(signalId=<product/service 2 signal>, ...)
[repeat for each product/service]
get_demand_volume(signalId=<competitor 1 signal>, ...)
[repeat for each competitor]
```

Pull the full time series for all signals. Do not truncate.

If the user named campaign periods in Q9: mark each launch month on the
time series data. You will use this in the Campaign Impact section.

### Step 5 -- Pull cross-source demand

After pulling Google volumes, use the available sources from `get_location_details`
to pull the brand signal across sources that match the user's active channels
from Q10. Prioritise sources the user confirmed using.

For example: if user is active on LinkedIn and YouTube, pull YouTube signal.
If active on Reddit or community channels, pull Reddit signal.

Present this in Panel 3 of the answer.

### Step 6 -- AI visibility check

Run these AI Search queries to populate Panel 4:

```
ai_search(query="best [category] tools / products / brands")
ai_search(query="[brand name] review OR alternative OR vs [competitor]")
ai_search(query="[Single-Minded Idea keywords] -- who to use / recommended")
```

For each query, note: whether the brand appears in the top results, whether
competitors appear, what positioning language is used, and whether the brand's
own content or website is cited.

---

## Delivering the Answer -- The Four Panels

After data collection, build an interactive HTML artifact with five panels.
The user asked a question. This is the answer. Never frame it as "building a
dashboard" -- present it as: "Here is how your marketing is doing."

Follow the visual rules from `brand-rendering.skill.md` exactly.

Load `brand-rendering.skill.md` in parallel with this step.

### Visual Rules (minimum -- full spec in brand-rendering)

```
Background:     #F0EDE8
Card surface:   #E8E5E0
Border:         #D4D0CA at 0.5px
Heading font:   Instrument Serif
Body font:      Inter 300/400/500
Primary text:   #1A1A1A
Secondary text: #6B6B6B
Accent color:   #C4956A (use sparingly -- eyebrows, rules, dots, CTAs)
Emphasis:       #323F5F (secondary headlines only)
Positive:       #00CCFF
Negative:       #FF6B6B
Neutral:        #323F5F
No bold (600+). No dark backgrounds. No em dashes.
```

### Panel 1 -- Brand vs Category Demand

**Purpose:** show whether brand and category interest is growing, flat, or
contracting over the selected time window.

Required elements:
- KPI card: Brand demand status (Growing / Flat / Contracting) + latest volume
  + annual change %
- KPI card: Category demand status + latest volume + annual change %
- Trend line chart: brand vs category monthly volumes over full time series
- If campaign mode (option c): vertical reference line at launch month with
  label "Campaign launch"
- Forecast: dashed line 6 months forward on the same chart
- Insight sentence below the chart: one sentence interpreting the relationship
  between brand and category trend (e.g. "Brand demand is growing faster than
  the category -- indicating share gain.")

### Panel 2 -- Product and Service Demand

**Purpose:** show whether the specific products or services the brand is
pushing are growing or declining, how they perform relative to the category
trend, and where competitor products stand on the same signals.

This answers: are people increasingly interested in what you sell, or is
demand shifting to something else?

Required elements:
- KPI card per product/service: name + status (Growing / Flat / Contracting)
  + latest volume + annual change %
- Trend line chart: all product/service signals plotted on one chart over the
  full time series, with the category signal as a reference line
- Category beat indicator: for each product/service, a simple label --
  "Beating category" (growing faster than category) / "Tracking category"
  (within 5pp) / "Lagging category" (growing slower or contracting while
  category grows)
- Competitor product comparison: if competitor signals were pulled for the same
  product type, add a second chart or a side-by-side table showing demand share
  per product type across brand vs competitors
- Insight sentence: which product/service has the strongest demand momentum,
  and which is at risk of being outpaced by competitors or category shift

If the user did not supply products/services and they were inferred from
category data, open the panel with: "Based on category signals, I tracked
these product areas -- replace them if needed."

If no product-level signals were found, note: "No product-level demand signals
found for [market]. Brand and category signals are available -- add specific
product names to unlock this panel."

### Panel 3 -- Cross-Source Demand

**Purpose:** show where brand interest is concentrated beyond Google search.

Required elements:
- Bar chart: brand demand volume by source (Google, YouTube, Reddit, news,
  etc.) for latest 3-month period
- Source coverage note: "Data from [X] sources in [market]"
- Insight sentence: where is audience attention concentrated? What does this
  suggest for channel prioritization?

If fewer than 2 sources are available beyond Google, note this and recommend
the user enable additional data sources.

### Panel 4 -- Competitive Position

**Purpose:** show demand share vs competitors and whether the gap is widening
or narrowing.

Required elements:
- Donut chart: current demand share by brand (brand vs each competitor)
  showing % of total combined demand
- Trend table: for each brand (yours + competitors), show latest monthly
  volume, annual change %, and 3-word status summary
- Insight sentence: who is winning, who is losing, and what the data suggests
  about the competitive dynamic

If the user did not supply competitors and AI Search did not surface clear
ones, show a note: "Add competitors to unlock this panel -- I can search for
them if you share the category."

### Panel 5 -- AI Visibility

**Purpose:** show whether AI systems are citing the brand, what they say, and
how this compares to competitors.

Required elements:
- AI visibility score: a simple 0-10 score based on the AI Search results
  (see scoring rubric below)
- Citation presence: for each AI Search query run in Step 6, a row showing
  query / brand cited (yes / no) / competitors cited
- Top citations: 2-3 short summaries of what AI systems say about the brand
  (in your own words -- never reproduce verbatim)
- Gap analysis: 1-3 sentences on what the brand is NOT being cited for that
  competitors are

**AI Visibility Scoring Rubric (0-10)**

| Score | Meaning |
|-------|---------|
| 8-10  | Brand appears in 3+ AI queries, in top positions, for its core category |
| 5-7   | Brand appears in some queries but not for its Single-Minded Idea |
| 3-4   | Brand mentioned occasionally but not recommended or cited as a leader |
| 0-2   | Brand absent from AI answers or only appears in negative context |

Adjust score based on:
- +1 if the brand's own website or content is cited as a source
- -1 if competitors consistently outrank the brand in citation depth
- -1 if the brand's Single-Minded Idea is owned by a competitor in AI answers

---

## Campaign Mode -- Special Additions

If the user named one or more campaign periods in Q9, add a Campaign Impact
section for each campaign. This section is always included when Q9 has an
answer -- it does not require the user to select option c.

**Campaign Impact Section** (sits between Panel 1 and Panel 2 -- product demand):

- Chart: brand demand in the 3 months before vs 3 months after the campaign
  launch month, with a vertical reference line at the launch month
- Uplift figure: % change in monthly average before vs after
- Channel context: which channels the user ran the campaign on (from Q10) --
  note whether those channels have measurable demand signals
- Category context: did the category also move in the same period? Separates
  brand effect from market effect
- Budget context: if the user said they spent MORE than the prior period
  (from Q11), note this -- growth on increased spend is expected; the
  interesting question is efficiency. If they spent the SAME or LESS and
  demand grew, that is the stronger signal
- Verdict: one sentence -- "The demand data shows [strong lift / modest lift /
  no measurable lift / category-driven lift] in the post-campaign window
  [on [budget direction] investment]."

If the user named a campaign but could not give a launch month, ask:
"What month did that campaign start? I need this to measure pre/post impact."

---

## Budget Direction -- How to Use Q11 in the Analysis

Q11 (more / same / less spending) is a context signal, not a data point.
Use it to frame the efficiency verdict in Panel 1 and the Campaign Impact
section:

- **More spending, demand growing** -- expected. Note it and look for
  efficiency signals: is demand growing faster than investment, or in line?
- **Same spending, demand growing** -- strong signal. Marketing is becoming
  more efficient or brand is compounding. Call this out explicitly.
- **Less spending, demand growing** -- exceptional signal. Brand momentum
  is carrying without media support. Flag this as a strategic asset.
- **More spending, demand flat or declining** -- warning signal. Investment
  is not converting to demand. Raise this in the answer without being alarmist.
- **Less spending, demand declining** -- ambiguous. Could be expected
  reduction. Flag it and note the category trend for context.

Never use exact spend figures. Budget direction is directional framing only.

---

## Answer Header

Every answer must include:

- Title: "[Brand] Marketing Health Check" in Instrument Serif 22px
- Subtitle: "[Market] / [Language] / [Time window]" in Inter 11px #6B6B6B
- Question answered: the user's selection from Q7 in the questionnaire
- Channels active: from Q10
- Budget direction: from Q11 (shown as "Investing more / same / less than prior year")
- Data freshness: last data point date if more than 6 weeks old

---

## After the Answer -- Offer Next Steps

Once the answer is shown, ask:

> "Want to save this to MyTelescope so it stays live and updates automatically?"

If yes, follow the `dashboard-creation` skill flow from Step 5 onward.

Then offer 2-3 of the following based on what the data revealed:

- If AI visibility score is below 5: "Your AI visibility score is low. Want me
  to run a full AI visibility audit and build an action plan?"
- If a competitor is gaining share: "One competitor is gaining demand share.
  Want a deeper competitive intelligence analysis?"
- If brand demand is growing faster than category: "You are outpacing the
  market. Want to build a content strategy to press the advantage?"
- If campaign mode showed no lift: "The campaign did not show a measurable
  demand signal. Want to run a deeper analysis to understand why?"
- If cross-source data shows concentration in one channel: "Your audience is
  concentrated on [source]. Want a channel-specific content or activation plan?"

Do not list all of these. Pick the 2-3 most relevant to the data in front of
you.

---

## Hard Rules

**Never frame the output as a deliverable.** The user asked a question. The
answer happens to be visual. Never say "building your dashboard", "here is
your dashboard", or "I have created a dashboard." Say "here is how your
marketing is doing" or equivalent.

**Never skip the questionnaire.** "How is my marketing doing" has no single
answer. The questions determine what to measure. An answer built without them
will answer the wrong question.

**Never guess competitors.** If the user does not supply them and AI Search
does not return clear ones, show Panel 3 with a placeholder and ask.

**Never invent data.** If a source returns no signal for the brand, note it
honestly. Do not fill with estimates or training-data assumptions.

**Never use Claude's native web search.** Every AI visibility check and
research query runs through the MyTelescope MCP `web_search` / `ai_search`
tool. The native browser is banned.

**Never narrate tool flows.** The user sees the answer. They do not see
which tools ran, in what order, or what came back at each step.

**Vocabulary in every panel:** "demand signals", "consumer interest", "demand".
Never "search volume", "keywords", "SEO", "indexed data".

**Volumes:** always formatted -- `1.2k`, `2.4M`. Always signed -- `+12.4%`.
Status always from the enum: `Growing` / `Flat` / `Contracting`.

---

## Tool Reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve market to location ID and available sources |
| `ai_search` | 2, 6 | Category context, competitor discovery, AI citation check |
| `search_signals` | 3 | Find brand, category, and competitor demand signals |
| `get_demand_volume` | 4 | Pull monthly volume time series for all signals |
| `forecast_demand` | 4 | 6-month forecast for Panel 1 trend chart |
| `create_signal_collection` | post-dashboard | Save as live MyTelescope dashboard |
| `save_dashboard_artifact` | post-dashboard | Attach HTML to signal collection |
| `generate_platform_link` | post-dashboard | Return authenticated link to live dashboard |
| `create_trend_alert` | post-dashboard | Set alerts for demand changes |

---

## Cross-Reference: All Skills

| Layer | Skill | File | Status |
|-------|-------|------|--------|
| Orchestrator | `mytelescope-orchestrator` | SKILL.md | Local |
| Health check | `mytelescope-marketing-health` | mytelescope-marketing-health.skill.md | This file |
| Core | `mytelescope-core` | mytelescope-core.skill.md | External (org-level) |
| AI visibility | `mytelescope-ai-visibility` | ai-visibility.skill.md | Local |
| Dashboard | `mytelescope-dashboard-creation` | dashboard-creation.skill.md | Local |
| Brand rendering | `mytelescope-brand-rendering` | brand-rendering.skill.md | Local |
| Content strategy | `mytelescope-content-strategy` | content-strategy.skill.md | Local |
| Campaign | `mytelescope-campaign-activation` | campaign-activation.skill.md | Local |
| Brand tracking | `brand-tracking` | brand-tracking.skill.md | External (org-level) |
