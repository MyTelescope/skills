---
name: mytelescope-copywriting
description: >
  Use this skill whenever a user wants to write, improve, or review marketing
  copy. Trigger for: "write copy for", "write this ad", "write a LinkedIn post",
  "write our homepage", "write an email", "write a case study", "write product
  descriptions", "write a sales page", "improve this copy", "make this
  better", "write in our tone", "rewrite this", "write a cold outreach message",
  "write our value proposition", or any request to produce written marketing
  content. This skill uses MyTelescope knowledge_search to load proven
  copywriting frameworks before writing any copy. Always ground copy in real
  demand signal vocabulary — the exact language the audience uses — pulled from
  MyTelescope before writing. Never write copy without knowing the Single-Minded
  Idea, the audience, and at least one proof point.
allowed-tools: Bash, Read, Grep, Glob
---

# Copywriting Skill

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

Write marketing copy that earns attention, makes a specific claim, and moves
the reader to a specific action. Not copy that sounds like marketing. Copy that
sounds like a human being who understands the reader's problem better than they
do.

This skill covers every copy format in the marketing stack: homepage, landing
pages, ads, LinkedIn posts, email sequences, case studies, outbound messages,
and product descriptions. Every format follows the same underlying logic, with
different length and structural constraints.

---

## Mandatory: Load MyTelescope Knowledge Base Before Writing

Before writing any copy, call `knowledge_search` to load relevant frameworks
from the MyTelescope knowledge base. Use queries matched to the copy type:

- "copywriting frameworks B2B SaaS" for product and landing page copy
- "LinkedIn post structure" for social content
- "email subject line" for email campaigns
- "case study structure" for proof-point content
- "outbound message cold email" for prospecting copy
- "value proposition" for positioning statements
- "ad copy" for paid media

Always load the knowledge base first. The frameworks there reflect proven
patterns — do not default to generic copywriting advice when specific
frameworks exist.

Then call `search_signals` to load the exact vocabulary the audience uses for
this category. The words that appear in demand signals are the words that belong
in the copy.

---

## Mandatory: Context Before Writing

Never start writing without confirming these four inputs. If they are not in
the conversation already, ask for them:

1. **The Single-Minded Idea** — the one thing the copy must communicate.
   If the user does not have one, run the strategic-recipe-brief skill first.

2. **The audience** — who is reading this, what do they already believe, and
   what do they need to believe differently after reading it.

3. **One proof point** — the specific evidence that makes the claim credible.
   A named customer, a result with a number, or a demonstration. Copy without
   proof is a promise. Promises from unknown brands are ignored.

4. **The CTA** — one thing the reader should do next. If the user gives more
   than one, push back and ask which one matters most.

If any of these are missing, ask for them before writing a single word.

---

## The Copywriting Principles

Apply these to every piece of copy regardless of format. They are not
stylistic preferences — they are the structural conditions for copy that works.

### 1. Lead with the reader, not the brand

The first sentence must be about the reader's situation, problem, or feeling —
not about the brand, the product, or the company. A reader who sees themselves
in the first sentence keeps reading. A reader who sees a product pitch stops.

Wrong: "Uniplay is an AI-powered learning platform for complex material."
Right: "Your team completed the training. They still cannot do the job."

### 2. Earn attention before asking for it

Every piece of copy is an interruption. The reader did not ask to see it. The
first job is to make them glad they did — by saying something they recognise,
something surprising, or something that reframes a problem they already have.

### 3. One claim, stated plainly

The copy should make one claim. Not three. Not a list of benefits. One specific
thing that is true about this product and matters to this audience. State it
plainly — in the simplest words possible. Complexity is not sophistication.
Simplicity is.

### 4. Use the audience's vocabulary

Copy must use the exact language that appears in demand signals — the words
people actually type when they are looking for this category. Not the brand's
internal terminology. Not the category jargon. The words the reader uses when
they are alone with the problem.

Pull vocabulary from MyTelescope `search_signals` before writing. Use those
exact phrases in headlines, subheadings, and the opening sentence.

### 5. Proof before claim, not after

The natural instinct is to state the claim and then provide proof. Reverse it.
Open with the proof — the result, the example, the data point — and let the
claim follow from it. Proof first makes the claim feel earned. Claim first makes
the proof feel like an excuse.

Wrong: "Uniplay delivers mastery, not just completion. Customers see 3x improvement."
Right: "One customer's new hires reached full productivity in 3 weeks instead of 8. Here is how."

### 6. Short sentences. Active verbs. No qualifiers.

Every sentence should be as short as it can be without losing meaning. Active
verbs move the reader forward. Passive constructions stop them. Qualifiers
("quite", "very", "essentially", "somewhat") dilute every claim they touch.

