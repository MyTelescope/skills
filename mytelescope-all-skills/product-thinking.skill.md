---
name: mytelescope-product-thinking
description: >
  Use this skill whenever a user wants to define, sharpen, or stress-test their
  product strategy before going to market. Trigger for: "what problem does our
  product solve", "who is our product really for", "how are we different from
  competitors", "what's our product positioning", "jobs to be done", "product
  market fit", "why would someone buy this over X", "what's our ICP", "what
  makes us defensible", "where are the product gaps", or any request to connect
  product reality to marketing claims. Also trigger proactively when a strategic
  brief has been completed — product thinking must validate the Reason to Believe
  before demand data or a marketing plan is built. Always cross-reference with
  real demand signals from MyTelescope before completing any section.
allowed-tools: Bash, Read, Grep, Glob
---

# Product Thinking Skill

## Brand & Visual Rules

This skill defers to **`brand-rendering.skill.md`** for ALL visual + vocabulary rules — typography, color palettes, KPI card layout, chart specs, and data formatting. Load that skill in parallel whenever this one produces visual output, charts, or any text containing numbers / percentages / dates.

Minimum required behaviour (the full spec is in brand-rendering):

- Fonts: Instrument Serif for headings and numbers; Inter 300/400/500 for body. Never bold (600+).
- Colors: `#00CCFF` positive, `#FF6B6B` negative, `#323F5F` neutral.
- Cards: 6px radius, 0.5px `#D6D8DF` border, no shadows, no gradients.
- Text: always `var(--color-text-primary)` — never hard-code dark text.
- Status enum: Growing / Contracting / Flat only.
- Trend enum: Accelerating / Decelerating / Stable + pp delta.
- Vocabulary: "demand signals", "consumer interest", "demand" — never "search volume", "keywords", "SEO", "indexed data".
- Volumes: `1.2k` not `1200`; always include sign: `+12.4%` not `12.4%`.

---

## Purpose

Bridge the gap between what a product does and what marketing claims it does.
Most marketing fails not because the message is wrong but because the product
claim has no proof, the wrong audience was chosen, or a competitor already owns
the space. This skill stress-tests all three before any plan is built.

It runs in three phases: Jobs to Be Done (what problem is being solved and for
whom), Differentiation (what the product does that competitors structurally
cannot copy), and Proof (what evidence makes the claim credible to a skeptical
buyer). Every section is validated against real demand data.

---

## Mandatory: Load MyTelescope Before Starting

Before running the interview, pull real data:

1. Call `knowledge_search` with the product name and category to load any
   prior context or frameworks.
2. Call `search_signals` for the product category and top 2-3 named competitors
   to understand what language buyers actually use and who currently owns which
   territory in demand.
3. Call `get_demand_volume` to confirm whether the category is Growing, Flat,
   or Contracting — this shapes the differentiation urgency and proof standard.

Do not start the interview without demand data in hand. The entire point of
this skill is that product decisions should be grounded in what the market
actually wants, not what the founder believes it wants.

---

## Prerequisite Check: Strategic Brief

If a Strategic Recipe Brief has already been completed, read it before starting.
Extract:
- The Single-Minded Idea — this is the product claim to validate
- The target audience — this is the ICP to stress-test
- The Reason to Believe — these are the proof points to confirm or challenge

If no brief exists, note this and recommend running the strategic-recipe-brief
skill first. Product thinking is more valuable when it has a brief to push
against. It can run standalone, but the output will be less sharp without one.

---

## The Interview: One Question at a Time

Walk the user through each phase in order. Ask one question per turn. After
each answer, reflect back what you heard, flag gaps or conflicts with demand
data, and move to the next. Do not rush — a weak answer in Phase 1 produces a
wrong answer in Phase 3.

---

## Phase 1: Jobs to Be Done

The job-to-be-done framework asks: what progress is the customer trying to make
in their life or work, and what are they hiring this product to do? The job is
never "use our software." The job is always an outcome the customer wants.

### Question 1: The Trigger

> "When your ideal customer decides to look for something like your product,
> what has just happened in their world? What triggered the search?"

After their answer, cross-reference with demand signals. If the trigger maps to
a Growing signal, confirm it. If it does not appear in demand data at all, flag
that the trigger may be real but not yet a broad market behaviour — or that the
audience is different from who is actually searching.

### Question 2: The Outcome

> "When the customer has used your product successfully for 90 days, what is
> different about their situation? Be specific — not 'they learned more' but
> what can they now do, avoid, or achieve that they could not before?"

