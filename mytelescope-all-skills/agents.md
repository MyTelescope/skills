# MyTelescope MCP Server

MyTelescope exposes a Model Context Protocol (MCP) server that gives AI assistants and agents access to real-time demand intelligence data. This file describes the available tools, how to connect, and what use cases the server supports.

---

## Connection

**MCP server URL:** https://mytelescope-orchestrator-mcp-amjjfcdvoa-uc.a.run.app/mcp  
**Protocol:** MCP (Model Context Protocol) over HTTP/SSE  
**Authentication:** API key required (obtain at mytelescope.ai)  
**Compatible with:** Claude (Anthropic), Microsoft Copilot, and any MCP-compatible AI assistant

To connect in Claude: go to Settings > Integrations > Add MCP server and paste the URL above.

---

## What this server does

MyTelescope MCP gives agents access to consumer demand signals aggregated from 11 platforms: Google, TikTok, YouTube, Amazon, Pinterest, Bing, Etsy, App Store, Play Store, eBay, and Perplexity. Agents can query live market data, run forecasts, and track brand performance without leaving their AI workflow.

---

## Available tools

### Demand signal search
`search_signals` - Search for demand signals by keyword or topic across all tracked platforms. Returns signal IDs, relevance scores, and platform sources. Use this before fetching volume data.

### Demand volume
`get_demand_volume` - Fetch monthly demand volume time-series for one or more signals. Returns historical data going back up to 3 years. Supports Google, TikTok, YouTube, Amazon, Pinterest, Bing, and more depending on location.

### Demand forecasting
`forecast_demand_ensemble` - Forecast future demand using an ensemble of ARIMA, SARIMA, ETS (Holt-Winters), Prophet, and XGBoost models. Returns monthly projections with confidence ranges. Best for planning and budgeting use cases.

Individual model forecasts also available: `forecast_demand_arima`, `forecast_demand_sarima`, `forecast_demand_ets`, `forecast_demand_prophet`, `forecast_demand_xgboost`, `forecast_demand_lstm`.

### Demand analysis
`calculate_demand_priorities` - Rank signals by total volume within a date range. Useful for identifying the highest-intensity topics in a category.

`calculate_demand_trajectory` - Calculate year-over-year volume shifts to detect growing or declining demand.

`calculate_emerging_demand` - Detect signals with the highest velocity (fastest-growing demand). Returns signals sorted by acceleration rate.

`calculate_demand_share` - Calculate demand share across signal groups over time (share of search).

### Location and language
`get_location_details` - Resolve a location name to an ID and check which data sources are available for that market.

`get_language_id` - Resolve a language name to an ID for use in signal queries.

### Dashboard and collection management
`list_user_signal_collections` - List saved dashboards for the authenticated user's company.

`search_user_signal_collections` - Search the user's saved signal collections by topic or keyword.

`create_signal_collection` - Create a new dashboard with tracked signal streams.

### Trend alerts
`create_trend_alert` - Set up an email notification triggered when demand for a signal changes significantly.

`list_trend_alerts` - List all active trend alerts for the current user.

### Knowledge and context
`knowledge_search` - Search the company knowledge base for brand strategy documents, briefs, and context files.

---

## Example agent tasks

These are tasks an AI agent can complete by calling this server:

- "What is the demand trend for [brand] in Germany over the last 12 months?"
- "Compare share of search between [brand A] and [brand B] in the US"
- "Forecast demand for [category] in Sweden for the next 6 months"
- "Which topics in [category] are growing fastest right now?"
- "Set up a trend alert for [brand] so I am notified if demand drops more than 20%"
- "What are the top 10 demand signals for heated tobacco products in Spain?"

---

## Data coverage

| Platform | Available in |
|----------|-------------|
| Google | Most markets globally |
| YouTube | Most markets globally |
| TikTok | US, UK, and major markets |
| Amazon | US, UK, DE, FR, and others |
| Pinterest | US, UK, and others |
| Bing | US, UK, and others |
| Perplexity | US |
| App Store | US and major markets |
| Play Store | US and major markets |
| Etsy | US, UK |
| eBay | US, UK, DE |

Call `get_location_details` with any location name to check exact source availability for that market.

---

## Accuracy

