---
name: mytelescope-campaign-activation
description: >
  Use this skill whenever a user wants to plan, launch, or optimise a marketing
  campaign. Trigger for: "campaign plan", "how do we launch this", "paid media
  strategy", "launch plan", "go-to-market launch", "outbound sequence",
  "LinkedIn ads", "Google ads", "campaign brief", "how do we activate the
  strategy", "what do we run first", "performance marketing", "campaign
  calendar", "how do we reach our ICP at scale", or any request to turn a
  marketing strategy into a specific, executable campaign with channels, budgets,
  messages, and timing. Always pull real demand signals from MyTelescope to
  validate channel choice and message before recommending any campaign. Never
  recommend a campaign without a brief and positioning already in place upstream.
allowed-tools: Bash, Read, Grep, Glob
---

# Campaign Activation Skill

## Purpose

Turn a marketing strategy into an executable campaign with specific channels,
targeting, messages, creative direction, timing, and measurement. This skill
bridges the gap between having a plan and running something that reaches real
buyers.

Campaign activation is always the last skill to run in the marketing stack. It
amplifies what upstream skills have already established. A campaign without a
brief is noise. A campaign without demand data is guessing. A campaign without
proof is a promise no one believes.

---

## Mandatory: Prerequisites Before Starting

All of the following must exist before building a campaign:

1. **Strategic Recipe Brief** — mandatory. The Single-Minded Idea is the
   campaign message. The Human Insight is the emotional hook. The Reason to
   Believe is the proof that makes the message credible.

2. **Product Thinking Brief** — mandatory. The comparison frame determines
   the campaign angle. The structural advantage determines the claim. The
   proof hierarchy determines which asset must exist before ads run.

3. **Content Strategy** — strongly recommended. The highest-performing content
   pieces become the hero campaign assets. Never run paid media to a weak page.

4. **Pricing and Distribution** — recommended. The primary distribution motion
   determines the campaign structure. PLG campaigns look nothing like enterprise
   outbound campaigns.

5. **MyTelescope demand data** — mandatory. The campaign must target the
   vocabulary buyers actually use. Pull signals before writing a single ad.

If any mandatory is missing, name the gap and ask the user to confirm the
minimum inputs: Single-Minded Idea, target audience, one proof point, and the
primary distribution channel.

---

## Mandatory: Load MyTelescope Before Starting

1. Call `knowledge_search` with the brand name, category, and Single-Minded
   Idea to load any prior campaign context.
2. Call `search_signals` for the category, key proof-point terms, and
   competitor brand names.
3. Call `get_demand_volume` for the highest-priority signals.
4. Call `calculate_emerging_demand` to identify fast-growing signals that
   represent campaign timing opportunities.
5. Call `web_search` to check what competitors are currently running before
   finalising the campaign angle.

---

## The Interview: One Question at a Time

### Question 1: Campaign Goal

> "What is this campaign trying to achieve? Pick one: generate awareness among
> people who have never heard of you, generate leads from people actively
> evaluating options, or convert people who are close to a decision."

These are fundamentally different campaigns with different metrics, channels,
and creative approaches. Flag it if the user is trying to do all three — that
produces a campaign that does none of them well.

After they answer, confirm whether the goal maps to brand investment (long-term)
or activation investment (short-term, directly attributable). Flag if they are
trying to measure a brand campaign with activation metrics — one of the most
common and expensive mistakes in B2B marketing.

### Question 2: The Trigger

> "What makes this campaign timely right now — a product launch, a seasonal
> moment, a competitive shift, or a cultural trend your brand has the right to
> enter?"

The best campaigns are timed to a moment. A campaign with no timing rationale
is just advertising. A campaign timed to a real moment earns attention it does
not have to pay for.

### Question 3: The Budget Reality

> "What is the real committed budget — not aspirational, the actual number?
> Is there a separate production budget for content and creative?"

Budget determines campaign architecture. $5k means one channel, one message,
one test. $50k means a multi-channel programme. Build to fit the real number.
An underfunded multi-channel campaign is worse than a focused single-channel one.

### Question 4: Creative Constraints

> "What must this campaign do that is non-negotiable? And what must it never do?"

Legal lines, brand guidelines, competitive sensitivities. Get these before
building creative direction — not after.

---

## Phase 1: Campaign Architecture

Every campaign has four components:

**The hook** — the first thing the audience encounters. Must earn attention
before asking for anything. Comes from the Human Insight — the thing the
audience feels but never says. Not the product. Not a feature. The insight.

**The message** — the Single-Minded Idea in the audience's exact language from
demand signals. Not internal brand vocabulary.

**The proof** — the Reason to Believe. One specific, credible piece of evidence.
A named customer with a measurable outcome. A research finding with a date and
source. A demonstration of the product doing what the message claims.