Push for specificity. Vague outcomes ("they feel more confident") cannot be
marketed or measured. Specific outcomes ("new hires reach full productivity in
3 weeks instead of 8") can be. If the user gives a vague answer, ask: "What
would their manager notice that is different?"

### Question 3: The Current Alternative

> "What is your customer doing right now instead of using your product? This
> could be a competitor, a workaround, a manual process, or simply doing
> nothing."

This is critical. The real competitor is rarely another software product. It is
often a spreadsheet, a consultant, a manual process, or inertia. The marketing
plan needs to know what it is actually displacing.

Cross-reference with competitor demand signals. If a named competitor is
Growing faster than the category, that is a market signal about where buyers
are already going and what message is already working.

### Question 4: The Switching Cost

> "What would your customer have to give up or change to adopt your product?
> What makes switching hard, and who inside the company has to approve it?"

B2B products almost always have a switching cost that marketing underestimates.
If the answer is "they have to migrate data, retrain staff, and get sign-off
from procurement," that changes the sales cycle, the ICP, and the messaging
entirely. A pilot or trial offer may be necessary to reduce perceived risk.

---

## Phase 2: Differentiation

Differentiation is not a list of features. It is the one thing the product does
that competitors structurally cannot replicate because of technology, data,
business model, or distribution. If a well-funded competitor could copy it in
6 months, it is a feature, not a differentiation.

### Question 5: The Structural Advantage

> "What does your product do that a well-funded competitor could not simply copy
> in 6 to 12 months? What makes it structurally hard to replicate?"

Valid answers: proprietary data, network effects, a novel model or algorithm,
deep workflow integration, a distribution moat, or a category-defining brand.
Invalid answers: "we have better UX" or "we move faster" — those are temporary.

If the user cannot answer this, flag it honestly. A product without structural
differentiation is not unmarketable, but the strategy must be different:
typically faster to market, lower price point, or a niche the incumbents ignore.

### Question 6: The Comparison Frame

> "When a buyer compares you to alternatives, what is the frame you want them
> to use? And what frame do your competitors want them to use?"

This is the positioning battle. The marketing must actively set the comparison
frame before the buyer sets it themselves. Cross-reference with demand signals.
If buyers are already searching "[Brand] vs [Competitor]," the frame is being
set without you and you need to own that territory with content immediately.

### Question 7: The Category

> "What category does your product belong to — and is that the right category,
> or would a different category serve you better?"

Category choice is one of the highest-leverage positioning decisions. A product
that calls itself an LMS competes with established players on their terms. A
product that calls itself "the first AI that teaches complex material" creates a
new category and sets its own evaluation criteria.

Check demand signal volume for both the existing category name and any
alternative the user proposes. A new category only works if there is emerging
demand for the problem it describes. Creating a category with no search signal
means educating a market that does not yet know it has the problem — expensive
and slow.

---

## Phase 3: Proof

A claim without proof is a promise. A promise from a company no one has heard
of is noise. This phase pins down what evidence exists — or needs to be created —
to make the product claim credible to a skeptical buyer who has been oversold
before.

### Question 8: The Best Customer Result

> "Describe your single best customer result so far. What was the situation
> before, what did they do with your product, and what was the measurable
> outcome? Be as specific as possible."

If the user has a strong answer, this becomes the centrepiece of every marketing
asset. If the answer is vague or does not exist yet, that is the most important
thing to go and get before spending on marketing. A pilot with one reference
customer is worth more than any campaign at this stage.

### Question 9: The Skeptic's Objection

> "What does a smart, experienced buyer in your space say when they push back
> on your product? What is the most credible version of 'this sounds too good
> to be true'?"

Every strong marketing brief anticipates the objection. The brief needs to
pre-empt that objection with evidence that is structurally different from what
the skeptic has heard before. If you cannot answer this question, you have not
talked to enough skeptical buyers yet.

### Question 10: The Proof Hierarchy

> "Rank these proof types in order of what you can actually provide today:
> named customer case study with metrics, third-party research, pilot or trial
> offer, live demonstration, testimonials, awards or press coverage."

After they rank, identify the gap. If the highest-credibility proof does not
exist, the first marketing priority is creating it — not running ads or
producing content that references claims with no backing.

---

## Output: The Product Thinking Brief

Once all three phases are complete, render the output as a clean structured
brief. This document feeds directly into the Strategic Recipe Brief (Reason to
Believe), the marketing plan (positioning and ICP), and the content skill
(proof-point content priorities).

```
PRODUCT THINKING BRIEF
──────────────────────────────────────────────

Brand / Product:
Date:
Author:

──────────────────────────────────────────────
JOBS TO BE DONE

Primary job:         [The outcome the customer is hiring this product to achieve]
Trigger event:       [What happens in their world that starts the search]
Current alternative: [What they are doing instead right now]
Switching cost:      [What they give up or must change to adopt]

──────────────────────────────────────────────
ICP — IDEAL CUSTOMER PROFILE

Who gets the most value fastest:   [Company type, size, sector]
Economic buyer:                    [Title of who approves the purchase]
Daily user:                        [Title of who uses it every day]
Readiness signal:                  [What makes them ready to buy now]

──────────────────────────────────────────────
DIFFERENTIATION

Structural advantage:  [What competitors cannot copy in 12 months]
Comparison frame:      [How you want buyers to compare you]
Category claim:        [What category you are creating or owning]

──────────────────────────────────────────────
PROOF

Best result to date:      [Named customer, situation, measurable outcome]
Strongest proof type:     [Case study / research / demo / trial]
Key skeptic objection:    [The most credible pushback and your answer]

──────────────────────────────────────────────
GAPS TO CLOSE BEFORE MARKETING

[List any claims above that currently lack proof.
These are product or sales actions, not marketing tasks.]

──────────────────────────────────────────────
DEMAND SIGNALS USED

[Cite the MyTelescope signals that validated or challenged
each section — channel, term, trend, volume]
```

---

## The Gaps Section: How to Use It

This is the most important part of the output and the most commonly skipped.

- If the primary job has no named customer example yet: go get one before
  spending on acquisition marketing.
- If the structural advantage is actually just a feature: either find the real
  advantage or reposition into a niche where the feature is sufficient.
- If the comparison frame is being set by competitors: create content that
  actively resets it before launching any campaign.
- If the proof hierarchy is weak: a pilot or trial offer is the first marketing
  asset to build, not an ad.

Marketing cannot fix a product gap. It can only amplify what is already true.
The gaps section tells the user what to fix before marketing is asked to carry
the weight.

---

## Cookbook Rules

- **Specificity beats completeness.** One sharp, specific, provable claim beats
  five vague ones. Push the user toward the single strongest thing they can say
  in one sentence with a number in it.
- **The current alternative is the real competitor.** Not the software on a G2
  comparison page — the behaviour the product is displacing. Never skip this.
- **Proof is a product problem, not a marketing problem.** If proof does not
  exist, the answer is not "we'll get a testimonial." The answer is "run a
  pilot with a reference customer before the campaign launches."
- **Demand data overrides assumption.** If the user believes their ICP is
  mid-market SaaS but demand signals show enterprise L&D searching for this
  category, flag the discrepancy. Ask which one they want to pursue.
- **Category creation is high-risk, high-reward.** Only recommend it if there
  is emerging demand for the problem the new category describes.

---

## Cross-Reference Skills

- **strategic-recipe-brief** — run before this skill if possible. The
  Single-Minded Idea and Reason to Believe are direct inputs to Phase 3.
- **mytelescope-core** — mandatory for Phases 1 and 2. Competitor signals,
  category trend, and exact audience language all come from here.
- **content** — the proof section directly generates content priorities.
  The best customer result becomes the hero case study. The skeptic objection
  becomes FAQ and comparison content.
- **campaign-activation** — the comparison frame and category claim from
  Phase 2 become the campaign positioning and ad copy direction.
- **pricing-distribution** — the switching cost and ICP from Phase 1 directly
  inform pricing model and channel decisions.

---

## Key Tools

| Tool | Purpose |
|------|---------|
| `knowledge_search` | Load prior context, frameworks, competitive landscape |
| `search_signals` | Find competitor demand signals and category language |
| `get_demand_volume` | Confirm category trend and competitor signal volumes |
| `calculate_demand_priorities` | Identify highest-volume signals in category |
| `web_search` | Verify competitor positioning and category claims |
| `web_fetch` | Read competitor sites to map their comparison frame |

---

## Cross-Reference: All Skills

Master index of every skill in the MyTelescope marketing stack. The
orchestrator (SKILL.md) is the entry point — route through it when unsure
which skill to load next.

| Layer | Skill | File | Status |
|-------|-------|------|--------|
| Orchestrator | `mytelescope-orchestrator` | SKILL.md | Local |
| Foundation 1 | `strategic-recipe-brief` | strategic-recipe-brief-SKILL.md | Local |
| Foundation 2 | `mytelescope-product-thinking` | mytelescope-product-thinking-SKILL.md | This file |
| Foundation 3 | `mytelescope-core` | mytelescope-core/SKILL.md | External (org-level) |
| Tactic | `mytelescope-ai-visibility` | MyTelescope Ai Visibility skill.md | Local |
| Tactic | `mytelescope-content-strategy` | mytelescope-content-strategy-SKILL.md | Local |
| Tactic | `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | Local |
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Local |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | Local |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

**Direct downstream consumers of this skill's outputs:**
`mytelescope-content-strategy` (proof hierarchy → content priority),
`mytelescope-pricing-distribution` (ICP + switching cost → pricing model),
`mytelescope-campaign-activation` (comparison frame + gaps → campaign angle),
`mytelescope-copywriting` (best customer result + skeptic objection → proof copy).
**Upstream prerequisite:** `strategic-recipe-brief`.
