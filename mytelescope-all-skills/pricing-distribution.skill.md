---
name: mytelescope-pricing-distribution
description: >
  Use this skill whenever a user wants to define, test, or improve their pricing
  model or go-to-market distribution strategy. Trigger for: "how should we
  price this", "what pricing model makes sense", "freemium vs paid", "how do we
  reach buyers", "what channels should we sell through", "direct vs channel
  sales", "how do we get distribution", "pricing strategy", "go-to-market
  channels", "how do we scale distribution", "should we partner", "what's the
  right price point", or any request to connect the product to the buyer through
  the right model at the right price. Always cross-reference with demand signals
  from MyTelescope to validate pricing anchors and distribution channel demand
  before making recommendations.
allowed-tools: Bash, Read, Grep, Glob
---

# Pricing and Distribution Skill

## Purpose

Connect the product to the buyer through the right model, the right price, and
the right channels. Pricing and distribution are not operational decisions —
they are strategic ones. The wrong price signals the wrong value. The wrong
channel reaches the wrong buyer. Both are marketing problems before they are
sales or finance problems.

This skill runs in two phases: Pricing (model, anchor, packaging) and
Distribution (channels, motion, partnerships). Both are grounded in demand data
and the upstream product and brief context.

---

## Mandatory: Prerequisites Before Starting

1. **Product Thinking Brief** — required. The ICP, switching cost, and proof
   hierarchy directly determine the pricing model and channel motion.
2. **Strategic Recipe Brief** — required. The Single-Minded Idea determines
   what the price must signal about the brand.
3. **MyTelescope demand data** — mandatory. Pull competitor signals before
   making any channel recommendation.

If these do not exist, ask the user to confirm the ICP, the current alternative
buyers use, and the Single-Minded Idea before proceeding.

---

## Mandatory: Load MyTelescope Before Starting

1. Call `knowledge_search` with the brand name and category.
2. Call `search_signals` for competitor brand names to understand validated
   distribution models worth studying.
3. Call `get_demand_volume` for competitor signals to see relative scale.
4. Call `web_search` to find published pricing pages for top two or three
   competitors. Never recommend a pricing anchor without knowing what buyers
   are already anchored to.
5. Call `web_fetch` on competitor pricing pages to extract actual price points,
   model structure, and packaging language.

---

## The Interview: One Question at a Time

### Question 1: The Value Metric

> "What is the unit of value your product delivers — what grows as the customer
> gets more value from it? Is it users, employees trained, outcomes achieved,
> or something else?"

The value metric is the foundation of pricing. A strong value metric aligns
the product's success with the customer's success. A weak one misaligns
incentives and produces churn.

### Question 2: The Buyer's Budget Frame

> "When a buyer thinks about your product, which budget does it come from —
> L&D, software, headcount, or something else? And what is the typical annual
> size of that budget?"

This determines the pricing ceiling and the sales motion. Different budgets
mean different buyers, different conversations, and different competitive sets.

### Question 3: The Competitive Price Anchor

> "What is your customer currently paying for the alternative — a competing
> product, a consultant, or their own internal process?"

Price is always relative to an alternative. Present competitor pricing data
found via web_fetch before asking this — let the user react to real numbers,
not guesses.

### Question 4: The Risk Tolerance

> "How risk-averse is your buyer? Would they pay more for a proven solution or
> less to try something new? What reduces their perceived risk most — a trial,
> a pilot, a performance guarantee, or a reference customer?"

Risk tolerance shapes the go-to-market motion more than any other single
factor. Enterprise buyers in regulated industries need pilots and references.
Self-serve buyers need a free tier or low-friction trial.

---

## Phase 1: Pricing Model

### Step 1: Select the model

Recommend one primary pricing model based on the interview:

**Per seat / per user** — value scales with number of users. Common in
collaboration tools. Risk: penalises adoption.

**Per outcome / consumption** — charged per measurable result (completions,
milestones, outcomes). Aligns incentives. Harder to predict for the buyer.

**Tiered flat fee** — clear usage tiers with flat fee per tier. Predictable
for both sides. Risk: buyers optimise to stay below thresholds.

**Platform fee plus usage** — flat platform access plus variable consumption.
Works when there is a base value layer plus variable depth.

**Freemium** — free tier with paid upgrade. Works when: strong self-serve
value at small scale, low cost to serve free users, word-of-mouth growth.
Does not work for complex B2B with high onboarding cost.

**Pilot to contract** — every deal starts as a scoped pilot with defined
outcome and contract conversion path. Works for enterprise with high
switching costs and complex requirements.

After recommending, explain why alternatives are weaker for this specific
product and ICP.

### Step 2: Set the anchor and tiers

```
PRICING TIERS
──────────────────────────────────────────────

Tier 1 — [Name]
Price:       [Annual or monthly, per unit]
For:         [ICP segment]
Includes:    [Features and limits]
Designed to: [Reduce risk / drive trial / establish baseline]

Tier 2 — [Name] — PRIMARY REVENUE TIER
Price:       [Annual or monthly, per unit]
For:         [Primary ICP]
Includes:    [Full feature set for the use case]
Designed to: [This is where most revenue comes from]

Tier 3 — [Name]
Price:       [Custom / starting at X]
For:         [Large accounts with complex requirements]
Includes:    [Custom integrations, SLAs, dedicated support]
Designed to: [Anchor price perception upward]
```

### Step 3: Packaging language

Tier names are a marketing decision. They should reflect the outcome purchased,
not features included. Recommend naming that matches the Single-Minded Idea
and audience outcome language from demand signals.

