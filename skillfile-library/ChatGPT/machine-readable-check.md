# Machine-Readable File Check

Answers "Do I have the right files for AI to read my product?" by attempting to fetch each standard machine-readable file at the user's domain, then reporting what exists, what is missing, and what to create. Output is a structured AI readiness report.

---

## Step 1: Get the domain

Extract the domain from the user's message. If missing, ask: "What is your website domain? For example: example.com"

Do not proceed without a confirmed domain. Do not guess from a brand name alone.

---

## Step 2: Fetch each standard file

Attempt to fetch each of the following paths individually. Record whether it returns content, a 404, or an error.

```
web_fetch(url="https://[domain]/llms.txt")
web_fetch(url="https://[domain]/llms-full.txt")
web_fetch(url="https://[domain]/ai.txt")
web_fetch(url="https://[domain]/AGENTS.md")
web_fetch(url="https://[domain]/agents.md")
web_fetch(url="https://[domain]/pricing.md")
web_fetch(url="https://[domain]/.well-known/ai-plugin.json")
web_fetch(url="https://[domain]/openapi.json")
web_fetch(url="https://[domain]/openapi.yaml")
```

For each file that returns content, note the file path, content type, and whether the content appears complete and well-formed. For each file that returns a 404 or error, note that it is missing.

---

## Output

Present the full readiness table followed by a priority action list.

**Machine-Readable File Check — [Domain] — [Date]**

| File | Status | What it does | Priority action |
|------|--------|-------------|----------------|
| /llms.txt | Present | Structured product description for AI context windows | Review content quality |
| /llms-full.txt | Missing | Extended version of llms.txt with more detail | Create — high AI impact |
| /ai.txt | Missing | AI interaction declaration, modeled on robots.txt | Create — quick win |
| /AGENTS.md | Missing | Plain-English guide for AI agents on how to interact with the product | Create — important for agent use |
| /pricing.md | Missing | Machine-readable pricing so AI answers pricing questions correctly | Create — AI often gets pricing wrong without this |
| /.well-known/ai-plugin.json | Missing | OpenAI plugin manifest — required for ChatGPT plugin discovery | Create if targeting ChatGPT integration |
| /openapi.json | Missing | Machine-readable API specification for AI agents | Create if product has an API |

**Top 3 actions (ranked by AI impact):**
1. [Highest-priority missing file and why]
2. [Second-priority missing file and why]
3. [Third-priority missing file and why]

---

## Rules

- Always check every file in the list — do not stop after finding the first missing file
- Never fabricate file contents — only report what `web_fetch` actually returns
- Always include a per-file explanation — users often do not know what these files are
- Vocabulary: "machine-readable files", "AI agent access", "AI citation" - never "SEO", "search indexing", "keywords"