- 83% average correlation between demand signals and market share across 40+ validated categories
- Noise reduction exceeds 85-90% before modeling
- ETS (Holt-Winters) model performs best for seasonal and accelerating signals in backtesting
- Data refreshes monthly; leading indicators (pricing queries, comparison searches) move 4-8 weeks ahead of market events

---

## AI skills and workflows

MyTelescope ships a set of pre-built intelligence skills that AI assistants can run as complete workflows - not just individual tool calls. These are the core use cases the MCP server is designed to support.

### Demand intelligence (mytelescope-core)

The foundation skill. Runs before any strategic output - content plans, positioning, campaign concepts, competitor analysis. Workflow:

1. Load relevant framework via `knowledge_search`
2. Resolve location and language via `get_location_details`
3. Search for demand signals via `search_signals`
4. Fetch volume time-series via `get_demand_volume`
5. Run 6-month forecast via `forecast_demand_ensemble`
6. Answer the four baseline questions: branded demand volume, category status (Growing / Contracting / Flat), audience language, competitor ownership
7. Present trend chart + insight before any recommendation

Triggers for this skill: content planning, competitor analysis, market sizing, geographic expansion, campaign measurement, brand tracking, trend research, product launch research, any question about whether a market is growing or declining.

### AI visibility audit (mytelescope-ai-visibility)

A four-phase workflow for understanding and improving how a brand appears in AI-generated answers across ChatGPT, Perplexity, Google AI Overviews, Claude, and Copilot.

**Phase 0 - Strategic brief:** Establish the Single-Minded Idea (what the brand wants to be known for), target audience, and Reason to Believe. The audit measures everything against this north star.

**Phase 1 - Demand intelligence:** Run the mytelescope-core workflow for the brand and category. Answer: what is branded demand? Is category demand Growing / Contracting / Flat? What language does the audience use? What do competitors own?

**Phase 2 - AI visibility audit:** Visit and read the brand site. Check what AI systems actually find and cite right now. Test 5-10 priority queries. Check content extractability (static HTML, self-contained answer blocks, FAQ sections, schema markup). Check AI bot access in robots.txt. Check for machine-readable files (llms.txt, pricing.md, AGENTS.md).

**Phase 3 - Action plan:** Prioritized recommendations across three pillars:
- Structure: make content extractable (definition blocks, FAQ blocks, comparison tables, 40-60 word answer passages)
- Authority: add cited statistics, expert quotes, freshness signals, authoritative tone
- Presence: build citations on Wikipedia, Reddit, G2/Capterra, YouTube, industry publications - brands are 6.5x more likely to be cited via third-party sources than their own domain

**Phase 4 - Brand health dashboard:** KPI row (branded demand, category status, AI citation rate), share of search chart, volume trend chart with forecast, AI presence panel (citation status per platform, competitor citation rate vs brand citation rate).

### Brand tracking

Tracks branded demand and share of search over time relative to competitors. Uses `get_demand_volume` for all brands in a competitive set, calculates share of search, identifies momentum shifts, and alerts on significant changes via `create_trend_alert`.

### Demand forecasting

Runs ensemble forecasting across ARIMA, SARIMA, ETS (Holt-Winters), Prophet, XGBoost, and LSTM models. ETS (Holt-Winters) performs best for seasonal and accelerating signals. Leading indicator signals (pricing queries, comparison searches, login and outage queries) move 4-8 weeks ahead of market events. Use `forecast_demand_ensemble` for production forecasts.

### Marketing intelligence orchestration

Full-stack workflow covering: strategic brief, demand intelligence, AI visibility audit, brand tracking, content strategy, and competitive analysis - run in sequence with outputs from each phase feeding the next. Use when starting a new brand or market engagement from scratch.

---

## How skills call tools

Each skill follows a strict data-before-strategy rule: no strategic output (plan, recommendation, content strategy, competitive analysis) may be written before demand data is pulled. The sequence is always:

1. `knowledge_search` - load the relevant framework
2. `get_location_details` - resolve location ID (never hardcoded)
3. `search_signals` - find relevant demand signals
4. `get_demand_volume` - pull historical volume data
5. `forecast_demand_ensemble` - project forward 6 months
6. Strategic output grounded in the data above

---

## More information

- Homepage: https://mytelescope.ai
- Pricing: https://mytelescope.ai/pricing.md
- Help and documentation: https://help.mytelescope.io
- Data methodology: https://www.mytelescope.io/why/mytelescope-data-methodology