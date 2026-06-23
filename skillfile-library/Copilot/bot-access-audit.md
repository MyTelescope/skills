# Bot Access Audit

Answers "Can AI bots crawl my site?" by fetching the robots.txt file at the user's domain and parsing which AI crawlers are explicitly allowed, blocked, or not addressed. Output is a structured access report with a plain-language recommendation for each crawler.

---

## Step 1: Get the domain

Extract the domain from the user's message. If missing, ask: "What is your website domain? For example: example.com"

Do not proceed without a confirmed domain. Do not guess from a brand name alone.

---

## Step 2: Fetch robots.txt

Call `web_fetch` for the robots.txt at the root of the domain:

```
web_fetch(url="https://[domain]/robots.txt")
```

If that returns a 404 or empty response, also try `http://[domain]/robots.txt`. If neither returns a valid file, note that robots.txt is missing — this is itself a significant finding.

---

## Step 3: Parse crawler rules

Parse the robots.txt and identify the rules that apply to each of the following AI crawlers:

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

For each crawler, determine: Allowed, Blocked, or Partially restricted. Always check the wildcard `User-agent: *` rule.

---

## Output

Present the full access status table followed by 2-3 key recommendations.

**Bot Access Audit — [Domain] — [Date]**

| Crawler | Platform | Status | Robots.txt fix (if blocked) |
|---------|----------|--------|------------------------------|
| GPTBot | OpenAI / ChatGPT | Blocked | `User-agent: GPTBot` / `Allow: /` |
| ClaudeBot | Anthropic / Claude | Allowed | - |
| PerplexityBot | Perplexity | Partial | `User-agent: PerplexityBot` / `Allow: /` |
| ... | ... | ... | ... |

Below the table, state:
- The overall access posture (open, restrictive, or mixed)
- The most impactful fix if any high-priority crawlers are blocked
- What a missing robots.txt means for AI indexing

---

## Rules

- Always check the wildcard `User-agent: *` rule — `Disallow: /` blocks all unnamed crawlers including most AI bots
- Always flag a missing robots.txt as a finding, not a reason to stop
- Never fabricate file contents — only report what `web_fetch` actually returns
- Give a recommended fix for every blocked crawler
- Vocabulary: "AI crawler", "bot access", "indexing" - never "keywords", "search volume", "SEO"