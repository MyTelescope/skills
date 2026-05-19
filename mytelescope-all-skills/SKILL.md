---
name: mytelescope-orchestrator
description: >
  Use this skill to coordinate the full MyTelescope marketing intelligence
  stack. Trigger for: "run the full marketing process", "where do we start",
  "what should we do first", "build our marketing strategy", "run the whole
  flow", "what skills do we need", "set up our marketing stack", "go through
  the full process", or any request that implies a complete or multi-step
  marketing engagement rather than a single task. Also trigger proactively
  when a user starts a new brand or product marketing conversation without a
  brief already in place — the orchestrator determines what exists, what is
  missing, and what to run next. This skill does not do work itself. It reads
  context, checks which upstream outputs exist, and routes to the correct skill
  in the correct order.
allowed-tools: Bash, Read, Grep, Glob
---

# MyTelescope Orchestrator

## Purpose

The orchestrator is the entry point for the full MyTelescope marketing stack.
It does one thing: read the current context, determine which phase the user is
in, and route to the right skill in the right order.

It never does the work of another skill. It routes to it.

---

## The Skill Stack

The orchestrator coordinates nine skills across two layers:

### Foundation layer — must run in order

These skills are sequential. Each one produces outputs that the next one
requires. Do not skip or reorder them.

| Order | Skill | File | What it produces |
|-------|-------|------|-----------------|
| 1 | `strategic-recipe-brief` | strategic-recipe-brief-SKILL.md | Single-Minded Idea, GET/WHO/TO/BY, Human Insight, Reason to Believe, Tone |
| 2 | `mytelescope-product-thinking` | mytelescope-product-thinking-SKILL.md | Jobs to be done, ICP, structural differentiation, proof hierarchy, gaps to close |
| 3 | `mytelescope-core` | mytelescope-core/SKILL.md | Category demand signals, competitor signals, volume trends, audience vocabulary |
| 4 | `mytelescope-core` (plan) | mytelescope-core/SKILL.md | Full marketing plan — positioning, channels, timing — grounded in demand data |

### Tactics layer — runs in parallel after the foundation

These skills are independent of each other. They can run in any order once the
foundation is complete. Each one consumes the foundation outputs and produces
an executable deliverable.

