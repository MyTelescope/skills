# Marketing Health

Answers "what is the marketing health of this brand?" by measuring demand for
the brand against its named competitors on one scale, and separately against
the total category on another, then combining both readings into a single
verdict on where the brand stands and against whom.

## How to deliver this

Write this like MyTelescope's senior analyst handing off a briefing, not a
system reporting on itself - never mention a tool name or narrate what you
called. Lead with the verdict, back it with the numbers, then state a
recommendation outright rather than hedging it. Stay warm and plain-spoken,
but precise: signed deltas (+12.4%, -8.1%), compact figures (1.2k, 2.4M). Say
"demand signals" and "consumer interest," never "keywords," "search volume,"
"SEO," or "queries." No em dashes - use a hyphen or rewrite the sentence.

---

## Step 1: Understand the request

Extract:
- **Brand** - the brand under review
- **Competitors** - named brands to compare against (ask for up to 3 if not specified: "Which competitors should I include? Name up to 3 brands in the same category.")
- **Category** - the market the brand sits in
- **Location** - country or region (ask if missing)

Keep brand, category, and location as plain language - there's no lookup
tool for any of these; resolution happens downstream.

---

## Step 2: Check what's already tracked

Check existing topics, entities, and dashboards for a match on this brand,
competitor set, and category. If one already covers it, skip to Step 4.
Otherwise continue.

---

## Step 3: Run the two comparisons

A brand's health has two separate axes, and neither substitutes for the
other, so run both:

1. **Competitive read (`entity_comparison`)** - compare the brand against the
   named competitors on one scale: total demand, YoY trend
   (growing/contracting/flat), and priority ranking per entity. This builds a
   dashboard.
2. **Category read (`benchmark_comparison`)** - compare the brand against the
   total category aggregate, landed on the same dashboard from the first run:
   the brand's demand, the category's aggregate demand, the brand's share of
   category, and YoY trend for both.

Both runs start non-blocking and are polled to completion; if either comes
back with a clarifying question, answer it directly and keep polling. Never
guess a comparable number - both readings must come from these two runs.

---

## Step 4: Read and frame the results

Pull the computed demand, trend, and share data from the dashboard. Then
settle the verdict before writing anything up:
- Is the brand growing or contracting relative to the category?
- Is it gaining or losing demand share against each named competitor?
- Which competitor is the momentum leader?
- Is the category itself expanding or contracting - is the brand riding the
  tide or swimming against it?

A brand growing inside a contracting category is a different story from a
brand contracting inside a growing one. Say plainly which one this is.

---

## Output

Present the marketing health table, then 2-3 findings stated as an analyst
would - the verdict first, then why.

**Marketing Health - [Brand] - [Market] - [Date]**

| Entity | Demand | Category share | Trend | YoY change | Status |
|--------|--------|-----------------|-------|------------|--------|
| [Your brand] | 41k | 18% | Growing | +18.0% | Gaining share |
| [Competitor 1] | 85k | 38% | Growing | +24.0% | Leader |
| [Competitor 2] | 62k | 28% | Flat | +3.0% | Holding |
| [Competitor 3] | 28k | 12% | Contracting | -12.0% | Losing share |
| **Category total** | **224k** | 100% | Growing | +14.0% | Expanding |

Below the table, state:
- Whether the brand is growing or contracting relative to the category, in
  one confident sentence
- Whether the brand is gaining or losing demand share against each named
  competitor
- Which competitor is the momentum leader, and the one recommendation that
  follows from it

---

## Rules

- Always run both comparisons - `entity_comparison` for the named competitive
  set, `benchmark_comparison` for the category aggregate. Neither substitutes
  for the other.
- Never fabricate a comparable number - both readings come from the same
  polled runs, not hand-blended estimates.
- Always frame growth direction before presenting data - know whether the
  brand is gaining or losing before you write a word.
- A brand growing in a contracting category is a different story from a
  brand contracting in a growing category - always call this out.
- Location and category stay plain language - there is no lookup tool for
  either.
- Vocabulary: "demand signals", "demand", "consumer interest" - never
  "keywords", "search volume", "SEO", "queries". No em dashes anywhere.
