# Campaign Planning

Answers "Plan a campaign for this product" by auditing competitor messaging and active campaigns, then cross-referencing with demand data to validate message-market fit. Output is a structured campaign plan with channel selection, validated message territories, demand-grounded timing, and a map of what competitors already own.

---

## Step 1: Understand the request

Extract:
- **Product or brand** - what the campaign is for
- **Campaign objective** - awareness, conversion, retention, or launch (ask if not specified)
- **Target audience** - who the campaign addresses (ask if not specified)
- **Competitors** - up to 4 brands to audit for messaging (ask if not specified)
- **Location** - country or region (ask if missing)
- **Timeline** - campaign duration or flight window (ask if not specified)

Call `get_location_details` to resolve the location ID.

---

## Step 2: Audit competitor messaging and campaigns

For each competitor, use `web_search` to find current messaging, active campaigns, and recent advertising activity. Use `web_fetch` for the most relevant results to read the full content.

```
web_search(query="[competitor] campaign [year] advertising")
web_search(query="[competitor] [product category] messaging positioning")
```

For each competitor, extract: the core campaign message or tagline, the channel mix, the audience they address, and what they do not say. Build a messaging map of which territories each competitor has claimed.

---

## Step 3: Discover demand signals and validate timing

Call `search_signals` with the product category and relevant variants to find what consumers are looking for.

```
search_signals(query="[product category]", location_id="<id>")
search_signals(query="[product use case]", location_id="<id>")
```

Then call `get_demand_volume` to measure volume and seasonality:

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Cross-reference the intended message territory against the demand data: Is there real consumer interest? Is the territory growing or contracting? Does any competitor clearly own it?

---

## Output

Present the campaign plan as a structured document.

**Campaign Plan — [Brand] — [Market] — [Date]**

| Section | Content |
|---------|---------|
| Campaign objective | One sentence grounded in the brief |
| Recommended message territory | Territory name, demand evidence (signal + volume), competitor status |
| Alternative territories | 1-2 options with demand evidence and risk notes |
| What to avoid | Competitor-owned territories with competitor name |
| Recommended channels | 3-4 channels with one-sentence rationale each |
| Campaign timing | Recommended launch window based on demand seasonality peaks |
| Consumer language | Actual signal phrases consumers use — use these in creative |

Below the table, state:
- Which territory to lead with and why (demand + competitive white space)
- The optimal launch window from the monthly volume patterns
- The highest-risk territory to avoid and which competitor owns it

---

## Rules

- Always audit competitors before recommending territories — the audit is mandatory
- Always ground timing in demand seasonality, not gut feel or budget cycles
- Validate every territory against both demand data and competitor positioning
- Never invent competitor activity — only report what web search and fetch results show
- Vocabulary: "demand signals", "consumer interest", "message-market fit" - never "keywords", "search volume", "SEO"