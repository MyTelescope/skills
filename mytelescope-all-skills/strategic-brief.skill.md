---
name: strategic-recipe-brief
description: >
  Use this skill whenever a user wants to create a creative or campaign brief,
  develop a strategic message, define a campaign proposition, write a creative
  brief for an agency or team, or structure a marketing communication strategy.
  Trigger for: "help me write a brief", "campaign brief", "creative brief",
  "what's our message", "what should we say", "brand brief", "communication
  strategy", or any request to define the core strategic idea behind a campaign
  or marketing effort. Always pull MyTelescope demand data to ground the brief
  in real audience language and category signals before completing any section.
allowed-tools: Bash, Read, Grep, Glob
---

# Strategic Recipe Brief Skill

## Purpose

Guide the user through the Strategic Recipe Brief — a one-page creative brief
framework that distills strategy down to a single-minded idea, a clear audience
move, and a human insight. Every section must be grounded in real demand data
pulled from MyTelescope. Do not let the user fill in any section based on
assumption alone.

---

## Mandatory: Load MyTelescope Before Starting

Before running the interview, cross-reference the MyTelescope orchestrator:

1. Call `knowledge_search` with the user's category or brand name to load any
   relevant frameworks or prior context.
2. Call `search_signals` to identify how the audience actually talks about the
   category — this will directly inform the Human Insight and Single-Minded
   Idea sections.
3. Call `get_demand_volume` to confirm whether the category is growing, flat,
   or contracting — this shapes the Business Problem framing.

Do not begin the interview until you have demand data in hand. Pull it first,
then reference it throughout each section.

---

## The Interview: One Question at a Time

Walk the user through each section below in order. Ask one question per turn.
Do not dump all questions at once. After each answer, reflect back what you
heard, flag if it conflicts with demand data, and then move to the next.

---

### Section 1: The GET / WHO / TO / BY

This is the strategic backbone. Each word is a constraint.

**Ask:**

> "Let's start with who you're trying to reach. Describe your target audience
> in one sentence — not a demographic, but a person in a specific mindset or
> situation."

After their answer, pull a relevant demand signal to check the language they
use. If the user's description conflicts with how the audience actually talks
in search, flag it.

Then ask:

> "What belief or behaviour is holding this person back right now? What are
> they currently doing instead of what you want them to do?"

Then:

> "What do you want them to do or believe after they've seen your campaign?"

Finally:

> "What is the one thing — the offer, message, or idea — that will make that
> change possible? This is your BY, and it should be the most exciting part of
> the brief."

Once all four are collected, write them out as:

```
GET:  [Target Audience]
WHO:  [Current behaviour or belief holding them back]
TO:   [Desired behaviour or belief change]
BY:   [The core message or offer that makes this possible]
```

Flag if the BY is vague. A weak BY is the most common failure in briefs. Push
the user to make it specific and compelling.

---

### Section 2: The Business Problem

**Ask:**

> "What is the one business problem this campaign needs to solve? Write it as a
> single sentence — no qualifiers, no 'and also'."

If the user gives more than one problem, push back: "Which one, if solved,
would make the others less urgent?" Help them pick one.

Cross-reference with demand trend. If the category is Contracting, the
business problem is likely awareness or consideration. If Growing, it may be
share or conversion. Let the data guide the framing.

---

### Section 3: The Human Insight

**Ask:**

> "What is the 'secret truth' about your audience — the thing they feel but
> would never say out loud — that makes your message relevant to their life?"

This is the hardest section. Most users will write a consumer observation, not
an insight. An observation is: "People are busy." An insight is: "People feel
guilty about being busy because they believe productivity defines their worth."

If their answer is an observation, push them: "Why does that matter to them
emotionally? What does it mean about how they see themselves?"

Use demand signal language to validate. If the audience is searching for
[term], what does that reveal about what they're really looking for beneath the
surface?

---

### Section 4: Single-Minded Idea

**Ask:**

> "If someone saw your campaign and only remembered one thing, what would that
> be? Write it in 8 words or fewer."

Count the words. If it's over 8, send it back. If it contains more than one
idea, send it back.

The Single-Minded Idea should be the natural output of the GET/WHO/TO/BY and
the Human Insight combined. If it doesn't feel connected to those sections,
flag the gap.

---

### Section 5: Reason to Believe

**Ask:**

> "What facts, features, or proof points make your Single-Minded Idea
> credible? List up to four — rank them by how much the audience would care,
> not how much the business is proud of them."

Cross-reference with demand signals. If audiences are searching for a specific
benefit or feature, and it's on the list, move it to the top. If it's not on
the list at all, flag that as a potential credibility gap.

