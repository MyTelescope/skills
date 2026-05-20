---
name: mytelescope-ai-visibility
description: >
  Use this skill whenever a user wants to optimize for AI search, get cited by
  LLMs, improve AI visibility, or understand how AI systems discover and
  recommend content or brands. Trigger for: "AI SEO", "AEO", "GEO", "LLMO",
  "answer engine optimization", "generative engine optimization", "optimize for
  ChatGPT", "optimize for Perplexity", "AI citations", "AI visibility",
  "zero-click search", "show up in AI answers", "LLM mentions", "optimize for
  Claude or Gemini", "how do I get cited by AI", "AI search strategy", "does AI
  know about my brand", "what does ChatGPT say about us". Also trigger
  proactively when a user is planning content strategy, SEO, brand tracking, or
  GTM — AI visibility is now a required layer of any content or marketing plan.
  This skill combines MyTelescope demand intelligence (mytelescope-core) with
  brand tracking (brand-tracking) and AI SEO best practices. Always pull real
  demand data before making recommendations.
---

# MyTelescope AI Visibility Skill

You help users get their brand, product, or content cited and recommended by AI
systems: Google AI Overviews, ChatGPT, Perplexity, Claude, Gemini, and Copilot.

**This skill always runs in four phases:**
0. Strategic brief — what does the brand want to be known for?
1. Demand intelligence — what are people actually searching for?
2. AI visibility audit — where does the brand show up (or not) today?
3. Action plan — what to build, fix, or publish to get cited?

**Phase 0 is not optional.** You cannot audit AI visibility without knowing
what the brand is trying to communicate and who it is trying to reach. An audit
without a brief has no north star — you would not know what counts as a gap.

---

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

## Before Starting

Check for product marketing context first. If `.agents/product-marketing-context.md`
exists, read it before asking questions. Use that context and only ask for
what is missing.

**Minimum context needed to proceed:**
- Brand or product name
- Website URL — required. The audit cannot run without visiting the actual site.
  If not provided, ask before doing anything else. Never assume a URL from a brand name.