**The call to action** — one thing. The CTA must match the campaign goal:
awareness campaigns drive to content, not a form. Lead gen campaigns drive to
a low-friction conversion. Conversion campaigns drive to a decision.

### Campaign types by goal

**Awareness campaign:**
Hook: Human Insight expressed as a tension the audience recognises
Message: Category frame — what the brand stands for
Proof: Data, research, or point of view unique to this brand
CTA: Read, watch, listen — to content, not a form
Metrics: Reach, share of search growth, branded search lift

**Lead generation campaign:**
Hook: A problem the in-market buyer is actively trying to solve
Message: Specific outcome this product delivers for this buyer
Proof: Named case study with measurable result and timeframe
CTA: Request a demo, start a trial, apply for a pilot
Metrics: MQL volume, cost per MQL, pipeline created

**Conversion campaign:**
Hook: The specific objection holding the prospect back
Message: The direct answer to that objection with evidence
Proof: Reference customer in the same industry or role
CTA: One decision — buy, start, sign
Metrics: CVR, cost per acquisition, revenue generated

---

## Phase 2: Channel Plan

### LinkedIn — B2B outbound sequence

Three-step structure. Use demand signal ICP data to identify targeting
criteria — company size, industry, and title from Product Thinking Brief.

Step 1 — Connection request (no pitch):
Personalised note referencing something specific about the person or company.
Goal is the connection, not the conversation. No product mention.

Step 2 — Value message (3 to 5 days after connection):
One specific insight relevant to their role. A demand signal finding, a
research point, or a question that opens a conversation. Maximum 3 sentences.
No CTA.

Step 3 — Soft ask (5 to 7 days after step 2):
One specific offer — a piece of content, a relevant case study, or a
15-minute conversation. Not a demo. Not a pitch deck. Something useful
whether or not they buy.

### Paid search

Only recommend if commercial intent demand signals exist and are Growing.
Paid search on low-volume signals is expensive with poor return.

Three campaign types:
- Brand campaign: bid on own brand terms always, regardless of organic rank
- Category campaign: bid on highest-volume commercial-intent category terms
- Competitor campaign: bid on competitor terms where comparison advantage
  is clear; use dedicated comparison landing pages

Ad copy rules:
- Headline uses demand signal language, not internal brand terminology
- Description states the specific outcome, not a feature
- Every ad includes a proof element — a number, a result, a named reference
- Landing page matches ad message exactly — never a generic homepage

### Email nurture — 5-email sequence

Email 1: The problem — articulate in the audience's language, no product, no CTA
Email 2: The insight — one data point that reframes the problem
Email 3: The proof — one named customer story with measurable outcome
Email 4: The comparison — how this product differs from current alternatives
Email 5: The ask — specific offer with one CTA and a genuine constraint

---

## Phase 3: Creative Brief

```
CREATIVE BRIEF
----------------------------------------------

Campaign:
Date:
Author:

THE AUDIENCE
Who they are:              [ICP from Product Thinking Brief]
What they feel:            [Human Insight from Strategic Recipe Brief]
What they are doing instead: [Current alternative]

THE MESSAGE
Single-Minded Idea:        [8 words or fewer]
In their language:         [Exact vocabulary from demand signals]

THE PROOF
Primary proof:             [Named customer, measurable outcome, timeframe]
Secondary proof:           [Data point with source and date]

THE HOOK
The tension:               [What they feel but never say]
Opening line:              [First sentence — must earn attention]

THE CTA
One action:                [Exactly what to do next]
One offer:                 [What they get for doing it]

FORMAT
Primary asset:             [Hero piece from content strategy]
Supporting assets:         [Social cuts, ads, email — derived from primary]

TONE
Three words:               [From Strategic Recipe Brief]
Not:                       [One example of what this brand would never say]

MANDATORIES
[Legal, brand, visual non-negotiables]
```

---

## Phase 4: Measurement Plan

Define measurement before launch, not after. Match metrics to campaign goal.
Never use activation metrics to judge brand campaigns.

```
MEASUREMENT PLAN
----------------------------------------------

Campaign goal:  [Awareness / Lead gen / Conversion]

PRIMARY METRICS
Metric 1:       [What / Target / Timeframe]
Metric 2:       [What / Target / Timeframe]

SECONDARY METRICS (directional only)
Metric 3:       [What / Why directional]
Metric 4:       [What / Why directional]

DO NOT OPTIMISE FOR
[Vanity metrics that mislead — impressions, followers, open rates alone]

BRAND HEALTH BASELINE
Share of search before campaign:  [Pull from MyTelescope before launch]
Branded search volume before:     [Pull from MyTelescope before launch]
Target lift after 90 days:        [X% increase in branded search]

REVIEW CADENCE
Week 2:    First data check — is pacing on track?
Month 1:   Full performance review — continue, adjust, or stop?
Month 3:   Strategic review — what did the market do in response?
```

