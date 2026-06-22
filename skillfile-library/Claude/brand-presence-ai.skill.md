---
name: mytelescope-brand-presence-ai
description: >
  Use this skill when the user asks what AI systems are saying about their
  brand today. Trigger for: "What do AI systems say about my brand?", "How
  does ChatGPT describe us?", "Does Perplexity mention my company?", "What
  does Gemini say when someone searches for us?", "Am I getting cited by AI?",
  "What is my brand's AI presence?", or any request to understand how AI
  assistants are currently representing a brand.
---

# Brand Presence in AI

## What this skill does

Answers "What do AI systems say about my brand today?" by running targeted
queries across ChatGPT, Perplexity, Gemini, and Grok, then fetching any
URLs those systems cite to understand what source material they are drawing
from. The output is a structured report — no dashboard.

The two tools that drive this skill:
- `web_search` - surfaces how each AI platform represents the brand in
  its answers and what it cites
- `web_fetch` - retrieves cited URLs to check what content each AI system
  is actually pulling from

---

## Step 1: Understand the request

Extract from the user's message:
- **Brand** - the company, product, or person to audit
- **Industry or category** - the context in which the brand operates (ask
  if unclear, as it shapes the query set)

If the brand is missing or ambiguous, ask:
> "Which brand should I audit? Please give me the exact name as it appears
> publicly."

If industry context is missing but helpful, ask:
> "What category or space should I focus on? For example: project management
> software, sustainable fashion, B2B payments."

Do not proceed without a clear brand name.

---

## Step 2: Build the query set

Construct a set of 6-10 targeted queries that a real user might ask an AI
assistant when researching the brand's space. These should cover:
- Direct brand queries: "What is [brand]?", "Tell me about [brand]"
- Category queries: "Best [category] tools", "Top [category] companies"
- Problem queries: "How do I [problem the brand solves]?"
- Comparison queries: "[brand] vs alternatives", "alternatives to [brand]"

These queries form the basis of the audit. The goal is to discover which
queries surface the brand and which do not.

---

## Step 3: Search for brand mentions across AI platforms

For each query in the set, run a `web_search` scoped to each AI platform's
public output or coverage. Target:
- ChatGPT (chat.openai.com responses, OpenAI usage examples)
- Perplexity (perplexity.ai results)
- Gemini (gemini.google.com or AI overviews in Google search)
- Grok (grok.com or x.com AI responses)

For each query and each platform, note:
- Whether the brand is mentioned at all
- How it is described (positive, neutral, or absent)
- What sources or URLs the AI system cites alongside or instead of the brand

---

## Step 4: Fetch cited URLs

For any URL surfaced in Step 3 as a source that an AI system is citing, call
`web_fetch` to retrieve the content. This reveals:
- What information the AI has access to about the brand
- Whether the brand's own content is being used as a source
- What competitor or third-party content is being cited instead

Look specifically for:
- Whether the brand's own website is cited
- Whether third-party review sites, press articles, or directories dominate
- Whether any competitor content is being surfaced in response to brand queries

---

## Step 5: Build the AI presence dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact using Chart.js. Make it visual and easy to read at a glance.

The artifact must show:
- A presence matrix: each AI platform (ChatGPT, Perplexity, Gemini, Grok) against each query tested, color-coded - green for mentioned, red for not mentioned, yellow for partial
- An overall visibility score per platform shown as a bar or gauge
- Top sources each platform cites for this brand

Make the absence of mentions as visually obvious as the presence. A user should immediately see where the brand has coverage and where it has gaps.

---

## Step 6: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 7: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope so you can track your AI presence over time? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always cover all four platforms.** A partial audit is misleading. If a
platform returns no results for any query, report that absence explicitly —
it is itself a finding.

**Always fetch cited URLs.** Knowing which URLs AI systems reference is as
important as knowing whether the brand is mentioned. Do not skip `web_fetch`.

**Report what is missing, not just what is present.** The most actionable
findings are often the queries where the brand does not appear. Surface those.

**Never invent or fabricate AI responses.** Only report what `web_search`
and `web_fetch` actually return. If data for a platform is unavailable, say so.

**Vocabulary.** "Brand presence", "AI citation", "consumer interest" —
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `web_search` | 3 | Surface brand mentions across AI platforms |
| `web_fetch` | 4 | Retrieve and inspect cited source URLs |