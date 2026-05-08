---
name: mytelescope-content-strategy
description: >
  Use this skill whenever a user wants to plan, build, or improve a content
  programme. Trigger for: "content strategy", "what should we write about",
  "content calendar", "content plan", "what topics should we cover", "blog
  strategy", "LinkedIn strategy", "content for SEO", "thought leadership plan",
  "editorial calendar", "content pillars", "what content do we need", or any
  request to turn a marketing strategy into a specific content plan with topics,
  formats, and a calendar. Also trigger proactively when a marketing plan has
  been completed — content is the primary execution layer for brand building and
  AI visibility. Always pull real demand signals from MyTelescope before
  recommending any topic. Never suggest a topic that is not grounded in actual
  audience demand data.
allowed-tools: Bash, Read, Grep, Glob
---

# Content Strategy Skill

## Purpose

Turn a marketing strategy into a specific, executable content programme —
grounded in real demand signals, structured for AI visibility, and built around
the audience language people actually use, not the language the brand prefers.

Content strategy here means four things working together: the right topics
(grounded in demand data), the right formats (matched to intent and channel),
the right calendar (prioritised by business impact), and the right structure
(built to be cited by AI systems and found by search).

---

## Mandatory: Prerequisites Before Starting

This skill requires inputs from upstream skills. Check what exists before
proceeding:

1. **Strategic Recipe Brief** — required. The Single-Minded Idea and Human
   Insight define what the content is trying to say. Without a brief, content
   has no north star and becomes a random collection of posts.

2. **Product Thinking Brief** — strongly recommended. The proof hierarchy and
   best customer result define which content pieces are most credible and
   should be built first.

3. **MyTelescope demand data** — mandatory. Every topic must be validated
   against real demand signals before it goes into the calendar. Pull data
   before recommending topics.

If brief or product thinking outputs do not exist, note the gap and ask the
user to confirm the Single-Minded Idea and one proof point manually before
proceeding. Do not build a content plan without at least these two inputs.

---

## Mandatory: Load MyTelescope Before Starting

1. Call `knowledge_search` with the brand name and category to load any prior
   content frameworks or research.
2. Call `search_signals` using the Single-Minded Idea terms, key proof points,
   competitor names, and category terms.
3. Call `get_demand_volume` for the top signals to understand volume and trend.
4. Call `calculate_demand_priorities` to rank signals by total volume — this
   becomes the topic priority list.
5. Call `calculate_emerging_demand` to find fast-growing signals that represent
   content opportunities before competitors move in.

---

## The Interview: One Question at a Time

### Question 1: Audience and Funnel Position

> "Who is the primary reader of this content — and where are they in their
> buying journey? Are they discovering the problem exists, actively researching
> solutions, or close to a decision?"

Content strategy is entirely different at each funnel stage. Top-of-funnel
content builds brand and trust with the 95% who are not yet in market. Bottom-
of-funnel content converts the 5% who are. Most brands over-invest in the
bottom and starve the top. Flag this if it applies.

### Question 2: Channels

> "Where does your audience actually spend time? Which channels are you
> committing to — and which ones are you willing to drop so you can do fewer
> things well?"

Most brands try to be everywhere and are nowhere. A focused content programme
on two channels done consistently beats six channels done poorly. Push the user
to commit to a maximum of two or three primary channels.

### Question 3: Publishing Capacity

> "How much can you actually publish, consistently, without burning out or
> dropping quality? One long piece per week? Two short posts? Give me the real
> number, not the aspirational one."

The content calendar must fit the real capacity, not the ideal one. An
ambitious calendar that collapses in month two is worse than a modest calendar
maintained for a year. Build for consistency first.

### Question 4: Owned Proof Points

> "What do you have that no one else has — data, research, customer results,
> a unique point of view? This is the raw material for content that cannot
> be copied."

Generic content does not get cited by AI, does not rank, and does not build
brand. Unique content — original data, named case studies, distinctive
perspective — does all three. Identify the proprietary assets before building
the plan.

---

## Phase 1: Topic Discovery from Demand Data

After the interview, run the full MyTelescope signal pull. Build the topic list
from what the data shows, not from what the user guesses.

### Step 1: Map signals to content intent

For each signal returned, classify intent:

- **Awareness intent** — "what is [category]", "why does [problem] happen",
  "how does [process] work" — top-of-funnel, educational content
- **Consideration intent** — "best [category] platforms", "[category] vs
  [alternative]", "how to choose [category]" — mid-funnel, comparison content
- **Decision intent** — "[brand name]", "[brand] pricing", "[brand] reviews",
  "[brand] vs [competitor]" — bottom-of-funnel, conversion content
- **Emerging signals** — fast-growing terms with low current content coverage —
  first-mover opportunity

### Step 2: Prioritise by volume and strategic fit

