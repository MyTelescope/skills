# Competitive AI Comparison

Compares how a brand and its competitors are represented across AI platforms (ChatGPT, Perplexity, Gemini, Grok). Shows who gets cited, for which queries, and how often.

---

## Step 1: Understand the request

Extract:
- **Brand** - the user's brand
- **Competitors** - up to 5 brands to compare against (ask if missing)
- **Category** - the space they compete in (infer if possible)

If competitors are missing, ask: "Which competitors should I compare against?"

---

## Step 2: Build a shared query set

Write 8-10 neutral queries a real user might ask an AI assistant in this category. Do not name any brand in the queries. Cover:
- Category queries: "Best [category] tools", "Top [category] companies"
- Problem queries: "How do I [problem these brands solve]?"
- Comparison queries: "Which [category] tool should I use?"
- Feature queries: "[Category] tool with [key feature]"

Use the same query set for every brand. No exceptions.

---

## Step 3: Run queries across platforms

For each query, use `web_search` scoped to each AI platform and record for each brand:
- Cited or not cited
- Positioning: first, mid, or buried
- How the brand is described

Cover all four platforms: ChatGPT, Perplexity, Gemini, Grok.

---

## Step 4: Score each brand

Calculate per brand:
- **Citation rate** - % of queries that trigger a mention
- **Platform coverage** - how many of the 4 platforms cite this brand
- **Query type wins** - which query types trigger a mention
- **Positioning** - typically first, mid, or buried

---

## Step 5: Output

Present a markdown table followed by 2-3 key takeaways.

**AI Visibility Comparison — [Category] — [Date]**

| Brand | Citation rate | Platforms | Best query type | Positioning |
|-------|--------------|-----------|-----------------|-------------|
| [Brand] | X% | ChatGPT, Perplexity | Comparison | First |
| [Competitor 1] | X% | All 4 | Category | Mid |
| [Competitor 2] | X% | Gemini only | Feature | Buried |

Below the table, state:
- Who leads overall and why
- Where the user's brand is losing most visibility
- The single highest-impact query type to target

---

## Rules

- Always use the same query set for every brand
- Always cover all four AI platforms - absence is a finding, not a skip
- Always produce a clear ranking with a named leader
- Vocabulary: "AI citation", "AI visibility" - never "keywords", "SEO", "search volume"