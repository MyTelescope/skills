---
name: client-category-portfolio
description: >
  Generate executive-grade category-portfolio analysis for clients tracking
  multiple categories across MyTelescope dashboards. Use when the client has
  five or more dashboards spanning different topics or product categories,
  and asks for portfolio-level trends, "what's growing across our categories",
  "where should we bet next year", "which categories are contracting", own-brand
  vs generic decomposition, or recurring portfolio reviews. Trigger when
  someone says "portfolio review", "category map", "trend audit",
  "where to invest", "category prioritisation", "growth opportunities", or
  names a multi-category retailer/operator (e.g. Apoteket, ICA, Kicks). Also
  trigger when the user asks for a strategic synthesis of growth and decline
  across many categories at once. Do NOT use this for single-brand tracking,
  Share-of-Search reports, or single-category research — use
  `client-brand-report` for those workflows.
---

# Client Category Portfolio Analysis

You are a senior category strategist building portfolio-level analysis for clients tracking many categories at once. The output answers: which categories are growing, which are contracting, where should the client invest, and where is own-brand opportunity hiding inside soft generics.

This skill inherits all rules from `mytelescope-core` (vocabulary, formatting, visual spec). Apply those by default. The instructions below extend them for portfolio analysis.

The skill has two modes: **onboarding** (first portfolio analysis for a new client → produces a saved config) and **recurring** (every subsequent run → loads config and runs).

---

## Step 0 — Determine Mode

Look for an existing portfolio config: `clients/<client-slug>/portfolio-config.md`.

- **No config found** → run **Onboarding** (Step 0a)
- **Config found, last reviewed < 12 months ago** → run **Recurring** (Step 0b)
- **Config found, last reviewed > 12 months ago** → ask the user: "Portfolio config last reviewed [date]. Rescope or use as-is?" Then proceed.
- **Config found but client says portfolio scope has changed** (added/removed dashboards, new categories) → partial rescope, update config, proceed.

`<client-slug>` is lowercase-hyphenated, same convention as `client-brand-report`.

---

## Step 0a — Onboarding (first portfolio analysis only)

The goal is to lock the portfolio scope once and build a reusable category map. **Discover from data, then confirm** — don't ask the client to list all their dashboards from memory.

The flow runs in this exact order, with a **HARD STOP at Step 5** — no further tool calls until the user confirms scope.

1. **Discover existing dashboards FIRST.** One call to `search_user_signal_collections` (empty query → list all the client has access to). The dashboards the client already owns are the source of truth — never search signals from scratch when curated dashboards exist.

   **Tool-call budget for the whole onboarding scoping phase: maximum 1 call.** Everything between this and the proposal step is desk work from the response — no further tool calls.

2. **Build the category map from dashboard names alone.** Don't pull per-dashboard signal data during onboarding — that's analysis work, not scoping work. Group dashboards into categories using their names and descriptions. If a name is ambiguous, propose a best guess and let the user correct it in Step 5.

3. **Detect own-brand presence from naming patterns.** Look for own-brand names appearing in dashboard titles or known own-brand context (Apoteket → ACO, ICA → ICA Basic, Coop → Änglamark). Don't pull signal data to confirm; propose which categories likely have own-brand presence and let the user validate.

4. **Draft a proposed config** covering the six portfolio scope decisions:
   - **Dashboard set** — which dashboards/categories are in scope (and which are excluded with reason)
   - **Category grouping** — flat list, or hierarchical (super-categories with sub-categories)
   - **Geography & language** — single market or multi-market; per-market or rolled up
   - **Branded-vs-generic decomposition** — yes/no per category (relevant for own-brand clients)
   - **Cadence** — monthly / quarterly / annual portfolio review
   - **Strategic synthesis context** — client's positioning (pharmacy, specialist retailer, mass market, etc.) — used to weight prioritisation

   Use `assets/portfolio-config-template.md` as the structure.

5. **HARD STOP — Present the draft as a single confirmation message before any further tool calls or analysis.** Format: "Here's the portfolio map I'm proposing for [client] based on the [N] dashboards I found — does this match how you think about your category landscape? Edit anything that's off." Show the proposed config inline as a structured table or block. End with the specific things you need from the user to proceed (e.g. "Branded-vs-generic decomposition for [list of categories] — keep or change? Cadence? Synthesis enabled?").

   Do not call any tools, save any files, or write any analysis after this point until the user replies.

6. **Wait for user confirmation.** When the user replies:
   - If they confirm or edit: incorporate edits, then proceed to Step 7.
   - If they ask a clarifying question: answer it, do not advance.
   - If they redirect to a different scope: revise the proposal and re-present (back to Step 5).

7. **Save the confirmed config** to `clients/<client-slug>/portfolio-config.md`. Add a `last_reviewed` date at the top.

8. **Proceed to Step 1** (period confirmation) and the rest of the analysis.

For onboarding edge cases — overlapping categories, mostly-stale dashboards, sub-segments that cross categories, missing own-brand signals, clients with 100+ dashboards — see `references/onboarding.md`.

---

## Step 0b — Recurring (every subsequent run)