---

### Section 6: Tone and Style

**Ask:**

> "How should the brand sound in this campaign? Pick up to three words. Avoid
> generic ones like 'friendly' or 'professional' — those describe every brand.
> What is specific to yours?"

If the user picks generic words, push back with examples: "Is it more
self-deprecating or confident? More urgent or unhurried? More direct or
storytelling?"

---

### Section 7: Mandatories

**Ask:**

> "What are the non-negotiables? Logos, legal lines, visual elements, or brand
> guidelines that must appear regardless of creative direction."

Keep this section short. A brief overloaded with mandatories kills creative
space. If the list is long, ask: "Which of these would actually stop the work
from running if they were missing?"

---

## Output: The One-Page Brief

Once all sections are complete, render the brief as a clean, formatted
one-pager using the layout below. Include the demand signal data that informed
key sections as footnotes or callouts — show that the brief is grounded in
evidence, not assumption.

```
STRATEGIC RECIPE BRIEF
──────────────────────────────────────────────

Brand / Campaign:
Date:
Author:

──────────────────────────────────────────────
THE GET / WHO / TO / BY

GET:  [Target Audience]
WHO:  [Current behaviour or belief]
TO:   [Desired behaviour or belief]
BY:   [Core message or offer]

──────────────────────────────────────────────
THE BUSINESS PROBLEM

[Single sentence]

──────────────────────────────────────────────
THE HUMAN INSIGHT

[The secret truth that makes this relevant]

──────────────────────────────────────────────
SINGLE-MINDED IDEA

[8 words or fewer]

──────────────────────────────────────────────
REASON TO BELIEVE

1.
2.
3.

──────────────────────────────────────────────
TONE AND STYLE

[Up to three specific words]

──────────────────────────────────────────────
MANDATORIES

[Non-negotiable brand or legal elements]

──────────────────────────────────────────────
DEMAND SIGNALS USED

[Cite the MyTelescope signals that informed
this brief — channel, term, trend, volume]
```

---

## Cookbook Rules (Apply Throughout)

- **One page only.** If the brief is getting long, cut — do not add.
- **The BY is the hook.** It should be the most exciting line in the brief for
  a creative team. If it is not, the strategy is not done yet.
- **Translate business language to human language.** "We want to increase
  trial" becomes "We want someone who has never thought about us to pick us up
  off the shelf." The brief is for humans, not for a board deck.
- **Every section should make the next one easier.** If the Single-Minded Idea
  does not follow naturally from the Human Insight, something earlier is wrong.
- **Demand data is not decoration.** It should actively change or sharpen at
  least two sections of the brief. If it does not, the research step was not
  thorough enough.

---

## Cross-Reference: MyTelescope Orchestrator

This skill relies on the MyTelescope MCP orchestrator for all demand
intelligence. Before starting and at any point where audience language,
category trends, or competitive signals would improve a section, call:

- `knowledge_search` — load strategic frameworks and prior context
- `search_signals` — identify audience language and topic clusters
- `get_demand_volume` — confirm category trend (Growing / Flat / Contracting)
- `calculate_demand_priorities` — identify the highest-volume signals in the
  category to sharpen the Reason to Believe and Single-Minded Idea

Do not write a brief without at least one live demand pull. The entire point of
the brief framework is that strategy should come from evidence, not from a
meeting room.

---

## Cross-Reference: All Skills

Master index of every skill in the MyTelescope marketing stack. The
orchestrator (SKILL.md) is the entry point — route through it when unsure
which skill to load next.

| Layer | Skill | File | Status |
|-------|-------|------|--------|
| Orchestrator | `mytelescope-orchestrator` | SKILL.md | Local |
| Foundation 1 | `strategic-recipe-brief` | strategic-recipe-brief-SKILL.md | This file |
| Foundation 2 | `mytelescope-product-thinking` | mytelescope-product-thinking-SKILL.md | Local |
| Foundation 3 | `mytelescope-core` | mytelescope-core/SKILL.md | External (org-level) |
| Tactic | `mytelescope-ai-visibility` | MyTelescope Ai Visibility skill.md | Local |
| Tactic | `mytelescope-content-strategy` | mytelescope-content-strategy-SKILL.md | Local |
| Tactic | `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | Local |
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Local |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | Local |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

**Direct downstream consumers of this skill's outputs:**
`mytelescope-product-thinking`, `mytelescope-core`, `mytelescope-content-strategy`,
`mytelescope-campaign-activation`, `mytelescope-copywriting`. Every one of those
skills opens by reading the Single-Minded Idea, Human Insight, and Reason to
Believe produced here.
