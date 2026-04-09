# MyTelescope Orchestrator MCP — Tools Reference

## Demand Research

### Search Demand Signals
- name: `search_signals`
- params: `keywords` (list), `location_id`, `language_id` (default "en"), `sources` (optional list), `limit` (default 20)
- Returns: matching demand signals with keyword_hash, relevance_score, signal_origin

### Get Demand Volume
- name: `get_demand_volume`
- params: `keyword_hashes` (list)
- Returns: monthly demand volume time-series grouped by signal origin

### Get Signal Suggestions
- name: `get_signal_suggestions`
- params: `keyword_locations_sets` (list of {locationId, languageId, keyword}), `data_source` (default "google"), `limit` (default 25), `date_from`, `date_to`, `suggestion_type` ("suggestions" | "questions" | "prepositions")
- Returns: fresh demand signals with volume data from external source

### Web Search
- name: `web_search`
- params: `query`
- Returns: real-time web search results

### Knowledge Search
- name: `knowledge_search`
- params: `query`, `top_k` (default 10)
- Returns: matching company/public documents with relevance scores

### Get Location Details
- name: `get_location_details`
- params: `location`
- Returns: locationId, languageId, locationName

### Get Language ID
- name: `get_language_id`
- params: `language`
- Returns: language_id, language_name

## Demand Analysis

### Calculate Demand Share
- name: `calculate_demand_share`
- params: `groups` (list of {name, keyword_hashes}), `date_from`, `date_to`
- Returns: demand distribution + demand momentum per group

### Calculate Demand Priorities
- name: `calculate_demand_priorities`
- params: `keyword_hashes` (list), `date_from`, `date_to`, `limit` (default 25)
- Returns: top demand signals sorted by total volume

### Calculate Emerging Demand
- name: `calculate_emerging_demand`
- params: `keyword_hashes` (list), `date_from`, `date_to`, `limit` (default 25)
- Returns: fastest-accelerating demand signals (velocity, not volume)

### Calculate Demand Trajectory
- name: `calculate_demand_trajectory`
- params: `keyword_hashes` (list), `date_from`, `date_to`, `months` (optional list)
- Returns: year-over-year demand comparison

### Forecast Demand
- name: `forecast_demand`
- params: `data` (list of {date, volume}), `future_steps` (default 3)
- Returns: forecasted demand volume data points

## Signal Collections

### Search Public Signal Collections
- name: `search_public_signal_collections`
- params: `query`, `limit` (default 10)
- Returns: pre-built public signal collections matching the query

### List User Signal Collections
- name: `list_user_signal_collections`
- No params
- Returns: all signal collections for the user's company (including private)

### Search User Signal Collections
- name: `search_user_signal_collections`
- params: `query` (default ""), `limit` (default 10)
- Returns: user's signal collections matching the query (semantic search)

### Create Signal Collection
- name: `create_signal_collection`
- params: `name`, `description`, `trackers` (list with name, category, description, locationId, languageId, searches, keywordsDataSources)
- Returns: signal_collection_id, link, signal_streams

## Keyword Management

### Get Signal Collection Data
- name: `get_signal_collection_data`
- params: `dashboard_id`
- Returns: tracker_ids, event_ids, date_range_ids, sync_status

### Get Signal Stream Searches
- name: `get_signal_stream_searches`
- params: `tracker_id`
- Returns: search_ids, name, category

### Get Search Keywords
- name: `get_search_keywords`
- params: `search_id`
- Returns: all available keywords with total_volume, is_new

### Get AI Selected Keywords
- name: `get_search_ai_selected_keywords`
- params: `search_id`
- Returns: AI-recommended keyword selection

### Update Search Configuration
- name: `update_search_configuration`
- params: `search_id`, `keywords` (list)
- Returns: success confirmation

## Signal Stream Clusters

### Create Signal Stream Cluster
- name: `create_signal_stream_cluster`
- params: `name`, `dashboard_ids` (list)
- Returns: cluster_id, name, dashboard_ids

### List Signal Stream Clusters
- name: `list_signal_stream_clusters`
- No params
- Returns: all clusters for the company

### Get Signal Stream Cluster
- name: `get_signal_stream_cluster`
- params: `cluster_id`
- Returns: cluster name, dashboards with trackers

### Update Signal Stream Cluster
- name: `update_signal_stream_cluster`
- params: `cluster_id`, `name` (optional), `dashboard_ids` (optional — replaces full list)
- Returns: updated cluster details

### Get Deployment Clusters
- name: `get_deployment_clusters`
- params: `deployment_id`
- Returns: clusters attached to the deployment

### Attach Signal Stream Cluster
- name: `attach_signal_stream_cluster`
- params: `deployment_id`, `collection_ids` (list)
- Returns: success confirmation

## Agent Deployment

### Get Suggested Region
- name: `get_suggested_region`
- params: `country`
- Returns: suggested GCP region + all available regions

### Create Deployment
- name: `create_deployment`
- params: `name`, `region` (optional), `country` (optional)
- Returns: deployment_id, name, status, service_url, region

### List Deployments
- name: `list_deployments`
- No params
- Returns: all deployments with IDs, names, statuses, URLs

### Get Deployment Status
- name: `get_deployment_status`
- params: `deployment_id`
- Returns: deployment status, service_url, error if any

### Get Deployment Manifest
- name: `get_deployment_manifest`
- params: `deployment_id`
- Returns: MCP server URL, Claude Desktop config

### Save Skill File
- name: `save_skill_file`
- params: `deployment_id`, `content`
- Returns: success confirmation

### Complete Provisioning
- name: `complete_provisioning`
- params: `deployment_id`
- Returns: success confirmation

## Documents

### List Company Documents
- name: `list_company_documents`
- No params
- Returns: all company-visible documents

### List User Documents
- name: `list_user_documents`
- No params
- Returns: user's personal documents

### Attach Documents
- name: `attach_documents`
- params: `deployment_id`, `document_ids` (list — replaces full list)
- Returns: success confirmation

### Remove Documents
- name: `remove_documents`
- params: `deployment_id`, `document_ids` (list)
- Returns: success confirmation

## Credits & Billing

### Get Credit Balance
- name: `get_credit_balance`
- No params
- Returns: total_credits, subscription_credits, purchased_credits, bonus_credits, plan_id, next_reset_date

### Get Credit Packages
- name: `get_credit_packages`
- No params
- Returns: credit_packs (with pricing) + subscription_plans

### Get Credit Usage
- name: `get_credit_usage`
- params: `days` (default 30)
- Returns: daily credit usage summary

### Purchase Credits
- name: `purchase_credits`
- params: `pack_id`
- Returns: Stripe payment URL

### Subscribe to Plan
- name: `subscribe_plan`
- params: `plan_id`
- Returns: Stripe subscription URL

## Platform

### Generate Platform Link
- name: `generate_platform_link`
- params: `path` (e.g. "/settings#billing", "/settings#knowledge", "/dashboard/abc123")
- Returns: authenticated one-time login URL (expires in 5 minutes)
