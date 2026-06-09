---
name: mytelescope-weekly-signals
description: >
  Use this skill whenever a user asks to see weekly signals, weekly trends,
  week-on-week data, or how something is trending on a weekly basis outside
  of a full dashboard creation flow. Trigger for: "show me weekly signals
  for X", "weekly trends on X", "how is X trending week on week", "weekly
  data on X", "track weekly demand for X". This skill fetches weekly data
  and ALWAYS renders it as an interactive HTML artifact (Weekly Index widget
  with Table/Lines toggle) — never as a markdown table or plain text.
  Creates a minimal signal collection when needed. Weekly auto-refresh is
  only activated when the user saves.
allowed-tools: Bash, Read, Grep, Glob
---

# MyTelescope Weekly Signals

Standalone weekly signals flow. Two entry points:

- **User has existing signal collection** → fetch weekly data directly
- **User has no signal collection** → create a minimal one, then fetch

This skill never runs a full demand analysis unless the user explicitly asks
for a full dashboard. It defers to `brand-rendering.skill.md` for the Weekly
Index Widget visual spec.

**Weekly auto-refresh is only activated when the user saves.**

---

## Hard rules — read before every step

**NEVER output a plain markdown table, bar chart, or any other chart type for weekly signals data.** The only acceptable output is the HTML Weekly Index Widget artifact per `brand-rendering.skill.md`. A markdown table, bar chart, or plain text summary is a failure mode — always build the HTML widget.

**`get_weekly_signals` always fetches 52 weeks internally.** Do not pass
`week_count` — it is not a parameter. 52 weeks is required for YoY to be
calculated and is hardcoded in the tool.

**ALWAYS end with the save offer** after rendering the widget:
> "Would you like to save this as a dashboard in MyTelescope?
> - **Weekly signals only** — saves just this widget, auto-refreshes every 7 days.
> - **Full dashboard** — includes demand trends, share analysis and this widget."

**ALWAYS read `brand-rendering.skill.md`** before building the widget HTML.

---

---

## Step 1: Check for existing signal collection

```
search_user_signal_collections(query="<topic from user>")
```

- **Found one** → confirm with user, get tracker IDs via
  `get_signal_collection_data(signal_collection_id)`, go to Step 3
- **Found multiple** → list them, ask user which one, then go to Step 3
- **None found** → go to Step 2

---

## Step 2: Create a minimal signal collection (only if none exists)

Do not run full demand analysis. The goal is to create just enough
trackers to enable weekly tracking.

**2a. Resolve location and find signals**

```
get_location_details(query="<location>")
search_signals(keywords=["<topic>"], location_id=..., language_id=...)
```

Pick the most relevant signals — aim for 3–5 per tracker. If
`search_signals` returns nothing useful, ask the user to confirm
the keywords directly.

**2b. Confirm with the user before creating**

Show the proposed tracker structure:
> "I'll create a minimal signal collection for [X] in [location] with
> these keywords: [list]. This is the foundation needed for weekly
> tracking. Want me to proceed?"

Wait for confirmation.

**2c. Create the collection**

**STOP after getting tracker IDs. Do NOT call save_dashboard_artifact. Do NOT
build an HTML dashboard. Do NOT call get_demand_volume. The create_signal_collection
tool will return a next_required_action suggesting save_dashboard_artifact — ignore
it in this flow. Proceed directly to Step 3 with the tracker IDs.**

```
create_signal_collection(
    name="[Topic] — Weekly Signals",
    description="Weekly Google Trends tracking for [topic] in [location]",
    with_weekly_tracking=False,
    trackers=[
        {
            "name": "[tracker name]",
            "category": "[brand | topic | destination | person | product]",
            "locationId": "<from get_location_details>",
            "languageId": "<from get_location_details>",
            "keywordsDataSources": ["google"],
            "searches": [
                {
                    "subject": "[topic]",
                    "keywords": ["<keyword 1>", "<keyword 2>", ...]
                }
            ]
        }
    ]
)
```

Get tracker IDs from the response, then go to Step 3.

---

## Step 3: Check for existing weekly data

```
get_weekly_signals(tracker_ids)
```

52 weeks of history is fetched automatically. YoY change requires at least
26 weeks of stored data — it will be null for new trackers until ~6 months
of history accumulates. This is expected behavior, not an error.

| `fetch_status` | `keywords` | Action |
|---|---|---|
| `"complete"` | non-empty | Go to Step 5 — render immediately |
| `"complete"` | empty | Data fetched but no scores — go to Step 4 |
| `"fetching"` | any | Go to Step 4b — already in progress |
| `"error"` | any | Offer to retry — go to Step 4 |
| `null` / `weekly_tracking_enabled: false` | empty | Go to Step 4 |

---

## Step 4: Fetch weekly preview data (subscription required)

```
fetch_weekly_preview(tracker_ids)
```

If subscription not active → `WEEKLY_SIGNALS_REQUIRES_SUBSCRIPTION`:
> "Weekly Signals requires an active subscription. Would you like
> to upgrade? I can pull the pricing options for you."
- User upgrades → retry `fetch_weekly_preview`
- User declines → end

Returns immediately with `status: "fetching"`.