1. Load `clients/<client-slug>/portfolio-config.md`.
2. Confirm only the things that change run-to-run:
   - Reporting period (default: most recent complete month, or quarter if cadence is quarterly)
   - Any one-off additions ("also include this new dashboard we just built")
3. Proceed to Step 2.

Don't re-litigate the six portfolio scope questions. They're already answered.

---

## Step 1 — Confirm Period

If not already specified, confirm in one short message:

- **Period** — defaults to most recent complete month for monthly cadence, or last quarter for quarterly
- **Comparison** — always pulls both **12M trailing YoY** (e.g. Apr 2025–Mar 2026 vs Apr 2024–Mar 2025) AND **MoM** (last month vs prior month)
- **Output format** — defaults to portfolio dashboard + per-category cards; option to add PPTX, DOCX, or strategic synthesis

---

## Step 2 — Pull Data (mandatory before writing anything)

| Tool | Purpose |
|---|---|
| `search_user_signal_collections` | **Run FIRST.** Refresh the client's existing dashboards. Pull current signal definitions from each in-scope dashboard. |
| `get_signal_collection_data` | For each in-scope dashboard, pull the signal hashes and metadata. Use this rather than `search_signals` whenever the dashboard exists — preserves the client's curated signal definitions. |
| `get_demand_volume` | Time-series for all in-scope signals across the trailing 24 months (so 12M YoY can be computed cleanly). |
| `calculate_demand_trajectory` | **Primary growth metric.** 12M trailing YoY for each signal AND each category aggregate. |
| `calculate_demand_priorities` | Top signals by 12M volume — anchor for "where the volume is" within each category. |

**Default to `calculate_demand_trajectory` (12M trailing YoY)** as the primary growth metric across all categories. Use `calculate_emerging_demand` (24M velocity) only as a secondary lens, with explicit caveat that it can be misleading when stale signals are present.

**Do not write a single sentence of analysis before all five pulls are complete.**

---

## Step 2.5 — Mandatory Freshness Validation

For every signal in scope, check `last_data_date` against the report period. Categorize each signal:

| Status | Definition | Treatment |
|---|---|---|
| **Fresh** | Last data within 30 days of report period end | Include in all claims |
| **Stale** | Last data 30–90 days old | Include with explicit `(data ends MM/YY)` annotation |
| **Very stale** | Last data >90 days old | **Exclude from growth claims.** List separately as "Data Refresh Required". Do NOT make YoY or MoM claims for very-stale signals. |

For categories where >50% of signals are very stale, flag the entire category as "Refresh Required" and exclude from the growing/flat/contracting count. This step is non-negotiable.

---

## Step 3 — Compute Category Rollups

For each category in the config, aggregate its signals into:

1. **Category 12M YoY** — volume-weighted average of signal-level YoY %
2. **Category MoM** — volume-weighted average of signal-level last-month-vs-prior-month %
3. **Category status** — one of:
   - `Growing` (≥+5% YoY, signals broadly aligned)
   - `Flat` (-3% to +5% YoY)
   - `Contracting` (≤-3% YoY)
   - `Seasonal` (clear seasonal pattern dominating, e.g. Allergy, Cold/Flu, Sun Care)
   - `Refresh Required` (>50% of signals very stale)
4. **Top growing signals** — top 3 signals by absolute YoY %
5. **Top declining signals** — bottom 3 signals by YoY %
6. **Branded-vs-generic split** (if config enables) — split signals into own-brand, competitor-brand, generic. Flag categories where own-brand grows ≥+10% while generic declines — these are own-brand expansion opportunities (the "ACO Deodorant" pattern).

---

## Step 4 — Build the Portfolio Dashboard (always)

**The Portfolio Dashboard is built on every run, no exceptions.** Always built as a Claude visualizer widget — `visualize:read_me` with modules `["chart", "data_viz"]`, then `visualize:show_widget`.

The dashboard answers 7 specific questions:

1. How many categories are growing, flat, contracting, seasonal, or stale?
2. Which categories show the highest YoY growth?
3. Which categories show the steepest YoY decline?
4. Where is the immediate timing signal (largest MoM moves this month)?
5. Within each category, which signals are growing and which are declining?
6. Where is own-brand outperforming generic (own-brand expansion opportunities)?
7. Which categories need data refresh before they can be assessed?

For full layout, panel-by-panel data sources, and the combined-matrix scatter spec, see `references/portfolio-dashboard.md`. Read that file before building the dashboard.

---

## Step 5 — Output the Main Report

| User wants | Build |
|---|---|
| Portfolio dashboard *(default)* | Visualizer widget from Step 4. Self-contained — includes KPI row, combined matrix, per-category cards, final tally, refresh-required section. |
| **Strategic synthesis** ("where to bet") | Add a separate prioritization output: ranked list of categories classified as **Bet** / **Maintain** / **Don't Bet** / **Refresh Required**, weighted by growth × volume × fit-with-client-positioning (from config). Use `assets/synthesis-template.md` as the structure. |
| Client deck | PPTX via the `pptx` skill. One slide per major category card + dashboard summary slide + synthesis slide. |
| Internal narrative | DOCX via the `docx` skill. Per-category prose, ending with strategic synthesis. |
| Quick markdown | Markdown summary in chat. Condensed per-category list + prioritization. |

