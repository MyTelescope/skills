# Demand Signals by Persona

Shows how different audience segments search a topic across traditional platforms (Google, YouTube) and generative AI platforms (ChatGPT, Perplexity, Gemini). Clusters consumer queries by user type so the user can see which personas drive demand and how their search behaviour differs by platform.

---

## Step 1: Understand the request

Extract:
- **Topic** - the category or subject to analyse
- **Location** - country or region (ask if missing)
- **Personas** - specific audience segments to focus on (infer from the topic if not stated - e.g. for weight management: "people trying to lose weight", "medical patients", "fitness enthusiasts")

If location is missing, ask: "Which market should I look at?"

Call `get_location_details` to resolve the location ID.

---

## Step 2: Discover demand signals

Call `search_signals` with the topic and 2-3 variants to surface the full signal set.

```
search_signals(query="[topic]", location_id="<id>")
search_signals(query="[topic variant]", location_id="<id>")
```

As you review the signals, cluster them by the persona they most likely represent. A signal like "ozempic weight loss" belongs to a different persona than "how to lose weight without exercise" or "weight loss meal plan for athletes". Name each persona cluster based on the intent pattern.

---

## Step 3: Measure traditional platform demand

Call `get_demand_volume` on all discovered signals.

```
get_demand_volume(keywords=[...], location_id="<id>", language_id="<language>")
```

Extract per signal: monthly volume, trend direction, YoY change %.

---

## Step 4: Research generative platform patterns

For each persona cluster, use `web_search` to find how users of that persona type query AI platforms. Search for:
- What questions this persona asks ChatGPT or Perplexity about this topic
- How AI platforms frame answers for this persona type
- Which brands or solutions AI recommends to this persona

```
web_search(query="[persona type] asking about [topic] on ChatGPT Perplexity")
web_search(query="[topic] questions from [persona] AI assistant")
```

Note how the query language and intent differs from traditional platform signals for the same persona.

---

## Step 5: Output

Present a persona-by-platform table followed by 2-3 key takeaways.

**Demand Signals by Persona — [Topic] — [Market] — [Date]**

| Persona | Traditional signals (Google) | Volume | Trend | Generative AI query pattern | Platform difference |
|---------|------------------------------|--------|-------|----------------------------|---------------------|
| [Persona 1: e.g. Medical patient] | "ozempic for weight loss", "GLP-1 doctor" | 28k | +180% | "Is ozempic safe for me?", "Ask doctor about weight loss medication" | AI queries are more cautious and question-led |
| [Persona 2: e.g. Fitness seeker] | "weight loss workout plan", "how to lose weight fast" | 41k | +12% | "Best workout plan to lose 10kg", "What exercise burns most fat" | Similar intent, AI gives structured plans |
| [Persona 3: e.g. Diet follower] | "keto diet weight loss", "intermittent fasting results" | 19k | -8% | "Does keto actually work?", "Is intermittent fasting safe long term" | AI queries are more sceptical and research-led |

Below the table, state:
- Which persona drives the most total demand and whether that is shifting
- Which persona shows the biggest gap between traditional and generative search behaviour - this is where content strategy needs to split
- Any persona whose AI query language signals a new content opportunity not yet covered by traditional signals

---

## Rules

- Always name personas based on actual signal intent - never invent generic segments like "demographic A"
- Always show both traditional and generative platform patterns side by side - the comparison is the insight
- Never invent demand figures - only use volumes from get_demand_volume
- If persona clusters are unclear from signals alone, state the inferred clusters and ask the user to confirm before outputting
- Vocabulary: "demand signals", "consumer interest", "persona", "audience segment" - never "keywords", "SEO", "search volume"