**4b. After fetch_weekly_preview — wait for user**

DO NOT call `get_weekly_signals` immediately after `fetch_weekly_preview`.
Tell the user:

> "Weekly signals are now being fetched. Processing time varies — smaller collections are usually ready in a few minutes, while larger or existing dashboards with more trackers may take a bit longer. In a few minutes, ask me for your weekly signals and I'll render them if ready or update you on the status."

Then stop. Only call `get_weekly_signals` when the user explicitly
asks again. When they do:

- `fetch_status: "complete"` + keywords non-empty → go to Step 5
- Still fetching → "Still processing, check back in a few minutes."
- `"error"` → "The fetch failed. Want me to retry?"

---

## Step 5: Render the Weekly Index widget

**This step is mandatory whenever `fetch_status` is `"complete"` and keywords are non-empty. There is no acceptable alternative output — not a bar chart, not a markdown table, not plain text, not a summary paragraph. The only output is the HTML artifact described below.**

**Generate a standalone interactive HTML artifact** — not a markdown table,
not plain text, not a chat response. Use Chart.js. Follow the Weekly Index
Widget spec in `brand-rendering.skill.md` exactly.

The artifact must have:

**Table view (default):**
- One row per tracker — not per keyword
- Use `tracker_name` as the row label
- Use `topic_score` as the score (average of all keyword scores, nulls excluded — pre-computed by the tool)
- Use the keyword with the highest `latest_score` that also has at least one non-null value in `last_4_weeks` as the representative signal for WoW and YoY. If no keyword has any non-null `last_4_weeks`, fall back to highest `latest_score` regardless.
- Columns: Signal | Score | WoW Δ | YoY | Trend
- WoW Δ: colored pill (green ↑ if positive, red ↓ if negative)
- YoY: pill "↑ Growing YoY" (green) or "↓ Declining YoY" (red) or "→ Stable"
  - YoY compares this week's score against the score from ~52 weeks ago
  - Source: Google Trends relative interest score (0-100), compared week-on-week over 52 weeks
  - Only shown when 26+ weeks of history exist — shows "—" for newer trackers
- Mini SVG sparkline from `last_4_weeks` of the top keyword at far right of each row
- Trackers with `topic_score: null` or empty keywords array show as "no data this cycle" at the bottom. A non-null `topic_score` always gets a full row even if its sparkline is sparse.

**Lines view (on toggle):**
- Chart.js line chart, Y-axis 0–100
- One dataset per tracker using the top keyword's `last_4_weeks`
- X-axis always has 4 labels: ["4w ago", "3w ago", "2w ago", "Last week"]. For each tracker dataset, left-pad `last_4_weeks` with nulls until it has exactly 4 elements — e.g. `[61, 59]` becomes `[null, null, 61, 59]`. This right-aligns all trackers on the shared x-axis so "Last week" is always the rightmost point.
- Dotted line segments for null values

**Toggle button:** "Table | Lines" — switches between the two views.
Card size stays the same on toggle.

Show `last_updated` date at the bottom.

This is a **preview artifact only** — do NOT call `save_dashboard_artifact`.

**After rendering the widget:** if any tracker shows "—" in the YoY column (i.e. `yoy_change_pct` is null), add this line in chat:
> "Year-on-year comparison is not available for these signals — there isn't enough historical data in Google Trends for this market yet. It will appear automatically as more weekly data becomes available."

After rendering, offer:
> "Want to save this as a dashboard in MyTelescope?
> - **Weekly signals only** — saves just this widget, auto-refreshes
>   every 7 days.
> - **Full dashboard** — includes demand trends, share analysis and
>   this widget. I'll run a full demand analysis first."

---

## Step 6: Save (only if user confirms)

### Option A — Weekly signals widget only

1. Activate weekly tracking:
```
enable_weekly_tracking(tracker_ids)
```

2. Generate HTML containing only the Weekly Index widget
   (follow spec in `brand-rendering.skill.md`)

3. Save and return link:
```
save_dashboard_artifact(
    dashboard_id="<signal_collection_id>",
    html_content="<weekly index widget HTML>",
    generation_prompt="Weekly signals for <topic>"
)
generate_platform_link(path="/dashboard/<signal_collection_id>")
```

> "Your Weekly Signals dashboard is live and auto-refreshes every
> 7 days. [Open on MyTelescope](<link>)"

### Option B — Full dashboard

> "I'll run a full demand analysis and include the weekly signals widget."

Run demand analysis (Steps 1–7 from `mytelescope-core.skill.md`),
generate complete HTML artifact (demand chart + share chart + weekly
widget), save and return link.

---

## Hard rules

**Never call `enable_weekly_tracking` before the user saves.**
Showing the widget and activating the weekly schedule are separate.

**Never modify existing dashboards.** Always create a new signal
collection when one is needed.

**Never call `fetch_weekly_preview` if `fetch_status` is already
`"complete"` and keywords are non-empty.** Read existing data instead.

**Never skip the subscription check** — `fetch_weekly_preview` requires
an active subscription.

**Never run full demand analysis** (forecasting, demand share,
demand priorities) unless the user explicitly asks for a full dashboard.