### 7. The CTA earns the action

The call to action is a request. Like any request, it is more likely to be
granted if the reader understands what they get. "Request a demo" is a weak
CTA because it says nothing about what the reader gains. "See how [Customer]
cut onboarding time by 60%" is a stronger CTA because it names a specific
outcome the reader wants.

---

## Format Guides

### Homepage / Landing Page

**Structure:**

Hero (above the fold):
- Headline: The Single-Minded Idea in 6 to 10 words. Use demand signal
  language. No brand name needed in the headline.
- Subheadline: The specific audience and the specific outcome. One sentence.
  Names who it is for and what changes.
- CTA: One button. Outcome-led label. Not "Get Started" — "See how it works"
  or "Start a free pilot."
- Social proof: One specific data point or one named customer result directly
  beneath the CTA.

Problem section:
- Two to three sentences naming the problem in the audience's language.
- This should read like the reader's own internal monologue.
- No product mention in this section.

Solution section:
- One paragraph. What the product does, for whom, and what changes.
- Use the comparison frame from Product Thinking Brief.
- Maximum 60 words.

Proof section:
- Named case study with before-and-after numbers.
- Attributed quote with name, title, company.
- One specific metric that would matter to the primary ICP.

Features section (if needed):
- Each feature described as an outcome, not a capability.
- Wrong: "Adaptive learning algorithm"
- Right: "Adjusts to how each employee learns so complex material sticks."

Final CTA:
- Repeat the primary CTA with a risk-reduction element (free trial, no
  credit card, cancel anytime, 30-day pilot).

### LinkedIn Post

**Structure (the three-line hook rule):**

The first three lines must earn the click to expand. Everything else is the
payoff of the promise made in those three lines. LinkedIn truncates at roughly
120 characters — those characters are the entire campaign.

Hook options:
- The counter-intuitive statement: "AI training tools are making corporate
  learning worse." (Tension that demands an explanation.)
- The specific number: "One team cut onboarding from 8 weeks to 3. Here is
  exactly what changed." (Proof that implies a lesson.)
- The direct question: "Why do employees complete training and still cannot
  do the job?" (The problem the reader recognises.)

Body:
- Deliver on the hook's promise specifically.
- Use short paragraphs — one to two sentences each.
- No jargon. No corporate language. Write as one person to one person.
- Include one piece of evidence — a number, a customer story, or a
  demand signal finding from MyTelescope.

Close:
- One specific takeaway in a single sentence.
- Optional: one question that invites engagement (only if genuine).
- No "What do you think?" — earn the engagement with the content itself.

Length: 150 to 300 words for most posts. Up to 500 for genuine long-form
thought leadership. Never longer unless the content earns every word.

Formatting: Line breaks after every sentence. No bullet lists in the main
body — they kill the rhythm. Bullets only for structured takeaways at the end.

### Cold outbound message (LinkedIn / email)

**The one rule: give before you ask.**

Every cold outreach message that leads with the product loses. Every message
that leads with something useful to the reader has a chance.

Structure:

Line 1 — Personalisation that is not flattery:
Reference something specific — a post they wrote, a signal about their company,
a challenge their industry is facing. One sentence. Do not compliment them.

Line 2 — The insight:
One specific, useful observation relevant to their role. This is where demand
signal data from MyTelescope is genuinely useful — a trend in their category
they may not have seen. Not an advertisement. An insight.

Line 3 — The connection:
One sentence connecting the insight to what the product does. Not a pitch.
A logical link.

Line 4 — The ask:
The smallest possible ask. Not a demo. Not a call. A reaction: "Does this
match what you are seeing?" or "Worth a quick conversation?" One question.

Total length: under 100 words for LinkedIn. Under 150 words for email.

### Case study

**Structure:**

Headline: The outcome first — the result before the name.
"How [Company type] cut [metric] by [X%] in [timeframe]."
Not: "[Customer name] sees success with [Product]."

The situation (50 to 80 words):
What the company was dealing with before. Describe the problem in their
language — quote the customer if possible. No product mention yet.

The problem (30 to 50 words):
The specific thing that was not working. One sentence on why the previous
approach failed or was insufficient.

The solution (50 to 80 words):
What they did with the product. Specific actions, not general statements.
How long it took to implement. What changed in their workflow.

The result (30 to 50 words):
The specific measurable outcome. Numbers. Timeframe. Attributed to the
customer by name and title. This section should be quotable — a single
sentence the reader could repeat to a colleague.

The quote:
One attributed quote. Named. Title. Company. The quote should express the
result or the experience in the customer's own words — not a testimonial
for the product, but a statement of what changed for them.

### Email subject lines

The subject line has one job: get the email opened. It does not sell the
product. It sells the email.

