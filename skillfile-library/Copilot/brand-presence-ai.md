# Brand Presence in AI

Audits what AI systems are saying about a brand today across ChatGPT, Perplexity, Gemini, and Grok. Shows where the brand appears, how it is described, and what sources AI is drawing from.

---

## Step 1: Understand the request

Extract:
- **Brand** - the company or product to audit
- **Category** - the space the brand operates in (ask if unclear)

If the brand name is ambiguous, ask: "What is the exact public name of the brand?"

---

## Step 2: Build the query set

Write 6-10 queries a real user might ask when researching this brand:
- Direct brand queries: "What is [brand]?", "Tell me about [brand]"
- Category queries: "Best [category] tools", "Top [category] companies"
- Problem queries: "How do I [problem the brand solves]?"
- Comparison queries: "[brand] vs alternatives"

---

## Step 3: Search each AI platform

For each query, run `web_search` scoped to each platform (ChatGPT, Perplexity, Gemini, Grok). Record:
- Whether the brand is mentioned
- How it is described (positive, neutral, or absent)
- What URLs or sources the AI cites alongside the brand

For cited URLs, run `web_fetch` on the most important ones to understand what content each AI platform is drawing from.

---

## Step 4: Output

Present a markdown table per platform, then a summary table, then 2-3 takeaways.

**Brand Presence Audit — [Brand] — [Date]**

| Platform | Queries tested | Brand mentioned | Mention rate | Typical description | Top cited source |
|----------|---------------|-----------------|--------------|---------------------|-----------------|
| ChatGPT | 10 | 6 | 60% | "leading X for Y" | [source] |
| Perplexity | 10 | 4 | 40% | "X solution" | [source] |
| Gemini | 10 | 2 | 20% | Absent in most | [source] |
| Grok | 10 | 1 | 10% | Not cited | - |

Below the table, state:
- Where AI presence is strongest and weakest
- What sources AI is relying on most - own site, press, directories, or competitors
- The most important gap to close

---

## Rules

- Always cover all four platforms - absence is a finding
- Always fetch cited URLs - knowing what content AI uses is as important as whether the brand appears
- Never fabricate AI responses - only report what web_search actually returns
- Vocabulary: "AI citation", "brand presence" - never "keywords", "SEO", "search volume"