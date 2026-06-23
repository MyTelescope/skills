# Strategic Focus

Answers "Where should I play?" by cross-referencing what competitors already own in messaging and positioning against where real consumer demand exists but remains unclaimed. Output is a strategic recommendation with where to play, how to win, and what to avoid.

---

## Step 1: Understand the request

Extract:
- **Brand** - whose strategic focus is being defined
- **Category** - the space to map (infer from brand if not stated)
- **Competitors** - who to audit (ask for up to 4 if not specified: "Which competitors should I audit for positioning and messaging? Name up to 4.")
- **Location** - country or region (ask if missing)

Call `get_location_details` to resolve the location ID.

---

## Step 2: Audit competitor positioning and messaging

For each competitor, use `web_search` to find their current positioning, taglines, campaign messages, and content themes. Use `web_fetch` for the most relevant results to read actual content rather than snippets.

```
web_search(query="[competitor] brand positioning messaging [year]")
web_search(query="[competitor] advertising campaign [category]")
```

For each competitor, extract: the core positioning territory they own, specific language and claims they repeat consistently, any audience they explicitly target, and what they do not talk about. Build a positioning map of occupied territories.

---

## Step 3: Discover demand signals in the category

Call `search_signals` with the category and relevant variants.

```
search_signals(query="[category]", location_id="<id>")
search_signals(query="[category variant]", location_id="<id>")
```

Then call `get_demand_volume` to understand which demand spaces are largest and which are growing.

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Group signals into 3-6 demand spaces by theme. Note total volume and trend direction per cluster.

---

## Step 4: Find the white space

Cross-reference the competitor positioning map against the demand clusters. A genuine white space is a demand cluster where: (1) consumer demand is real and measurable, (2) no competitor currently owns this space with consistent messaging, and (3) the brand could credibly enter. Distinguish between true white spaces (nobody owns it), soft white spaces (competitors present but weakly), and owned territory (a competitor owns it clearly).

---

## Output

Present the strategic focus recommendation as a structured document.

**Strategic Focus — [Brand] — [Market] — [Date]**

**Demand spaces and competitive density**

| Demand space | Volume | Trend | Competitor ownership | Opportunity |
|-------------|--------|-------|---------------------|-------------|
| [Space 1] | 45k | Growing | Unowned | Play here |
| [Space 2] | 38k | Growing | [Competitor A] — strong | Avoid |
| [Space 3] | 22k | Flat | [Competitor B] — weak | Soft entry |
| [Space 4] | 18k | Growing | Unowned | Play here |

**Where to play**
1-3 specific demand spaces representing the strongest opportunity. For each: demand evidence, volume and growth direction, and why competitors have not claimed it convincingly.

**How to win**
For each recommended space: the positioning angle or message direction the brand could own, using the actual consumer language from the demand signal names.

**What to avoid**
Territories already owned strongly by a competitor. Name the competitor and specific territory.

**Competitive context**
What each key competitor currently stands for, in one sentence each.

---

## Rules

- Always audit competitors before looking at demand — finding white space requires knowing occupied ground
- Every recommendation needs both demand evidence AND competitive white space — one without the other is not enough
- Never invent competitor positioning — only report what web search and fetch results actually show
- Vocabulary: "demand signals", "demand spaces", "consumer interest" - never "keywords", "search volume", "SEO"