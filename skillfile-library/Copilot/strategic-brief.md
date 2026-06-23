# Strategic Brief

Answers "Build me a strategic brief for this brand" by searching the brand's knowledge base for existing context, then grounding every section of the brief in real demand signal language. Output is a structured brief written in the words consumers actually use, not agency-invented language.

---

## Step 1: Understand the request

Extract:
- **Brand or product** - what the brief is for
- **Location** - country or region (ask if missing)
- **Audience or objective** - any brief, campaign, or audience constraints mentioned

Call `get_location_details` to resolve the location ID.

---

## Step 2: Search the brand knowledge base

Call `knowledge_search` to retrieve any existing brand documents, prior briefs, tone of voice guides, or positioning materials. Run multiple queries.

```
knowledge_search(query="[brand] brand positioning")
knowledge_search(query="[brand] target audience")
knowledge_search(query="[brand] tone of voice")
knowledge_search(query="[brand] product benefits")
```

Extract: stated brand purpose or positioning, known audience descriptions, product or service benefits and proof points, and any existing strategic or creative direction. If the knowledge base returns nothing useful, note that the brief will be built from demand signals alone.

---

## Step 3: Pull demand signals for the category

Call `search_signals` to discover what consumers are expressing in the brand's category.

```
search_signals(query="[brand category]", location_id="<id>")
search_signals(query="[brand product type]", location_id="<id>")
```

Then call `get_demand_volume` on the discovered signals:

```
get_demand_volume(
    keywords=["signal 1", "signal 2", ...],
    location_id="<id>",
    language_id="<language>"
)
```

Use the signal names and volume patterns to understand: what language consumers use (this becomes the brief's vocabulary), the dominant consumer need in the category, the single biggest tension or unmet desire in the demand data, and which benefit or outcome drives the most consumer interest.

---

## Output

Present the strategic brief as a structured document.

**Strategic Brief — [Brand] — [Market] — [Date]**

**The challenge**
One sentence. What tension or problem does the brand exist to solve? Use the demand signal language to name it precisely.

**Human insight**
One to two sentences. What does the demand data reveal about how consumers actually feel about this category? Reference dominant signals and volumes to ground it.

**Single-minded idea**
One sentence. The brand's response to the insight. Written in plain language, not adspeak.

**Reason to believe**

| # | Claim | Source |
|---|-------|--------|
| 1 | [proof point] | [knowledge base document or demand signal] |
| 2 | [proof point] | [knowledge base document or demand signal] |
| 3 | [proof point] | [knowledge base document or demand signal] |

**Consumer language**
The actual phrases consumers use — pulled from the top-volume signal names. These are the words the brief's creative output should echo.

**What to avoid**
Language, territories, or positions that the demand data shows consumers associate with competitors, or that have flat or contracting demand.

---

## Rules

- Always search the knowledge base first — a brief built blind may violate brand rules
- Always pull demand signals — the brief vocabulary must come from real consumer language
- Never use made-up insights — every claim must be traceable to a knowledge base document or demand signal
- Vocabulary: "demand signals", "consumer interest", "consumer language" - never "keywords", "search volume", "SEO"