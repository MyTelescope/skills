---
name: mytelescope-bot-access-audit
description: >
  Use this skill when the user asks whether AI bots can crawl their site.
  Trigger for: "Can AI bots access my site?", "Is my site blocked from AI
  crawlers?", "Does my robots.txt block ChatGPT?", "Can Perplexity index my
  content?", "Check if AI can read my website", "Am I blocking AI bots?", or
  any request to audit whether AI systems are permitted to crawl and index
  the user's website.
---

# Bot Access Audit

## What this skill does

Answers "Can AI bots crawl my site?" by fetching the robots.txt file at
the user's domain and parsing which AI crawlers are explicitly allowed,
blocked, or not addressed. The output is a structured report with a plain-
language recommendation for each crawler..

The one tool that drives this skill:
- `web_fetch` - retrieve the robots.txt file and any referenced disallow
  pages at the user's domain

---

## Step 1: Get the domain

Extract the domain from the user's message. If it is missing, ask:
> "What is your website domain? For example: example.com"

Do not proceed without a confirmed domain. Do not guess or infer the domain
from the brand name alone — get it explicitly.

---

## Step 2: Fetch robots.txt

Call `web_fetch` for the robots.txt file at the root of the domain:

```
web_fetch(url="https://[domain]/robots.txt")
```

If that returns a 404 or empty response, also try:
```
web_fetch(url="http://[domain]/robots.txt")
```

If neither returns a valid robots.txt, note that the file is missing — this
is itself a significant finding, as a missing robots.txt means no explicit
instructions are given to any crawler.

---

## Step 3: Parse crawler rules

Parse the robots.txt and identify the rules that apply to each of the
following AI crawlers:

| Crawler | Platform |
|---------|----------|
| `GPTBot` | OpenAI / ChatGPT |
| `OAI-SearchBot` | OpenAI search |
| `ClaudeBot` | Anthropic / Claude |
| `anthropic-ai` | Anthropic |
| `PerplexityBot` | Perplexity |
| `GoogleBot` | Google (including Gemini AI overviews) |
| `Google-Extended` | Google Gemini and Vertex AI training |
| `Bingbot` | Microsoft / Copilot |
| `ChatGPT-User` | ChatGPT browsing |
| `cohere-ai` | Cohere |
| `meta-externalagent` | Meta AI |

For each crawler, determine:
- **Allowed** - explicitly allowed, or no disallow rule (treated as allowed)
- **Blocked** - explicitly disallowed via `Disallow: /` or a broad disallow
- **Partially restricted** - disallowed from specific paths only

Also note any wildcard rules (`User-agent: *`) and what they mean for
crawlers not specifically named.

---

## Step 4: Build the access audit dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact. Make it visual and instantly scannable.

The artifact must show:
- A color-coded status board for each AI crawler: green (Allowed), red (Blocked), orange (Partial)
- An overall access score or summary at the top
- For each blocked or partial crawler: a one-line recommended robots.txt fix shown inline

A user should be able to see their full AI access status in seconds without reading a report.

---

## Step 5: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 6: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## Hard rules

**Always check for the wildcard rule.** A `User-agent: *` rule with
`Disallow: /` blocks all unnamed crawlers, including most AI bots. Never
skip this check.

**Always flag a missing robots.txt.** The absence of robots.txt is a finding,
not a reason to stop. Report it and explain what it means for each platform.

**Never fabricate file contents.** Only report what `web_fetch` actually
returns. If the file is inaccessible, say so.

**Give a recommendation for every blocked crawler.** A list of blocked bots
without guidance on what to do is not useful. Every blocked crawler gets a
plain-language action.

**Vocabulary.** "AI crawler", "bot access", "indexing" - never "keywords",
"search volume", "SEO".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `web_fetch` | 2 | Retrieve robots.txt from the user's domain |