Three patterns that work for B2B:

Pattern 1 — The specific result: "How [Company] cut [metric] by [X]"
Pattern 2 — The direct question: "Why does [common problem] keep happening?"
Pattern 3 — The named audience: "[Title] — this might be useful"

Rules:
- Under 50 characters where possible — most email clients show 40 to 60
- No clickbait that cannot be delivered — the email must earn the subject line
- No ALL CAPS, excessive punctuation, or vague intrigue
- Personalisation that is not "[First Name]" — reference their company,
  industry, or a relevant signal from demand data

---

## Tone Rules (Universal)

Apply to all copy regardless of format. These come from the tone section of
the Strategic Recipe Brief. If no tone guidance exists, default to:

- Direct without being blunt — say what you mean, do not bury it
- Specific without being jargony — numbers and names, not categories and
  abstractions
- Confident without being arrogant — the claim is stated plainly, not
  performed loudly
- Human without being casual — this is a professional product for
  professional people, but it is written by a person for a person

What to avoid in all copy:
- Em dashes used as stylistic filler
- "Excited to share" or "thrilled to announce"
- "Leverage" as a verb
- "Seamless" or "robust" or "cutting-edge"
- "We believe that..." (no one cares what you believe — show them)
- Passive voice constructions
- Sentences that start with "As a [role]..."
- Lists of features without outcome context

---

## Review Checklist

Before delivering any copy, run through this checklist:

- Does the first sentence lead with the reader, not the brand?
- Is there one clear claim — and only one?
- Is there at least one proof point with a specific number or named source?
- Does the copy use demand signal vocabulary from MyTelescope?
- Is the CTA one thing, outcome-led, and matched to the campaign goal?
- Would a skeptical, experienced buyer in this category find this credible?
- Is every sentence as short as it can be without losing meaning?
- Have all qualifiers ("quite", "very", "essentially") been removed?
- Does this sound like a person talking to a person, or like a brand talking
  at an audience?

If the answer to any of these is no, fix it before delivering.

---

## Output Format

For every copy deliverable, produce:

1. **The copy itself** — clean, formatted for the channel, ready to use.

2. **The rationale** — two to three sentences on why each key decision was
   made. What demand signal informed the vocabulary. What proof point was
   chosen and why. What the hook is doing.

3. **The alternatives** — one alternative headline or hook. The user should
   have a choice without having to ask.

4. **The test** — if this is digital copy, name the one element worth A/B
   testing first (usually the headline or the CTA label).

---

## Cookbook Rules

- **Write to one person.** Not "customers." Not "decision-makers." One specific
  person in a specific situation. The copy gets better every time the audience
  gets more specific.
- **Read it out loud.** If you stumble, the reader will too. If it sounds like
  a brochure when spoken, it reads like one too.
- **Cut the first sentence.** Most first drafts have a warm-up sentence that
  should be deleted. The real opening is usually sentence two.
- **Never explain the metaphor.** If the copy needs a footnote to land, the
  metaphor is wrong.
- **The best copy makes the reader feel understood before it makes them feel
  sold to.** In that order.

---

## Cross-Reference Skills

- **strategic-recipe-brief** — Single-Minded Idea, Human Insight, and tone
  are mandatory inputs. Always check before writing.
- **product-thinking** — the best customer result and the skeptic's objection
  are the two most valuable inputs for any proof-led copy.
- **content-strategy** — the demand signal vocabulary and topic priorities
  from this skill inform the headline language and body structure.
- **campaign-activation** — the creative brief from this skill is the direct
  brief for copywriting output.
- **mytelescope-core** — always call `search_signals` to load audience
  vocabulary before writing any headline or opening line.

---

## Key Tools

| Tool | Purpose |
|------|---------|
| `knowledge_search` | Load copywriting frameworks from MyTelescope knowledge base |
| `search_signals` | Load exact audience vocabulary for the category |
| `get_demand_volume` | Confirm which terms have highest demand — use in headlines |
| `calculate_demand_priorities` | Identify the highest-volume vocabulary to lead with |
| `web_search` | Check competitor messaging and avoid duplication |
| `web_fetch` | Read competitor copy to find gaps and contrarian angles |

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
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Local |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | This file |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

**Position in the stack:** terminal — copywriting is where every upstream
output lands and becomes a written asset.
**Upstream prerequisites:** `strategic-recipe-brief` (Single-Minded Idea, tone),
`mytelescope-product-thinking` (proof + objection), `mytelescope-core`
(audience vocabulary), `mytelescope-content-strategy` (topic + format),
`mytelescope-campaign-activation` (creative brief), `mytelescope-pricing-distribution`
(tier names for pricing-page copy).