---

## Output: The Campaign Plan

```
CAMPAIGN PLAN
----------------------------------------------

Brand / Campaign:
Dates:
Budget: [Media / Production / Total]
Goal:   [Awareness / Lead gen / Conversion]

CAMPAIGN ARCHITECTURE
Hook:     [Opening tension or insight]
Message:  [Single-Minded Idea in audience language]
Proof:    [Primary proof point]
CTA:      [One action]

CHANNEL PLAN
[Per channel: targeting, format, cadence, budget allocation]

CREATIVE BRIEF
[Full creative brief from Phase 3]

MEASUREMENT PLAN
[Full measurement plan from Phase 4]

LAUNCH SEQUENCE
Week 1:   Setup, asset production, tracking verification
Week 2:   Soft launch — limited audience, check tracking
Week 3:   Full launch — all channels live
Week 4:   First performance check — adjust bids, copy, targeting
Month 2:  Optimisation — double down on what works
Month 3:  Strategic review and next campaign planning

DEMAND SIGNALS USED
[MyTelescope signals that validated channel and message choices]
```

---

## Cookbook Rules

- **Campaign without brief is noise.** If the Single-Minded Idea is unclear,
  the campaign will say six things and be remembered for none. Go back upstream.
- **One message, one CTA.** Every second message or CTA reduces effectiveness.
  The hardest part of campaign planning is deciding what not to say.
- **Build the content before buying the media.** Paid traffic to a weak page
  is expensive. Hero asset must exist before the campaign launches.
- **Brand metrics require brand patience.** Share of search moves over
  quarters, not weeks. Do not cancel a brand campaign after 30 days.
- **The 95/5 rule.** Only 5% of the target market is in-market at any moment.
  Performance marketing captures the 5%. If the campaign does not also reach
  the 95%, the business depends entirely on buyer timing — not on building
  demand.
- **Measure share of search before and after every campaign.** Pull it from
  MyTelescope before launch as the baseline. This is the cleanest signal of
  whether the campaign built brand.

---

## Cross-Reference Skills

- **strategic-recipe-brief** — Single-Minded Idea, Human Insight, and Reason
  to Believe are the non-negotiable campaign inputs.
- **product-thinking** — comparison frame, structural advantage, and proof
  hierarchy determine the campaign angle.
- **content-strategy** — hero assets from this skill become campaign creatives.
  Build content first, then amplify.
- **pricing-distribution** — primary distribution motion determines whether
  the campaign is PLG, sales-assisted, or enterprise-led.
- **brand-tracking** — run before and after every campaign to measure share
  of search lift.
- **copywriting** — use this skill to write every campaign asset once the
  architecture and creative brief are confirmed here.

---

## Key Tools

| Tool | Purpose |
|------|---------|
| `knowledge_search` | Load prior campaign context and frameworks |
| `search_signals` | Find audience vocabulary and category signals |
| `get_demand_volume` | Validate channel demand and message territory |
| `calculate_demand_priorities` | Identify highest-volume campaign targets |
| `calculate_emerging_demand` | Find fast-growing signals for timely campaigns |
| `web_search` | Check competitor campaigns and market timing |
| `web_fetch` | Read competitor ads and landing pages |
| `create_trend_alert` | Set up monitoring for campaign-related signals |

---

## Cross-Reference: All Skills

Master index of every skill in the MyTelescope marketing stack. The
orchestrator (SKILL.md) is the entry point — route through it when unsure
which skill to load next.

| Layer | Skill | File | Status |
|-------|-------|------|--------|
| Orchestrator | `mytelescope-orchestrator` | SKILL.md | Local |
| Foundation 1 | `strategic-recipe-brief` | strategic-recipe-brief-SKILL.md | Local |
| Foundation 2 | `mytelescope-product-thinking` | mytelescope-product-thinking-SKILL.md | Local |
| Foundation 3 | `mytelescope-core` | mytelescope-core/SKILL.md | External (org-level) |
| Tactic | `mytelescope-ai-visibility` | MyTelescope Ai Visibility skill.md | Local |
| Tactic | `mytelescope-content-strategy` | mytelescope-content-strategy-SKILL.md | Local |
| Tactic | `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | Local |
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | This file |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | Local |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

**Direct downstream consumers of this skill's outputs:**
`mytelescope-copywriting` (creative brief → every campaign asset),
`brand-tracking` (measurement baseline → share-of-search benchmark).
**Upstream prerequisites (all required):** `strategic-recipe-brief`,
`mytelescope-product-thinking`, `mytelescope-core` (demand data),
`mytelescope-content-strategy` (hero assets), `mytelescope-pricing-distribution`
(motion). **Hard gate:** unresolved Gaps to Close in product-thinking blocks
this skill — campaigns do not launch without proof.