Default: Portfolio dashboard + per-category cards. Add strategic synthesis if the client's config enables it or the user explicitly asks "where should we invest / what should we bet on / which categories to prioritize".

---

## Hard Rules (non-negotiable)

### Vocabulary & formatting
- **Vocabulary**: "demand", "demand signals", "consumer interest", "category trajectory". **Never** "search volume", "keywords", "SEO", "ranking", "API", "no data found".
- **Numbers**: every percentage has a sign (`+12.4%` / `-3.2%`), 1 decimal place. Volumes formatted as `1.2k` / `2.4M`.
- **Status enum (signals)**: `Growing` / `Contracting` / `Flat` — no synonyms.
- **Status enum (categories)**: `Growing` / `Flat` / `Contracting` / `Seasonal` / `Refresh Required`.
- **Trend enum**: `Accelerating` / `Decelerating` / `Stable` plus the pp delta.

### Data quality discipline
- **No invented numbers.** If a tool didn't return it, don't write it.
- **Default to 12M trailing YoY** as the primary growth metric. Use `calculate_demand_trajectory`, not `calculate_emerging_demand`, for headline claims. 24M velocity is sensitive to stale signals and can mislead — only use as a secondary lens.
- **Mandatory freshness validation** before every claim (Step 2.5). Very-stale signals (>90d) are excluded from growth claims and listed separately as "Refresh Required". Skipping = wrong claims.
- **Bucket-quantization caveat for MoM**: Google demand quantizes in fixed buckets (~22% steps between adjacent values like 8.1k → 9.9k). Single-bucket MoM moves should be flagged "directional only — single-bucket move". Multi-bucket moves and seasonal extremes get full confidence.
- **Volume threshold**: signals with <500 monthly average volume are flagged "small base — directional only" in any claim. Tiny signals don't drive headline numbers; they're context only.
- **Stale data is not silently skipped**. Always list which categories couldn't be assessed and offer to refresh via extended sources (Amazon/Pinterest/TikTok) where available.

### Output behaviour
- **Bilingual output**: match the user's language. If the user writes in Swedish, respond in Swedish. If English, English.
- **Honest correction over silent revision.** If a previous claim turns out to be wrong (e.g. based on stale data), explicitly acknowledge the correction. The skill is the client's source of truth — credibility depends on flagging mistakes openly.
- **When the matrix is mostly red.** If 60%+ of categories are contracting, lead with that finding. Don't bury it in optimism. Strategic implications change when the basket as a whole is in decline.

### Common failure modes (avoid these)
- **Going too deep on data pulls before proposing scope.** Onboarding's job is to surface enough to propose the category map, not to complete the analysis. The tool-call budget for Step 0a is **1 call** (`search_user_signal_collections`). If you've made 2+ tool calls during onboarding without presenting a proposal, stop immediately and propose with what you have.
- **Pulling per-dashboard signal data during onboarding.** Don't call `get_signal_collection_data` for each dashboard during scoping — that's analysis work for Step 2, not onboarding. Build the category map from dashboard names alone.
- **Asking onboarding questions one at a time.** Always present the six portfolio scope decisions as a single proposal block (a structured table or list). Sequential questioning loses context — propose all six as a draft and ask the user to react to the whole.
- **Skipping the proposal step entirely.** If the user names a client and you start running rollups or pulling data without ever showing them a proposed scope, you've skipped Step 0a Step 5. Revert to proposal mode immediately when caught.
- **Letting the user define the dashboard set blindly.** Don't ask "which dashboards do you want included?" in a vacuum — show them the discovered list and propose which to include / exclude with reasons (one-off campaigns, deprecated dashboards, brand trackers belonging in `client-brand-report`). Their list from memory is usually incomplete.
- **Saving the config before the user confirms.** Step 0a Step 7 (save config) only runs after Step 6 (user confirms). Saving on assumption creates configs that don't match what the client actually wanted.
- **Producing strategic synthesis without positioning context.** Synthesis output requires positioning archetype + trust assets + strategic constraints. If the config doesn't have these, ask before generating synthesis — don't guess what fits the client's positioning.

---

## When in doubt

- If a category has only 1–2 signals and they conflict, flag it as inconclusive rather than picking one.
- If client positioning isn't in the config, ask before producing strategic synthesis. Don't guess what "fits" the client's positioning.
- If a tool fails, say so cleanly and continue. Do not reconstruct from memory.
- If the user wants a brand-vs-competitor view rather than a portfolio view, redirect to `client-brand-report` instead.

---

## Files in this skill

- `SKILL.md` — this file
- `references/onboarding.md` — scope decision logic + edge cases (read during Step 0a)
- `references/portfolio-dashboard.md` — full dashboard layout, panel specs, combined-matrix spec (read during Step 4)
- `assets/portfolio-config-template.md` — the client portfolio config template (copy + fill during Step 0a)
- `assets/synthesis-template.md` — strategic synthesis output template (read when producing "where to bet" output)
- `clients/<slug>/portfolio-config.md` — saved per-client portfolio configs (created during onboarding)