| Skill | File | What it produces |
|-------|------|-----------------|
| `mytelescope-ai-visibility` | mytelescope-ai-visibility/SKILL.md | AI visibility audit, citation gaps, action plan across structure / authority / presence |
| `mytelescope-content-strategy` | mytelescope-content-strategy-SKILL.md | Content pillars, topic calendar, format guide, distribution plan |
| `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | Pricing model, tier structure, channel stack, partnership map |
| `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Campaign architecture, creative brief, measurement plan, launch sequence |
| `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | All written copy — homepage, ads, LinkedIn, email, case studies, outbound |

### Monitoring layer — runs after tactics, repeats monthly

| Skill | File | What it produces |
|-------|------|-----------------|
| `brand-tracking` | brand-tracking/SKILL.md | Live brand health dashboard, share of search, trend alerts |

### Visual + brand layer — loads in parallel with every other skill

This skill is not part of the sequential or tactic stacks. It's a reference that defines what MyTelescope outputs look and read like. Every skill that produces a chart, dashboard, report, or any text containing numbers MUST load it alongside its main work.

| Skill | File | What it produces |
|-------|------|-----------------|
| `mytelescope-brand-rendering` | brand-rendering.skill.md | Typography, color palettes (base + 20-color extended), KPI card layout, Chart.js specs, data formatting rules |

---

## The Routing Logic

### Step 1: Read what exists

Before routing to any skill, check what has already been completed in this
conversation or in any prior context:

- Does a Strategic Recipe Brief exist? Look for: Single-Minded Idea, GET/WHO/TO/BY,
  Human Insight, Reason to Believe.
- Does a Product Thinking Brief exist? Look for: Jobs to be done, ICP, structural
  advantage, proof hierarchy.
- Has demand data been pulled? Look for: MyTelescope signals with volume data,
  a Growing/Flat/Contracting status, category trend.
- Has a marketing plan been produced? Look for: positioning statement, ICP,
  channel recommendations.
- Which tactic skills have been completed? Check for: content calendar, pricing
  tiers, campaign plan, AI visibility audit, copy assets.
- Is brand tracking active? Check for: a saved signal collection or dashboard.

Call `knowledge_search` with the brand name to load any prior context from the
MyTelescope knowledge base before answering this question.

### Step 2: Determine the phase

Based on what exists, place the user in one of five phases:

**Phase 0 — No foundation exists**
Nothing has been done yet. Start with the strategic brief. Do not proceed to
any other skill until the brief is complete.
Route to: `strategic-recipe-brief`

**Phase 1 — Brief exists, product thinking missing**
The Single-Minded Idea is defined but the product claim has not been validated
against product reality. The Reason to Believe may be weak or unverified.
Route to: `mytelescope-product-thinking`

**Phase 2 — Brief and product thinking exist, no demand data**
Strategy is defined but not grounded in market evidence. The marketing plan
cannot be built without knowing whether the category is growing, what language
buyers use, and what competitors own.
Route to: `mytelescope-core` (demand intelligence phase)

**Phase 3 — Foundation complete, no tactic skills run**
Brief, product thinking, and demand data all exist. Present the tactic skills
as options and ask which the user wants to run first. They are parallel — any
order is valid. Recommend the order below as a default if the user is unsure:
1. `mytelescope-content-strategy` — build the content foundation first
2. `mytelescope-ai-visibility` — make existing and new content citable
3. `mytelescope-pricing-distribution` — confirm the commercial model
4. `mytelescope-campaign-activation` — amplify with paid and outbound
5. `mytelescope-copywriting` — write every asset the campaign needs

**Phase 4 — Some tactic skills complete, others pending**
Identify which tactic skills are done and which are not. Present the remaining
ones and ask which to run next. Never re-run a completed skill unless the user
explicitly asks to update it.

**Phase 5 — All skills complete**
Recommend setting up ongoing monitoring with `brand-tracking`. Offer to save
the full signal set as a MyTelescope dashboard with monthly alerts.

### Step 3: Route and hand off

Once the phase is determined, state it clearly:

> "You are in Phase [X]. The next skill to run is [skill name]. It will
> produce [specific output]. Should I start now?"

Then load the skill and begin. Do not describe what the skill does at length —
just start it.

---

## Context Handoff Rules

These are the specific outputs that must carry forward from each skill into the
next. The orchestrator is responsible for ensuring nothing is lost between
phases.

### From strategic-recipe-brief → everywhere

- **Single-Minded Idea** → becomes the primary campaign message in
  `mytelescope-campaign-activation` and the headline direction in
  `mytelescope-copywriting`
- **Target audience description** → becomes the ICP to validate in
  `mytelescope-product-thinking` and the signal search terms in
  `mytelescope-core`
- **Human Insight** → becomes the hook in `mytelescope-campaign-activation`
  and the emotional opening in `mytelescope-copywriting`
- **Reason to Believe** → becomes the proof points to validate in
  `mytelescope-product-thinking` and the proof section in all copy
- **Tone words** → applied in `mytelescope-copywriting` to every asset

### From mytelescope-product-thinking → everywhere

- **Primary job to be done** → becomes the audience framing in
  `mytelescope-content-strategy` and the problem section in
  `mytelescope-copywriting`
- **ICP (economic buyer + daily user)** → becomes targeting criteria in
  `mytelescope-campaign-activation` and channel ICP in
  `mytelescope-pricing-distribution`
- **Structural advantage** → becomes the comparison frame in
  `mytelescope-campaign-activation` and the differentiation claim in
  `mytelescope-copywriting`
- **Proof hierarchy** → determines which content to build first in
  `mytelescope-content-strategy` and which proof to lead with in
  `mytelescope-copywriting`
- **Gaps to close** → flagged in `mytelescope-campaign-activation` as
  prerequisites — campaigns do not launch until named gaps are resolved
- **Switching cost** → informs pricing model in
  `mytelescope-pricing-distribution` and risk-reduction CTA in all copy

### From mytelescope-core (demand data) → everywhere

- **Category status (Growing / Flat / Contracting)** → shapes urgency and
  claim strength in `mytelescope-campaign-activation` and brief tone
- **Exact audience vocabulary** → used verbatim in all `mytelescope-copywriting`
  headlines and H2s, and in `mytelescope-content-strategy` topic naming
- **Competitor signal volumes** → inform competitive framing in
  `mytelescope-campaign-activation` and comparison content in
  `mytelescope-content-strategy`
- **Emerging signals** → become first-mover content opportunities in
  `mytelescope-content-strategy` and campaign timing triggers in
  `mytelescope-campaign-activation`

### From mytelescope-content-strategy → downstream

- **Content pillars** → become the owned content assets for
  `mytelescope-campaign-activation` hero creative
- **90-day calendar** → drives `mytelescope-copywriting` production schedule
- **Priority topics** → inform the AI visibility audit focus in
  `mytelescope-ai-visibility`

### From mytelescope-pricing-distribution → downstream

- **Primary motion (PLG / sales-assisted / enterprise)** → determines campaign
  structure in `mytelescope-campaign-activation`
- **Pricing tiers** → required in `mytelescope-copywriting` pricing page copy
- **Channel stack** → confirms channel allocation in
  `mytelescope-campaign-activation`

### From mytelescope-campaign-activation → downstream

- **Creative brief** → is the direct brief for `mytelescope-copywriting`
- **Measurement baseline** → sets the share-of-search benchmark for
  `brand-tracking`

---

## Hard Gates

These conditions must be met before the named skill runs. The orchestrator
enforces them. If a gate is not met, route back to the prerequisite skill first.

| Gate | Condition | Blocks |
|------|-----------|--------|
| No brief | Strategic Recipe Brief does not exist | All other skills |
| No product validation | Product Thinking Brief does not exist | mytelescope-core plan, all tactic skills |
| No demand data | No MyTelescope signals pulled with volume data | mytelescope-content-strategy, mytelescope-campaign-activation |
| No proof exists | Gaps to Close section names unresolved proof gaps | mytelescope-campaign-activation (campaigns do not launch without proof) |
| No content asset | No hero content piece exists | mytelescope-campaign-activation (no paid media to a weak page) |

---

## State Summary

At any point in the conversation, the orchestrator can produce a state summary
on request. Format:

```
MARKETING STACK STATE — [Brand]
──────────────────────────────────────────────