Rank topics by: (1) demand volume, (2) alignment with Single-Minded Idea,
(3) proof availability, (4) competitor content gap. The intersection of high
volume, on-brief, and low competition is the highest-priority content to create.

### Step 3: Build the pillar structure

Group topics into three to five content pillars — the core themes the brand
will own. Each pillar should:

- Map to a stage in the buyer journey
- Have at least three to five supporting topics under it
- Connect to a demand signal cluster from MyTelescope
- Align with a proof point from the Product Thinking Brief

Present the pillars to the user for confirmation before building the calendar.

---

## Phase 2: Format Selection

Match each topic to the format that best serves the intent and channel.

### Format guide

| Intent | Best format | Why |
|--------|-------------|-----|
| Awareness | Long-form guide, explainer, data report | Builds authority, gets cited by AI |
| Consideration | Comparison article, "best of" list, FAQ page | High citation rate (~33% for comparisons) |
| Decision | Case study, demo video, pricing page | Named proof converts skeptics |
| Emerging signal | Opinion piece, data post, LinkedIn thread | First-mover advantage before competitors |
| Brand building | Founder story, behind-the-scenes, point of view | Builds the 95% who are not yet in market |

### AI visibility format rules

These formats get cited most by AI systems (ChatGPT, Perplexity, Google AI
Overviews). Prioritise them for all high-priority topics:

1. Comparison articles (~33% of AI citations) — structured, balanced, named
2. Definitive guides (~15%) — comprehensive, authoritative, frequently updated
3. Original research with data (~12%) — unique, citable, with methodology
4. Structured FAQs (~10%) — direct answers to exact questions people ask
5. Named case studies with metrics (~10%) — specific, verifiable outcomes

Avoid: generic blog posts without structure, gated content (AI cannot access
it), undated content, thin pages with only marketing language.

---

## Phase 3: The Content Calendar

Build a 90-day calendar. Structure it as:

**Week 1 of each month:** One flagship piece (long-form guide, original data,
or definitive comparison) — this is the anchor content that earns AI citations
and backlinks.

**Weeks 2 and 3:** Two to three supporting pieces (shorter posts, LinkedIn
threads, case studies) that link to and reinforce the flagship.

**Week 4:** One proof-point piece (customer result, data update, or point-of-
view post) — this is the credibility layer that makes the brand citable.

### Calendar output format

```
CONTENT CALENDAR — [BRAND] — [MONTH]
──────────────────────────────────────────────────────────────────

PILLAR: [Pillar name]
DEMAND SIGNAL: [MyTelescope signal that grounds this topic]
VOLUME: [Monthly demand] | TREND: [Growing / Flat / Contracting]

Week 1
  Title:    [Working headline — use audience language from demand data]
  Format:   [Long-form guide / Comparison / Case study / FAQ / Data report]
  Intent:   [Awareness / Consideration / Decision]
  Channel:  [Blog / LinkedIn / YouTube / Email]
  CTA:      [What the reader should do next]
  Proof:    [Which proof point from the Product Thinking Brief this uses]
  AI note:  [Why this format/topic will earn AI citations]

Week 2
  [Repeat structure]

Week 3
  [Repeat structure]

Week 4
  [Repeat structure]

──────────────────────────────────────────────────────────────────
```

Render three months of calendar output. After month one, the user should have
enough real-world data (what got engagement, what got cited, what converted)
to refine the plan for months four through six.

---

## Phase 4: Content Structure Rules

Every piece of content produced under this strategy must follow these structural
rules to maximise AI citation and search performance. Hand these to any writer
or agency producing content for the brand.

### Lead with the answer

Every article, guide, or page must open with a direct answer to the question
it promises to answer — in the first paragraph, ideally in the first sentence.
AI systems extract the first clear answer they find. Burying the answer in
paragraph four means the content will not be cited.

### Use demand signal language in headings

Every H2 and H3 heading must use the exact language people use in search — the
terms that surfaced in MyTelescope. Not the brand's internal terminology.
"AI-powered knowledge transfer" is internal language. "AI employee training"
is what buyers search for.

### Keep answer blocks to 40 to 60 words

The optimal passage length for AI extraction is 40 to 60 words. Every key
claim should be expressible in one tight paragraph that stands alone. If it
requires context to understand, it will not be extracted.

### Cite sources and use statistics

