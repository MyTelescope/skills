#!/bin/bash

# Creates the mytelescope Agent Skill folder structure
mkdir -p mytelescope/references

cat > mytelescope/SKILL.md << 'EOF'
---
name: mytelescope
description: >
  Analyze search trends, market share, competitive intelligence, and consumer demand
  using MyTelescope's search intelligence platform. Use when the user asks about:
  trending topics, rising search terms, competitive search share, year-over-year
  search performance, keyword research, demand analysis, B2B brand building,
  the 95:5 rule, Demand Point Constellations, or "what are people searching for
  about X". Requires the MyTelescope MCP connector to be active.
license: MIT
metadata:
  author: your-org
  version: "1.0"
---

# MyTelescope Skill

Use MyTelescope's search intelligence tools to surface trends, competitive insights,
and consumer demand signals grounded in real search data.

## MCP Connector Required

This skill uses the **MyTelescope MCP server**. Before using any tool, call
`get_available_tools` once per session to confirm the server is active.

MCP Server URL: `https://mytelescope-mcp-server-v2-riqik3bz3a-uc.a.run.app/mcp`

---

## Workflow

Always follow this sequence:

### Step 1 — Discover Dashboards
Call `list_public_dashboards` with a relevant query to find dashboards
related to the user's topic.

```
list_public_dashboards(query="<topic or industry>", limit=10)
```

Extract from the result:
- `dashboard_id` — the unique ID of the dashboard
- `tracker_ids` — the list of topic/brand tracker IDs inside the dashboard

If no dashboards are found, call:
```
dashboard_or_topic_message(message_type="no_dashboards_or_topics")
```

### Step 2 — Choose the Right Analysis Tool

| User Intent | Tool to Use |
|---|---|
| "How does X compare to Y?" | `calculate_search_share` |
| "What are people searching for about X?" | `calculate_top_search_terms` |
| "What's trending / rising in X?" | `calculate_rising_search_terms` |
| "How has search changed year over year?" | `calculate_yoy` |
| "Explain Demand Points / 95:5 rule / Brand Agent" | `ask_mytelescope` |

### Step 3 — Call the Analysis Tool

All analysis tools require:
- `dashboard_id` (from Step 1)
- `tracker_ids` (from Step 1, pass as list)
- `date_from` and `date_to` in `YYYY-MM` format

**For YoY analysis**, use `months` as a list of strings e.g. `["01","02","03"]`

---

## Tool Reference

### `calculate_search_share`
Returns pie chart + line chart data showing each tracker's share of total
search interest over a date range. Best for competitive landscape comparisons.

### `calculate_top_search_terms`
Returns the most-searched terms within a tracker's topic area. Use for
keyword research, content planning, and understanding user intent.

### `calculate_rising_search_terms`
Returns search terms with the highest growth rate in the period vs prior
periods. Use to surface emerging trends and opportunities early.

### `calculate_yoy`
Compares search volume for specific months across years. Use to understand
seasonality and long-term brand/category growth.

### `ask_mytelescope`
Answers questions grounded in MyTelescope's knowledge base. Covers:
- The **95:5 rule** (only ~5% of B2B buyers are in-market at any time)
- **Demand Point Constellations** (emotional/cognitive motivations driving demand)
- **B2B brand building** strategy
- **Category Entry Points** and mental availability

---

## Date Format

Always use `YYYY-MM` format. Examples:
- Last 12 months: `date_from: "2024-03"`, `date_to: "2025-03"`
- Last quarter: `date_from: "2024-10"`, `date_to: "2024-12"`
- YoY months: `months: ["01","02","03"]`

---

## Example Conversations

**"What's trending in electric vehicles?"**
1. `list_public_dashboards(query="electric vehicles")`
2. `calculate_rising_search_terms(dashboard_id=..., tracker_ids=[...], date_from="2024-09", date_to="2025-03")`

**"How does our brand compare to competitors in search?"**
1. `list_public_dashboards(query="<your industry>")`
2. `calculate_search_share(dashboard_id=..., tracker_ids=[brand_id, comp1_id, comp2_id], date_from="2024-01", date_to="2025-01")`

**"Explain the 95:5 rule"**
1. `ask_mytelescope(question="Explain the 95:5 rule and how it applies to B2B brand building")`

---

## Error Handling

If latest signals are unavailable despite a dashboard existing:
```
dashboard_or_topic_message(message_type="signals_not_set_up")
```

Direct the user to set up data collection at: https://app.mytelescope.io

---

## When NOT to Use This Skill
- Real-time stock prices or financial market data (MyTelescope covers search data only)
- Social media metrics or engagement data
- Private internal analytics not connected to MyTelescope
- Queries unrelated to search trends or brand/demand intelligence
EOF

cat > mytelescope/references/tools.md << 'EOF'
# MyTelescope MCP Tools Reference

## get_available_tools
Returns info about all available tools. Call once per session to confirm the server is active.

## ask_mytelescope
- param: `question` (string)
- Covers: 95:5 rule, Demand Point Constellations, B2B brand building, Category Entry Points

## list_public_dashboards
- param: `query` (string) — filter by name or topic
- param: `limit` (integer, default 10)
- Returns: list of dashboards with `dashboard_id` and `tracker_ids`

## calculate_search_share
- params: `dashboard_id`, `tracker_ids` (list), `date_from` (YYYY-MM), `date_to` (YYYY-MM)
- Returns: pie chart + line chart data for competitive share

## calculate_top_search_terms
- params: `dashboard_id`, `tracker_ids` (list), `date_from`, `date_to`, `limit` (default 10)
- Returns: top search queries ranked by volume

## calculate_rising_search_terms
- params: `dashboard_id`, `tracker_ids` (list), `date_from`, `date_to`
- Returns: fastest-growing search terms in the period

## calculate_yoy
- params: `dashboard_id`, `tracker_ids` (list), `months` (list of strings e.g. ["01","12"])
- Returns: year-over-year comparison by month

## dashboard_or_topic_message
- param: `message_type` — "no_dashboards_or_topics" | "signals_not_set_up"
- Returns: user-friendly guidance message
EOF

echo ""
echo "✅ Skill created successfully!"
echo ""
echo "📁 Structure:"
find mytelescope -type f
echo ""
echo "👉 Next steps:"
echo "  1. cd mytelescope"
echo "  2. Push to a GitHub repo: git init && git add . && git commit -m 'Add MyTelescope skill'"
echo "  3. Share: npx skills add <your-username>/<your-repo>"