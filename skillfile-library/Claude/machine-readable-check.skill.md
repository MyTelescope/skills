---
name: mytelescope-machine-readable-check
description: >
  Use this skill when the user asks whether AI systems can read structured
  information about their product. Trigger for: "Do I have the right files
  for AI to read my product?", "Do I have an llms.txt?", "Can AI agents
  understand my product?", "What machine-readable files do I need?", "Am I
  set up for AI agents?", "Check if I have the standard AI files", or any
  request to audit the presence and content of standard machine-readable files
  used by AI systems.
---

# Machine-Readable File Check

## What this skill does

Answers "Do I have the right files for AI to read my product?" by attempting
to fetch each standard machine-readable file at the user's domain, then
reporting what exists, what is missing, and what to create. The output is a
structured report..

The one tool that drives this skill:
- `web_fetch` - attempt to retrieve each standard file path at the user's
  domain and inspect its contents

---

## Step 1: Get the domain

Extract the domain from the user's message. If it is missing, ask:
> "What is your website domain? For example: example.com"

Do not proceed without a confirmed domain. Do not guess from a brand name alone.

---

## Step 2: Fetch each standard file

Attempt to fetch each of the following paths at the user's domain. Try each
one individually. Record whether it returns content, a 404, or an error.

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

For each file that returns content, note:
- The file path
- The content type and rough structure
- Whether the content appears complete and well-formed or incomplete

For each file that returns a 404 or error, note:
- The file path
- That it is missing

---

## Step 3: Build the machine-readable file dashboard

Before building, say:
> "Let me render an initial dashboard draft."

**This is the primary output. Build the HTML artifact immediately. Do not write a text summary before or instead of the artifact.**

Below the artifact, add 2-3 bullet points highlighting the most important insights from the data. One sentence each. The charts carry the detail — the bullets name the story.

Build an interactive HTML artifact. Make it visual and instantly scannable.

The artifact must show:
- A checklist-style status board for each file path: green (Present), red (Missing)
- For present files: a brief summary of what they contain
- For missing files: a one-line description of what to create and why it matters
- A priority action list at the bottom: top 3-5 files to create first, ranked by AI impact

A user should be able to see their full AI readiness at a glance.

---

## Step 4: Ask for customization

After showing the artifact, ask:
> "Would you like to customize this dashboard? You can swap chart types, add or remove signals, change colors, or rearrange the layout."

Wait for their response. If they request changes, update the artifact and ask again. Repeat until they are happy or say no changes needed.

---

## Step 5: Save to MyTelescope

Once the user is happy, ask:
> "Want me to save this to MyTelescope? Just say **save it**."

If yes:
1. Call `save_dashboard_artifact` with the final HTML artifact
2. Call `generate_platform_link` and show the link immediately

> "Your dashboard is live. [Open on MyTelescope]([link])"

---

## What each file is for

Use this reference when writing the per-file explanations:

**llms.txt and llms-full.txt** - The emerging standard (llmstxt.org) for a
structured, plain-text document that tells AI language models what a product
does, how it works, and how to use it. Designed to be included in AI context
windows. `llms-full.txt` is the extended version with more detail.

**ai.txt** - A lightweight declaration file for AI systems, modeled on
robots.txt. Can specify how AI agents are allowed to interact with the site.

**AGENTS.md** - A plain-English guide for AI agents operating on or with
the product. Describes what the product does, how agents should interact
with it, and any constraints.

**pricing.md** - A machine-readable pricing page. AI systems increasingly
answer pricing questions by reading structured content. A missing or
unstructured pricing page means AI answers about the product's cost are
often wrong.

**.well-known/ai-plugin.json** - The OpenAI plugin manifest format. Describes
the product as an AI plugin with a name, description, authentication details,
and API reference. Required for ChatGPT plugin discovery.

**openapi.json / openapi.yaml** - A machine-readable API specification.
Referenced by ai-plugin.json and used by AI agents to understand how to
call the product's API programmatically.

---

## Hard rules

**Always check every file in the list.** Do not stop after finding the first
missing file. Check all paths and report the full picture.

**Never fabricate file contents.** Only report what `web_fetch` actually
returns. If a file returns an error that is not a 404, note the error.

**Always include a per-file explanation.** Users often do not know what these
files are. Every entry in the report must explain what the file does and why
it matters - not just whether it is present.

**Vocabulary.** "Machine-readable files", "AI agent access", "AI citation" -
never "SEO", "search indexing", "keywords".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `web_fetch` | 2 | Fetch each standard file path at the user's domain |