---

## Phase 2: Distribution

### Step 1: Primary motion

Recommend one primary go-to-market motion:

**Self-serve / PLG** — the product sells itself through free trial or
freemium. Works for: ACV under $10k, self-serve ICP, strong product
experience, low onboarding complexity.

**Sales-assisted** — requires human touch to close but buyers initiate
through marketing. Works for: mid-market ACV ($10k to $100k), moderate
complexity, ICP that researches before buying.

**Enterprise sales** — complex deals, long cycles, multiple stakeholders.
Works for: ACV above $100k, regulated industries, high switching cost,
procurement involvement.

Most B2B products combine motions. If so, describe both and the transition
trigger.

### Step 2: Channel prioritisation

```
DISTRIBUTION CHANNEL STACK
──────────────────────────────────────────────

Priority 1: [Channel] — [Why first, what signal validates it]
Priority 2: [Channel] — [Why second]
Priority 3: [Channel] — [Why third]

On hold:         [Valid but require more resource or proof]
Not recommended: [Do not fit this ICP or model]
```

Channels to evaluate based on demand signals:

- Organic search and content — validated by Google/Bing demand signal volume
- LinkedIn outbound — validated for B2B ICPs with identifiable titles
- LinkedIn organic — validated for thought leadership categories
- Paid search — validated when commercial intent signals are high
- Industry events — validated when ICP has known gathering points
- Partner and reseller channels — validated when complementary products
  already reach the ICP at scale
- App marketplace — validated when ICP uses a platform with a marketplace
- Community and word-of-mouth — validated when ICP is a known community

### Step 3: Partnership opportunities

**Technology partnerships** — integrations with tools the ICP already uses.
List the top three platforms worth integrating with.

**Channel partnerships** — resellers, consultants, or agencies who already
sell to the ICP. For L&D, HR consulting firms and L&D agencies are natural
partners.

**Content partnerships** — co-publishing research or co-hosting events with
organisations that already have the ICP's attention.

---

## Output: The Pricing and Distribution Brief

```
PRICING AND DISTRIBUTION BRIEF
──────────────────────────────────────────────

Brand / Product:
Date:
Author:

──────────────────────────────────────────────
PRICING

Value metric:            [What scales with customer value]
Competitive anchor:      [What buyers currently pay for the alternative]
Recommended model:       [Model name and rationale]
Why not alternatives:    [One sentence per rejected model]

[Full tier output]

Packaging language:      [Recommended tier names and rationale]

──────────────────────────────────────────────
DISTRIBUTION

Primary motion:          [PLG / Sales-assisted / Enterprise + rationale]
Transition trigger:      [If hybrid — what triggers escalation]

[Full channel stack]

PARTNERSHIP OPPORTUNITIES

Technology:  [Top 3 integration targets]
Channel:     [Top 3 reseller or agency types]
Content:     [Top 3 co-publishing opportunities]

──────────────────────────────────────────────
PRICING PAGE RULES

- Publish /pricing.md — plain text parseable by AI systems
- Lead with outcome, not features
- Show the anchor tier prominently
- Include one specific ROI claim with a source
- Reduce risk at decision point — trial, pilot, or reference customer

──────────────────────────────────────────────
DEMAND SIGNALS USED

[MyTelescope signals that validated channel and pricing recommendations]

COMPETITOR PRICING RESEARCH

[Summary of competitor pricing found via web_fetch]
```

---

## Cookbook Rules

- **Price is a signal.** A low price signals low value regardless of what the
  product actually does. If outcomes are premium, price like a premium product
  and prove it.
- **The competitive anchor is not optional.** Never recommend a price without
  knowing what the buyer is currently paying. Pull competitor pricing first.
- **Distribution before acquisition.** Most companies spend on ads before they
  have a repeatable channel. The right channel is where the ICP congregates and
  trusts recommendations — not the cheapest impression.
- **Fewer channels done well.** Two channels executed consistently beat six
  done poorly. Build conviction in channel one before adding channel two.
- **Publish pricing openly.** "Contact us for pricing" loses to competitors
  who publish it — both in search and in AI recommendations.

---

## Cross-Reference Skills

- **product-thinking** — ICP, switching cost, and proof hierarchy feed
  pricing model and channel selection directly.
- **strategic-recipe-brief** — Single-Minded Idea determines price signal.
  Reason to Believe determines whether premium pricing is credible.
- **campaign-activation** — pricing model and primary channel determine
  campaign structure and budget allocation.
- **mytelescope-ai-visibility** — /pricing.md recommendation feeds directly
  into the AI visibility action plan.

---

## Key Tools

| Tool | Purpose |
|------|---------|
| `knowledge_search` | Load prior pricing or distribution context |
| `search_signals` | Find competitor demand and channel signals |
| `get_demand_volume` | Validate channel demand and competitor scale |
| `web_search` | Find competitor pricing pages |
| `web_fetch` | Read competitor pricing for anchor research |
| `calculate_demand_priorities` | Identify highest-volume category signals |

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
| Tactic | `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | This file |
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Local |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | Local |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

**Direct downstream consumers of this skill's outputs:**
`mytelescope-campaign-activation` (motion + channels → campaign structure),
`mytelescope-copywriting` (tier names + price points → pricing-page copy),
`mytelescope-ai-visibility` (open /pricing.md → citation surface).
**Upstream prerequisites:** `mytelescope-product-thinking` (ICP + switching cost),
`strategic-recipe-brief` (price signal vs. Single-Minded Idea).