- Target market / geography (default: user's location)
- A completed Strategic Recipe Brief — or willingness to build one now

---

## Phase 0: Strategic Brief

**Cross-reference: strategic-recipe-brief SKILL.md** — run the full brief
interview before touching any audit step. The brief establishes:

- The Single-Minded Idea: the one thing the brand wants to be known for
- The target audience and their mindset
- The Human Insight: why the message is relevant to their life
- The Reason to Believe: what makes the claim credible

**Why this comes first:**

Every finding in the AI audit is only meaningful relative to what the brand
intends. If the Single-Minded Idea is "demand intelligence that makes
marketers more confident," then the audit question becomes: "Does AI currently
associate this brand with that idea?" Without the brief, you are auditing
against nothing.

**Three scenarios:**

1. **Brief already exists** — ask the user to share it or confirm it is
   current. Read it. Extract the Single-Minded Idea, target audience, and top
   Reason to Believe. Proceed to Phase 1.

2. **Brief exists but is outdated** — note what has changed (new product,
   new market, repositioning) and run a shortened brief update covering only
   the sections that have changed. Then proceed.

3. **No brief exists** — run the full strategic-recipe-brief skill before
   proceeding. Do not shortcut this. A rushed brief produces a useless audit.

**What to carry forward from the brief into the audit:**

- Single-Minded Idea → the primary query the brand must own in AI answers
- Target audience language → cross-reference against demand signals in Phase 1
- Reason to Believe claims → check in Phase 2 whether AI systems cite these
- Human Insight → check in Phase 2 whether owned content reflects this depth

---

## Phase 1: Demand Intelligence

**Prerequisite: Phase 0 brief must be complete.** The Single-Minded Idea and
audiece language from the brief are direct inputs to this phase — they define
which signals to search for and what counts as a relevant match.

**Cross-reference: mytelescope-core SKILL.md** — follow its full workflow for
tool discovery, location resolution, signal search, volume fetching, and
visualization. The steps below are the AI-visibility-specific application of
that workflow.

### Step 1: Load MyTelescope Tools

Call `tool_search` with a relevant query (e.g. "demand signals location") before
calling any MyTelescope tool. Required once per conversation.

### Step 2: Resolve Location and Language

Call `get_location_details`. Never hardcode a location ID.

```
get_location_details(location="Sweden")
# Returns: { locationId, languageId, availableDataSources }
```

### Step 3: Brand Identity Check

Before searching for signals, confirm you know what the brand is. Run
`web_search(query="[brand name] company")` for any name that could be ambiguous
— abbreviations, acronyms, common words.

**Cross-reference: brand-tracking SKILL.md Phase 2** for the full brand
identity verification protocol. Never assume. Always verify short names.

### Step 4: Find Demand Signals

Run `search_signals` using the brand name, category terms, and key competitors.

```
search_signals(
    keywords=["brand name", "product category", "competitor A", "competitor B"],
    location_id="<from Step 2>",
    language_id="<from Step 2>"
)
```

**What to extract:**
- Exact language consumers use (often different from brand language)
- Competitor signals that surfaced — propose them rather than asking from scratch
- Signals with low relevance scores (<0.75) — flag and exclude

### Step 5: Pull Volume Data and Visualize

Call `get_demand_volume` with confirmed keyword hashes. Call `forecast_demand`
with `future_steps=6` before rendering any chart. Always render a trend line
chart — never present time-series as a table. The forecast appears as a dashed
line extension.

**Cross-reference: mytelescope-core SKILL.md** for mandatory chart rules: plot
every data point, no sampling, declare earliest/latest/total before rendering.

### Step 6: Answer the Four Baseline Questions

Before moving to Phase 2, these must be answered from real data:

1. What is branded demand for this company or category?
2. Is category demand Growing, Contracting, or Flat?
3. What language does the audience actually use?
4. What do competitors own?

---

## Phase 2: AI Visibility Audit

**MANDATORY: Do not present any audit findings until Steps 1 and 2 below are
complete.** Every check in this phase must be based on what you actually find
by visiting the site — never assumed, never inferred from brand name alone.
Presenting unverified items as findings is worse than presenting nothing.

### Step 1: Visit and Read the Site

Call `web_fetch` on the brand's homepage and key pages before writing a single
audit finding. This is the only way to know what the company actually does,
how they describe themselves, what content exists, and what is missing.

```
web_fetch(url="https://[brand-domain].com")
web_fetch(url="https://[brand-domain].com/pricing")
web_fetch(url="https://[brand-domain].com/robots.txt")
web_fetch(url="https://[brand-domain].com/llms.txt")
web_fetch(url="https://[brand-domain].com/pricing.md")
```

**What to extract from the homepage:**
- What does the product actually do? (in the brand's own language)
- Who is it for? (ICP as stated on site)
- What problem does it solve?
- What is the brand's core claim or positioning?
- What content types exist (blog, docs, comparison pages, case studies)?
- What does the navigation reveal about content depth?

If a page returns 404, record it as missing — do not guess at its contents.
If robots.txt is not accessible, note that too.

**Do not proceed to Step 3 until you have fetched and read the site.** If the
domain is unknown, ask the user before guessing.

### Step 2: Establish What the Brand Wants to Be Known For

Based on what you read in Step 1, summarize in 2-3 sentences:
- What the product does
- Who it is for
- What queries they should ideally appear in when an AI answers a question

Show this summary to the user and ask: "Is this how you'd describe it, or
should I adjust before running the audit?"

Do not proceed until the user confirms or corrects this framing. The entire
audit and action plan depend on getting this right.

### Step 3: Establish the AI Truth — What Do AI Systems Actually Know?

This is the most important step in the audit. Before any recommendations,
you must establish ground truth: what AI systems currently know about the
brand, where that knowledge comes from, and what is missing or wrong.

**Use both tools. Neither alone is sufficient.**

- `web_fetch` (Claude's own fetch) — reads the brand's actual site content,
  robots.txt, and machine-readable files. Shows what is published and
  accessible. But Claude's web fetch cannot render JavaScript and may be
  blocked by bot detection. Always note what you could and could not read,
  and why — never assume a failed fetch means AI crawlers face the same barrier.

- `MyTelescope:web_search` (queries Perplexity, OpenAI, Grok, and Gemini in
  parallel) — shows what AI systems actually find and cite about the brand
  right now, across the live web. This is the closest proxy to "what would
  ChatGPT, Perplexity, or Gemini say about this brand if asked?" It surfaces
  third-party sources, client mentions, press coverage, and review sites —
  the actual citation layer across multiple AI providers.

**Run both in parallel. Cross-reference the results.**

The gap between the two is your AI visibility gap:
- What the brand says about itself (web_fetch) vs.
- What AI systems actually find and cite (web_search)

If web_search returns strong third-party citations but web_fetch shows weak
owned content — the brand is being defined by others. That is a risk.
If web_fetch shows rich owned content but web_search returns little — the
owned content is not being picked up. Structure and authority need work.

**Queries to run via MyTelescope:web_search:**

Pass the brand name as the seed query AND the audit angles as `few_shot_examples`. The server uses the examples as few-shot context so Perplexity, OpenAI, Grok and Gemini all answer across the breadth of intents in a single call — not 5 separate round-trips.

```
web_search(
    query="[brand name]",
    few_shot_examples=[
        "[brand name] what is it",                       # definition
        "[brand name] pricing plans features",           # commercial findability
        "best [product category] tools",                 # category competition
        "[brand name] vs [top competitor]",              # head-to-head
        "[brand name] cited mentioned review",           # citation layer
    ]
)
```

**Rules for the example list (same as Step 3 in mytelescope-core):**

- 3-5 examples covering different intents — definition, commercial findability, category, head-to-head, citations. Don't submit five phrasings of the same intent.
- Substitute `[brand name]` and `[product category]` with the actual values from Phase 0 / Phase 1.
- If you can't think of ≥3 distinct examples for this brand, fall back to `web_search(query="[brand name]")` (single-prompt mode).

**What to record from each search:**

Look at every provider's response (`perplexity`, `openai`, `grok`, `gemini`) and aggregate:

- Which sources do the AI providers cite? (own site vs. third-party — count across all four)
- What do they say the product does? (accurate, incomplete, or wrong? Flag if the four providers disagree)
- Is pricing findable? (if not, AI agents evaluating the tool cannot compare it)
- Are competitors being cited where the brand is not?
- Do the providers hallucinate any facts? (note these — they are reputational risks. Hallucinations that only ONE provider makes are usually less concerning than ones repeated across all four)

**Source the finding to the tool that produced it.** Never present a finding without stating whether it came from `web_fetch`, `web_search`, or both. If two tools contradict each other, report both results and flag the conflict — do not pick one and discard the other.

**When reporting which AI provider said what, prefer aggregate language.** Don't say "Perplexity says X" — say "all four AI providers describe the brand as X" OR "three of four providers cite the brand's blog; only Grok cites the press coverage." The user wants to see the LANDSCAPE, not one provider's view.

**Citations from third parties vs. owned content:**

Note which sources the AI providers cite for the brand. Research shows brands are 6.5x more likely to be cited via third-party sources than their own domain. If the brand is only appearing through third-party mentions, that is worth flagging — it means AI visibility currently depends on sources the brand does not control.

### Step 4: Priority Queries Audit

Using confirmed framing from Step 2 and top demand signals from Phase 1,
test the 5-10 queries the brand most needs to appear in.

Run ONE `web_search` call with the brand / category as the seed and the priority queries as `few_shot_examples`. The server fans the few-shot context out to all four providers (Perplexity, OpenAI, Grok, Gemini) so you get cross-provider visibility on every query in a single call:

```
web_search(
    query="[brand name]",                              # or "[product category]" if doing a category audit
    few_shot_examples=[
        "What is [product category]?",                 # category definition
        "Best [category] for [use case]",              # ranking / category competition
        "[Brand] vs [competitor]",                     # head-to-head
        "How to [problem your product solves]",        # task / how-to
        "[Brand name]",                                # bare brand query
    ]
)
```

If the audit needs more than 5 angles, split into multiple `web_search` calls — each with its own batch of 3-5 examples grouped by theme (e.g. one call for "commercial findability" queries, another for "category authority" queries). Don't stuff 10 examples into one call.

Focus on query types most likely to surface in AI answers:

- "What is [product category]?"
- "Best [category] for [use case]"
- "[Brand] vs [competitor]"
- "How to [problem your product solves]"
- "[Brand name]" (bare brand query)

| Query | Provider consensus | Brand cited? | Source type | Competitor cited? |
|-------|--------------------|:------------:|-------------|:-----------------:|
| ...   | aggregated answer across the 4 providers (note where they diverge) | Yes / No (in how many of the 4?) | Own / Third-party / None | [who] |

Each row corresponds to one entry from `few_shot_examples`. Populate rows from actual web_search results — never assume or infer. The response shape is the same as today (`{perplexity, openai, grok, gemini}`); cross-reference across providers per row.

### Step 5: Content Extractability Check

Based only on pages successfully fetched in Step 1:

| Check | Result | Source |
|-------|--------|--------|
| Homepage content readable without JS? | Pass / Fail | web_fetch |
| Clear definition of product in first paragraph? | Pass / Fail / Unknown | web_fetch |
| Self-contained answer blocks? | Pass / Fail / Unknown | web_fetch |
| Statistics with cited sources? | Pass / Fail / Unknown | web_fetch |
| Comparison tables for X vs Y queries? | Pass / Fail / Unknown | web_fetch |
| FAQ section with natural-language questions? | Pass / Fail / Unknown | web_fetch |
| Schema markup (FAQ, HowTo, Article, Product)? | Pass / Fail / Unknown | web_fetch |
| Expert attribution (author name, credentials)? | Pass / Fail / Unknown | web_fetch |
| Content updated within 6 months? | Pass / Fail / Unknown | web_fetch |
| Headings match how people phrase queries? | Pass / Fail / Unknown | web_fetch |
| AI bots allowed in robots.txt? | Pass / Fail / Not found | web_fetch |
| /pricing.md or /pricing.txt exists? | Pass / Missing / 404 | web_fetch |
| /llms.txt exists? | Pass / Missing / 404 | web_fetch |
| Pricing findable by AI search? | Pass / Fail | web_search |

Mark any row as **Unknown** if the relevant page could not be fetched.
Never mark Pass or Fail on a page you did not successfully read.

### Step 6: AI Bot Access Check

Read the actual robots.txt from Step 1. Report only what is literally there.
If robots.txt could not be fetched, mark as Unknown — do not guess its contents,
and do not use `web_search` to infer it (the AI providers may hallucinate file
contents — robots.txt must come from the actual fetch).

Bots to check — blocking any means that platform cannot cite the brand:

- GPTBot and ChatGPT-User — OpenAI (ChatGPT)
- PerplexityBot — Perplexity
- ClaudeBot and anthropic-ai — Anthropic (Claude)
- Google-Extended — Google Gemini and AI Overviews
- Bingbot — Microsoft Copilot

Blocking CCBot (Common Crawl) is fine — it is a training crawler, not a
search bot. Blocking it does not affect citation.

### Step 4: Machine-Readable File Check

AI agents increasingly evaluate products programmatically before any human
visits. Opaque pricing gets filtered out of AI-mediated buying journeys.

Check whether these files exist and are current:

**`/pricing.md`** — structured pricing parseable by any LLM:
```
# Pricing — [Product Name]
## Free
- Price: $0/month
- Limits: [specific limits]
- Features: [list]
## Pro
- Price: $X/month
...
```

**`/llms.txt`** — context file for AI systems (llmstxt.org). Gives AI a quick
overview of what your product does, who it is for, and links to key pages.

**`/AGENTS.md`** — describes API and agent capabilities for AI agents
evaluating tool options.

---

## Phase 3: Action Plan

Based on Phases 1 and 2, build a prioritized action plan across three pillars.

### Pillar 1: Structure — Make Content Extractable

AI systems extract passages, not pages. Every key claim must work standalone.

**Content block patterns:**
- Definition blocks for "What is X?" queries
- Step-by-step blocks for "How to X" queries
- Comparison tables for "X vs Y" queries
- FAQ blocks for common questions
- Statistic blocks with cited sources

**Structural rules:**
- Lead every section with a direct answer — never bury it
- Keep key answer passages to 40-60 words (optimal for extraction)
- Use H2/H3 headings that match how people phrase queries (use demand signal
  language from Phase 1, not internal brand language)
- Tables beat prose for comparisons
- Numbered lists beat paragraphs for process content

### Pillar 2: Authority — Make Content Citable

Princeton GEO research (KDD 2024, studied across Perplexity.ai) ranked
optimization methods by visibility lift:

| Method | Visibility boost |
|--------|:---------------:|
| Cite sources | +40% |
| Add statistics with dated sources | +37% |
| Expert quotes (named, with title) | +30% |
| Authoritative tone | +25% |
| Improve clarity | +20% |
| Technical domain terms | +18% |
| Unique vocabulary | +15% |
| Fluency improvement | +15-30% |
| Keyword stuffing | -10% |

Best combination: fluency + statistics = maximum boost. Low-ranking sites
benefit even more — up to +115% visibility with citations.

**Freshness signals:**
- "Last updated: [date]" prominently displayed
- Quarterly content refreshes for competitive topics
- Current year references and recent statistics

### Pillar 3: Presence — Be Where AI Looks

Brands are 6.5x more likely to be cited via third-party sources than their
own domains. Build presence on the sources AI systems pull from:

- Wikipedia — 7.8% of all ChatGPT citations
- Reddit — 1.8% of ChatGPT citations
- Industry publications and guest posts
- Review sites (G2, Capterra, TrustRadius for B2B SaaS)
- YouTube — frequently cited by Google AI Overviews
- Quora

### Content Types That Get Cited Most

| Content type | Citation share | Why AI cites it |
|-------------|:--------------:|-----------------|
| Comparison articles | ~33% | Structured, balanced, high-intent |
| Definitive guides | ~15% | Comprehensive, authoritative |
| Original research / data | ~12% | Unique, citable statistics |
| Best-of / listicles | ~10% | Clear structure, entity-rich |
| Product pages | ~10% | Specific details AI can extract |
| How-to guides | ~8% | Step-by-step structure |
| Opinion / analysis | ~10% | Expert perspective, quotable |

**Underperformers:**
- Generic blog posts without structure
- Thin product pages with marketing language
- Gated content (AI cannot access it)
- Content without dates or author attribution
- PDF-only content

---

## Phase 4: Brand Health Dashboard

If the user wants ongoing tracking, build a full brand health dashboard.

**Cross-reference: brand-tracking SKILL.md Phase 4** for the full dashboard
rendering spec — KPI row, share of search chart, volume trend chart, and
insight section. Follow it exactly for all standard sections.

The AI visibility dashboard adds one section on top of the standard brand
health dashboard:

**AI Presence Panel**
- Table of priority queries tested in Phase 2
- Citation status per platform (Google AI Overview / ChatGPT / Perplexity)
- Competitor citation rate vs. brand citation rate
- Trend: improving / declining / no change month-over-month

---

## Phase 5: Save and Monitor

After the dashboard renders, offer:

1. **Save as a MyTelescope Dashboard** — live tracking that updates monthly
2. **Set up a Brand Tracing Agent** — notifies on meaningful demand shifts
3. **Set up AI visibility monitoring** — monthly manual check or tooling

**Cross-reference: brand-tracking SKILL.md Phase 5** for the full save
workflow using `create_signal_collection`, `create_trend_alert`, and
`generate_platform_link`.

**AI visibility monitoring tools:**

| Tool | Coverage | Best for |
|------|----------|----------|
| Otterly AI | ChatGPT, Perplexity, Google AI Overviews | Share of AI voice |
| Peec AI | ChatGPT, Gemini, Perplexity, Claude, Copilot | Multi-platform scale |
| ZipTie | Google AI Overviews, ChatGPT, Perplexity | Brand mention + sentiment |
| LLMrefs | ChatGPT, Perplexity, AI Overviews, Gemini | SEO to AI visibility mapping |

**DIY monitoring (no tools):**
1. Pick your top 20 queries from Phase 1 demand signals
2. Run each through ChatGPT, Perplexity, and Google monthly
3. Record: cited? Who is? Which page?
4. Log month-over-month in a spreadsheet

---

## Common Mistakes

- Treating AI SEO as separate from traditional SEO — good traditional SEO is
  the foundation; AI visibility adds structure and authority on top
- Writing for AI, not humans — content written to game algorithms does not
  get cited and does not convert
- No freshness signals — undated content loses to dated content because AI
  systems weight recency heavily
- Gating all content — AI cannot access gated content; keep authoritative
  content open
- Ignoring third-party presence — a Wikipedia mention may drive more AI
  citations than your entire blog
- Blocking AI bots in robots.txt — if GPTBot or PerplexityBot are blocked,
  those platforms cannot cite you
- Hiding pricing behind "contact sales" — AI agents evaluating your product
  cannot parse what they cannot read; add `/pricing.md`
- Generic content without data — "we are the best" will not get cited;
  "customers see 3x improvement in [metric]" will
- Not monitoring — you cannot improve what you do not measure

---

## Key Tools

| Tool | Purpose |
|------|---------|
| `tool_search` | Load MyTelescope tool definitions (required first) |
| `web_search` | Brand identity check and AI answer testing |
| `get_location_details` | Resolve location ID and available data sources |
| `search_signals` | Find demand signal IDs for brand and category |
| `get_demand_volume` | Pull historical monthly demand volumes |
| `forecast_demand` | 6-month forward projection for all trend charts |
| `create_signal_collection` | Save confirmed signal set as a dashboard |
| `create_trend_alert` | Set up automatic monitoring notifications |
| `generate_platform_link` | Get shareable link to the saved dashboard |
| `knowledge_search` | Load brand strategy or content frameworks |

---

---

## Cross-Referenced Skills (updated)

- **strategic-recipe-brief** — run this first, always. Establishes the
  Single-Minded Idea, target audience, Human Insight, and Reason to Believe
  that define what the AI visibility audit is measuring against. Read for
  Phase 0.
- **mytelescope-core** — full demand intelligence workflow, chart rendering
  rules, data formatting, and visualization spec. Read before any data step.
  Read for Phase 1.
- **brand-tracking** — brand interview protocol, signal confirmation, brand
  health dashboard rendering, and save-as-agent workflow. Read for Phase 4-5.

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
| Tactic | `mytelescope-ai-visibility` | MyTelescope Ai Visibility skill.md | This file |
| Tactic | `mytelescope-content-strategy` | mytelescope-content-strategy-SKILL.md | Local |
| Tactic | `mytelescope-pricing-distribution` | mytelescope-pricing-distribution-SKILL.md | Local |
| Tactic | `mytelescope-campaign-activation` | mytelescope-campaign-activation-SKILL.md | Local |
| Tactic | `mytelescope-copywriting` | mytelescope-copywriting-SKILL.md | Local |
| Monitoring | `brand-tracking` | brand-tracking/SKILL.md | External (org-level) |

**Direct downstream consumers of this skill's outputs:**
`mytelescope-content-strategy` (citation gaps → topic priority),
`mytelescope-copywriting` (structure rules → answer-first H1/H2 patterns),
`brand-tracking` (audit baseline → ongoing share-of-citation tracking).
**Upstream prerequisites:** `strategic-recipe-brief`, `mytelescope-core`
(demand data), `mytelescope-pricing-distribution` (open /pricing.md is a key
citation surface).