Per Princeton GEO research, citing sources gives a +40% AI visibility boost.
Adding statistics with dates gives +37%. Every content piece should have at
least two cited statistics and one named source. Generic claims ("studies
show") do not count — named sources with dates do.

### Freshness signals

Every piece must have a visible publication or last-updated date. Undated
content loses to dated content in AI citation because recency is a quality
signal. Update high-priority pages at least quarterly.

### Comparison tables beat prose

For any content comparing options, alternatives, or approaches, use a
structured table rather than prose. Tables are extracted directly by AI
systems and rank highly in comparison queries.

---

## Phase 5: Distribution Plan

Content that is not distributed does not exist. For each piece, specify:

**Owned distribution:** Email list, LinkedIn company page, founder personal
LinkedIn, internal Slack or newsletter.

**Earned distribution:** Outreach to journalists, analysts, or industry
newsletters who cover the category. Identify three to five publications where
a guest post or mention would reach the ICP directly.

**AI distribution:** Submit the domain to directories that feed AI training
data. Ensure robots.txt allows GPTBot and PerplexityBot. Publish an llms.txt
file summarising what the brand does and links to key pages.

**Third-party signals:** G2, Capterra, or TrustRadius review profiles for B2B.
Quora answers for category questions. Reddit presence in relevant communities.
These third-party sources are cited 6.5x more often than brand domains by AI
systems.

---

## Output: The Content Strategy Document

```
CONTENT STRATEGY
──────────────────────────────────────────────

Brand:
Date:
Single-Minded Idea (from brief):

──────────────────────────────────────────────
CONTENT PILLARS

Pillar 1: [Name] — [Demand signal, volume, trend]
Pillar 2: [Name] — [Demand signal, volume, trend]
Pillar 3: [Name] — [Demand signal, volume, trend]

──────────────────────────────────────────────
PRIORITY TOPICS (ranked by volume x strategic fit)

1. [Topic] — [Signal] — [Volume] — [Format] — [Funnel stage]
2.
3.
...

──────────────────────────────────────────────
FIRST-MOVER OPPORTUNITIES (emerging signals)

1. [Signal] — [Trend] — [Why now]
2.
3.

──────────────────────────────────────────────
90-DAY CALENDAR

[Full calendar output per Phase 3 format above]

──────────────────────────────────────────────
STRUCTURAL RULES FOR WRITERS

[Brief version of Phase 4 rules tailored to this brand]

──────────────────────────────────────────────
DISTRIBUTION PLAN

[Per channel, per piece type]

──────────────────────────────────────────────
DEMAND SIGNALS USED

[Full list of MyTelescope signals that informed this strategy]
```

---

## Cookbook Rules

- **Topics come from data, not meetings.** If a topic has no demand signal
  backing, it does not go in the calendar. The team's favourite ideas are not
  content strategy — they are opinions. Demand data is strategy.
- **Pillar content earns citations. Supporting content earns traffic.** Both
  are needed. Do not build a calendar of only short posts or only long guides.
- **Consistency beats volume.** One strong piece per week for 12 months beats
  ten pieces in January and silence in February. Build the calendar around the
  real capacity, not the aspirational one.
- **AI visibility is not a separate track.** Every content piece should be
  structured for AI citation from the start. It costs nothing to lead with the
  answer and use demand signal language in headings.
- **Gated content does not get cited.** If the best content is behind a form,
  it will not appear in AI answers and will not rank. Gate lead-gen content,
  not authority content.
- **Update before you create.** An existing piece refreshed with new data and
  a current date often outperforms a new piece. Before adding to the calendar,
  check what already exists and whether updating it is faster than creating new.

---

## Cross-Reference Skills

- **strategic-recipe-brief** — provides the Single-Minded Idea and Human
  Insight that define the content's message and tone.
- **product-thinking** — provides the proof hierarchy that determines which
  content pieces are most credible and should be built first.
- **mytelescope-ai-visibility** — content structure rules in this skill are
  aligned with the AI visibility audit. Run the audit after 60 days of
  content to measure citation performance.
- **copywriting** — use this skill to write each individual content piece
  once the topic, format, and proof points are confirmed by this strategy.
- **campaign-activation** — the highest-performing content pieces become the
  hero assets in paid campaigns. Build the content first, then amplify it.

---

## Key Tools

| Tool | Purpose |
|------|---------|
| `knowledge_search` | Load prior content frameworks and brand context |
| `search_signals` | Find topic clusters and audience language |
| `get_demand_volume` | Confirm volume and trend for each proposed topic |
| `calculate_demand_priorities` | Rank topics by total demand volume |
| `calculate_emerging_demand` | Identify fast-growing signals for first-mover content |
| `web_search` | Check competitor content coverage for each topic |
| `web_fetch` | Read competitor articles to identify gaps and angles |

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
| Tactic | `mytelescope-content-strategy` | mytelescope-content-strategy-SKILL.md | This file |
| Tactic | `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | Local |
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Local |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | Local |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

**Direct downstream consumers of this skill's outputs:**
`mytelescope-copywriting` (calendar drives copy production),
`mytelescope-campaign-activation` (hero content becomes paid creative),
`mytelescope-ai-visibility` (priority topics define audit focus).
**Upstream prerequisites:** `strategic-recipe-brief`,
`mytelescope-product-thinking`, `mytelescope-core` (demand data).