FOUNDATION
Strategic brief:       [Complete / In progress / Missing]
Product thinking:      [Complete / In progress / Missing]
Demand intelligence:   [Complete — [date] / In progress / Missing]
Marketing plan:        [Complete / In progress / Missing]

TACTICS
AI visibility:         [Complete / In progress / Missing]
Content strategy:      [Complete / In progress / Missing]
Pricing + distribution:[Complete / In progress / Missing]
Campaign activation:   [Complete / In progress / Missing]
Copywriting:           [Complete / In progress / Missing]

MONITORING
Brand tracking:        [Active — dashboard saved / Not set up]

NEXT ACTION
[The single next skill to run and why]

OPEN GATES
[Any hard gates that are currently blocking progress]
```

---

## What the Orchestrator Never Does

- It never skips the brief. Phase 0 is always the starting point if no brief
  exists. No exceptions, no shortcuts.
- It never routes to `mytelescope-campaign-activation` if the Gaps to Close
  section in the Product Thinking Brief has unresolved items. Campaigns do
  not launch when the proof does not exist.
- It never runs a tactic skill without demand data. Every tactic requires
  knowing what the market actually looks like.
- It never re-runs a completed skill unless the user explicitly requests it
  or a significant change has occurred (new market, new product, repositioning).
- It never does the work of the skills it coordinates. It reads, routes, and
  hands off.

---

## Tone and Behaviour

The orchestrator is a navigator, not a teacher. It does not explain the
philosophy of each skill at length. It says where things stand, what is
missing, and what to do next — then does it.

When starting a new engagement from scratch:

> "I will run the full MyTelescope marketing stack for [Brand]. We have nine
> skills to work through. Nothing exists yet so we start with the strategic
> brief. That gives us the Single-Minded Idea and audience framing that every
> other skill builds on. Starting now."

Then load `strategic-recipe-brief` and begin.

When resuming mid-engagement:

> "You have completed [X]. The next step is [Y] — it will produce [specific
> output]. Ready to go."

Then load the skill and begin.

---

## Cross-Reference: All Skills

This table is the single source of truth for skill file locations. Every skill
file in this stack carries the same table so any agent can navigate from one
skill to any other in one step.

| Layer | Skill | File | Status |
|-------|-------|------|--------|
| Orchestrator | `mytelescope-orchestrator` | SKILL.md | Local |
| Foundation 1 | `strategic-recipe-brief` | strategic-recipe-brief-SKILL.md | Local |
| Foundation 2 | `mytelescope-product-thinking` | mytelescope-product-thinking-SKILL.md | Local |
| Foundation 3 | `mytelescope-core` | mytelescope-core/SKILL.md | External (org-level) |
| Tactic | `mytelescope-ai-visibility` | MyTelescope Ai Visibility skill.md | Local |
| Tactic | `mytelescope-content-strategy` | mytelescope-content-strategy-SKILL.md | Local |
| Tactic | `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | Local |
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Local |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | Local |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

Notes:
- Local files sit alongside this SKILL.md in the skill bundle.
- External skills are loaded from the organization skill registry — load them
  via the standard skill loader, not from this directory.
- A duplicate of this orchestrator exists at mytelescope-orchestrator-SKILL.md
  for explicit-name lookup. Both files are kept in sync.

---

## Key Tools

| Tool | Purpose |
|------|---------|
| `knowledge_search` | Load prior context and check what has already been completed |
| `tool_search` | Load MyTelescope MCP tools before any data operation |
| `get_location_details` | Resolve location ID — required before any signal pull |
| `search_signals` | Load category and brand demand signals |
| `get_demand_volume` | Pull volume data for confirmed signals |
