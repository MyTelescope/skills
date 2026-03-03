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
