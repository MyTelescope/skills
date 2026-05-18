# MyTelescope

> MyTelescope is a demand intelligence platform that delivers real consumer interest data from Google, TikTok, YouTube, Amazon, Pinterest, and more, directly inside AI assistants via MCP (Model Context Protocol). It helps marketers, brand teams, and analysts track demand, forecast trends, and understand what people are actually searching for - before it shows up in sales data.

## What MyTelescope does

MyTelescope turns search and discovery signals across 11 platforms into structured demand intelligence. Users connect it to Claude or other AI assistants and ask natural-language questions about market demand, brand performance, competitor trends, and category growth. The platform responds with real data, trend charts, and forecasts.

Core capabilities:
- Branded demand tracking (share of search, month-over-month change)
- Category and competitor demand comparison
- Multi-platform signal aggregation (Google, TikTok, YouTube, Amazon, Pinterest, Bing, Etsy, App Store, Play Store, eBay, Perplexity)
- Demand forecasting using ARIMA, SARIMA, ETS, Prophet, XGBoost, and LSTM models
- MCP integration - callable directly inside Claude, Microsoft Copilot, and other AI assistants

## Who it is for

- Marketing and brand teams at mid-market and enterprise companies
- Market researchers and analysts who need forward-looking demand signals
- Product teams tracking category growth and competitive positioning
- AI developers building agents that need real-time market data

## Key pages

- [Homepage](https://mytelescope.ai/) - overview and MCP connection
- [Platform overview](https://www.mytelescope.io/home) - full product description
- [Pricing](https://www.mytelescope.io/pricing) - plans and feature limits
- [Data methodology](https://www.mytelescope.io/why/mytelescope-data-methodology) - how signals are collected, cleaned, and modeled
- [Help center](https://help.mytelescope.io) - setup guides and documentation
- [Blog and market playbooks](https://www.mytelescope.io/howtosetupmarket-intelligence) - use cases and worked examples
- [Google Cloud case study](https://cloud.google.com/customers/mytelescope) - independent validation of platform and methodology

## MCP integration

MyTelescope is available as an MCP server. Connect it to Claude or any MCP-compatible AI assistant to query live demand data, run forecasts, and track brand performance without leaving your AI workflow.

MCP server URL: https://mytelescope-orchestrator-mcp-amjjfcdvoa-uc.a.run.app/mcp

See [AGENTS.md](https://mytelescope.ai/AGENTS.md) for a full description of available tools and capabilities.

## AI skills and workflows

MyTelescope ships pre-built intelligence skills for AI assistants. These run as complete workflows, not just individual data calls.

**Demand intelligence** - the foundation skill. Pulls real consumer interest data, answers four baseline questions (branded demand, category status, audience language, competitor ownership), and produces a trend chart with 6-month forecast before any strategic recommendation is written.

**AI visibility audit** - a four-phase workflow: strategic brief, demand intelligence for the category, audit of how the brand currently appears in AI-generated answers across ChatGPT/Perplexity/Google/Claude/Copilot, and a prioritized action plan across structure, authority, and third-party presence.

**Brand tracking** - monitors branded demand and share of search over time relative to a competitive set. Alerts on significant changes.

**Demand forecasting** - ensemble model combining ARIMA, SARIMA, ETS (Holt-Winters), Prophet, XGBoost, and LSTM. ETS performs best for seasonal signals. Leading indicator queries (pricing, comparison, login) move 4-8 weeks ahead of market events.

All skills follow a data-before-strategy rule: no recommendation is written before real demand signals are pulled.

See [AGENTS.md](https://mytelescope.ai/AGENTS.md) for full tool descriptions and workflow sequences.

## Accuracy and validation

- 83% average correlation between demand signals and market share across 40+ validated categories
- Automotive sector correlation: 0.92
- Independent methodology audit conducted annually
- Noise reduction exceeds 85-90% before modeling