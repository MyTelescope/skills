---
name: mytelescope-dashboard-creation
description: >
  Use this skill whenever a user asks to create, build, set up, or save a
  dashboard, signal collection, or tracker in MyTelescope. Trigger for: "create
  a dashboard", "build a dashboard", "save as a dashboard", "set up a tracker",
  "create a signal collection", "track these signals", "monitor this market",
  "save this to MyTelescope", "make a dashboard for", "I want to track", or any
  request that ends with persisting demand research into the MyTelescope
  platform. Also trigger when the user confirms after a demand intelligence
  session — "yes, save it", "go ahead and create it", "save this". This skill
  enforces a mandatory visualize-first flow: the user must see and approve an
  interactive draft dashboard BEFORE anything is created in the platform.
  Never skip the visualization step. Never call create_signal_collection
  without explicit user confirmation of the draft.
allowed-tools: Bash, Read, Grep, Glob
---

# MyTelescope Dashboard Creation

## The Non-Negotiable Rule

**Never create a dashboard without showing a visual draft first.**

The sequence is always:

1. Research and propose the signal structure
2. Build and show an interactive draft dashboard artifact
3. Ask for user confirmation
4. Only then create in MyTelescope

Calling `create_signal_collection` before the user has seen and confirmed a
visual draft is a violation of this skill. No exceptions.

---

## Brand & Visual Rules

This skill defers to **`brand-rendering.skill.md`** for ALL visual and vocabulary
rules - typography, color palettes, KPI card layout, chart specs, and data
formatting. Load that skill in parallel whenever this one produces visual
output, charts, or any text containing numbers, percentages, or dates.

Minimum required behaviour (full spec is in brand-rendering):

- Fonts: Instrument Serif for headings and numbers; Inter 300/400/500 for body. Never bold (600+).
- Colors: `#00CCFF` positive, `#FF6B6B` negative, `#323F5F` neutral.
- Cards: 6px radius, 0.5px `#D6D8DF` border, no shadows, no gradients.
- Text: always `var(--color-text-primary)` - never hard-code dark text.
- Status enum: Growing / Contracting / Flat only.
- Trend enum: Accelerating / Decelerating / Stable + pp delta.
- Vocabulary: "demand signals", "consumer interest", "demand" - never "search volume", "keywords", "SEO", "indexed data".
- Volumes: `1.2k` not `1200`; always include sign: `+12.4%` not `12.4%`.

---

## When This Skill Starts

There are two entry points depending on whether demand data already exists.

**Entry A - Data already pulled in this conversation:**
The user has just seen a demand analysis (trend charts, volumes, signal data) and
now wants to save it. Skip straight to Step 2 (Propose Structure). Do not
re-pull data you already have.

**Entry B - New request with no prior data:**
The user says "create a dashboard for [topic]" without prior demand research.
Start at Step 1 (Pull Demand Data). Follow the `mytelescope-core` workflow for
Steps 1-8 (location, web search, search_signals, get_demand_volume, other
sources, forecast). Only after data is in hand, continue to Step 2 here.

---

## Step 1: Pull Demand Data (Entry B only)

Follow the demand intelligence workflow from `mytelescope-core`:

1. Identify topic, location, language from the user's request
2. `get_location_details` - resolve location ID and available sources
3. `web_search` - discover seed terms and real user queries
4. `search_signals` - find matching demand signals
5. `get_demand_volume` - pull monthly volume time-series
6. Handle missing data with keyword-mode fallback if needed
7. Offer deep analysis across other sources (mandatory - see mytelescope-core Step 7)
8. `forecast_demand` - add 6-month forecast

Do not proceed to Step 2 until you have volume data for the signals you intend
to track.

---

## Step 2: Propose the Signal Structure

Before building anything, show the user the proposed tracker and keyword
breakdown in plain text. This is the last checkpoint before the visual draft.

Format the proposal as:

---
**Proposed dashboard: [Dashboard Name]**

**Tracker 1 - [Name]** ([category: brand / topic / category])
Signals to track: [keyword 1] (Xk/mo), [keyword 2] (Xk/mo), [keyword 3] (Xk/mo)

**Tracker 2 - [Name]** ([category])
Signals to track: [keyword 1] (Xk/mo), [keyword 2] (Xk/mo)

[... etc]

Location: [Country], Language: [Language]
---

Then ask:
> "Does this structure look right? I'll build a preview dashboard from this
> data - let me know if you want to add, remove, or rename anything before
> I show you the draft."

Wait for the user to confirm, adjust, or say "looks good" / "go ahead" before
proceeding to Step 3. Do not skip this checkpoint.

---

## Step 3: Build the Draft Dashboard Artifact

**This step is mandatory. Do not call `create_signal_collection` before
completing this step and receiving explicit user confirmation.**

Build an interactive HTML artifact that looks like a real analytics dashboard.
Use Chart.js for all charts. The artifact is not a summary - it is a visual
preview that the user can actually read and react to before committing.

### Required elements

**1. Dashboard header**
- Dashboard name in Instrument Serif 24px
- Subtitle: location + language + date range in Inter 11px `var(--color-text-secondary)`
- Last data point date if more than 6 weeks old

**2. Metric cards row (one per tracker)**
Each card must show:
- Tracker name
- Status pill: Growing / Contracting / Flat (color-coded per brand-rendering spec)
- Latest monthly volume (formatted: `1.2k`, `2.4M`)
- Annual change % with sign (`+12.4%`)
- Demand share % if multiple trackers exist

**3. Trend line chart (mandatory)**
- Line chart showing monthly demand volume over time for all trackers
- Every data point from `get_demand_volume` plotted - no sampling, no truncation
- Forecast as a dashed line extending 6 months beyond the last data point
- Custom HTML legend below the chart (not Chart.js default)
- Axis labels: "Jan 25", "Jul 25" format; `autoSkip: true`, `maxTicksLimit: 12`
- Chart.js spec from brand-rendering: no x-gridlines, y-gridlines at 8% opacity

**4. Demand share (if 2 or more trackers)**
- Pie or donut chart showing each tracker's share of total demand
- Colors from the 20-color palette in order
- Custom HTML legend

**5. Top signals table (per tracker)**
- Tabs or accordion: one section per tracker, switchable
- Table columns: Signal | Monthly volume | Change vs last year
- Sort by volume descending
- Max 10 rows per tracker

**6. Forecast section**
- Brief sentence: "Forecast: [tracker name] projected to reach ~Xk/mo by [Month YYYY]"
- Dashed forecast line already on the trend chart counts as the visualization

### Visual spec for the artifact

Follow brand-rendering exactly:

```
Background: var(--color-background-primary) or #F5F5F5 fallback
Cards: border-radius 6px, border 0.5px solid #D6D8DF, padding 1rem 1.1rem
No shadows, no gradients on card surfaces
Gap between cards: 10px
Primary text: var(--color-text-primary)
Secondary text: var(--color-text-secondary)
Positive values: #00CCFF
Negative values: #FF6B6B
Neutral / flat: #323F5F
Font headings/numbers: Instrument Serif
Font body/labels: Inter 300/400/500
Never bold (600+)
```

---

## Step 4: Present the Draft and Ask for Confirmation

After building the artifact, show it and then say - word for word:

> "This is a draft preview of your dashboard. When saved to MyTelescope, the
> live dashboard will track these signals with automatically updating data.
> The platform layout uses standard widgets (demand share, demand priorities,
> emerging demand, demand trajectory) - it won't look exactly like this
> preview. Would you like me to save this dashboard to MyTelescope?"

Do not offer download options, HTML exports, or any alternative format.
The only two valid responses to offer are:

- **Yes / confirm** - proceed to Step 5
- **Change something** - update the structure or draft and show the revised
  artifact again before asking for confirmation again

If the user asks to change the name, trackers, keywords, or any other detail,
make the change, rebuild the affected parts of the artifact, and ask for
confirmation again. Do not create in the platform with unconfirmed changes.

---

## Step 5: Create the Signal Collection

Only execute this step after the user has explicitly confirmed the draft.

Call `create_signal_collection` with the exact structure confirmed in Step 2.
Include keywords from the demand research so the dashboard shows data
immediately - a collection without keywords will appear empty.

```
create_signal_collection(
    name="[Dashboard Name]",
    description="[Brief description of what is being tracked]",
    trackers=[
        {
            "name": "[Tracker Name]",
            "category": "[brand | topic | category]",
            "description": "[What this tracker monitors]",
            "locationId": "<id from get_location_details>",
            "languageId": "<language code>",
            "keywordsDataSources": ["google"],
            "searches": [
                {
                    "subject": "[Primary search subject]",
                    "description": "[What this search monitors]",
                    "keywords": ["[keyword 1]", "[keyword 2]", "[keyword 3]"]
                }
            ]
        }
    ]
)
```

**Why keywords must be included:** Pre-populated keywords mean the dashboard
shows live data immediately. An empty collection shows nothing and the user
has to configure it manually from scratch.

---

## Step 6: Save the Dashboard Artifact

After `create_signal_collection` returns successfully, save the HTML artifact
you built in Step 3 to the deployment record.

```
save_dashboard_artifact(
    signal_collection_id="<id from create_signal_collection>",
    artifact_html="<the full HTML string from Step 3>"
)
```

This attaches the draft visualization to the signal collection so it can be
regenerated or referenced later. If `save_dashboard_artifact` fails, continue
without it - it is a bonus persistence step, not a blocker.

---

## Step 7: Generate the Platform Link and Show It

Immediately after saving, generate an authenticated link to the live dashboard.

```
generate_platform_link(path="/dashboard/<signal_collection_id>")
```

Show the link to the user right away. Never make them ask where the dashboard is.

Format:
> "Your dashboard is live. [Open on MyTelescope]([link])"

If you cannot determine the path from the `create_signal_collection` response,
call `generate_platform_link(path="/dashboards")` to send them to their
dashboard list instead.

---

## Step 8: Offer Next Steps

After the dashboard is created, offer 2-3 relevant next actions. Pick from
this list based on what is most relevant to what was just built:

- **Trend alerts** - "This signal is [Growing / Contracting]. Want me to set
  up an alert so you're notified if it changes significantly?"
- **Attach to an agent** - "Want me to add this dashboard to one of your
  agents so it can query this data automatically?"
- **Deeper competitive analysis** - "Want me to run a demand share or
  emerging demand analysis on these trackers?"
- **Forecast** - if not already run, "Want me to model where these signals
  are heading over the next 6 months?"
- **Other sources** - if not already offered in Step 1, "I pulled Google
  data. We also have [list sources]. Want me to add those sources to a deeper
  analysis?"

Do not list all of these - pick the 2-3 that are genuinely relevant.

---

## Hard Rules

**Never skip the draft.** Calling `create_signal_collection` without first
showing an HTML artifact and receiving explicit confirmation is a violation.
No amount of user urgency ("just create it", "skip the preview") overrides
this. If a user says "just create it", explain in one sentence that you need
30 seconds to build a preview so they can verify the structure, then build
it anyway.

**Never create with unconfirmed changes.** If the user asks to modify the
tracker structure after seeing the draft, rebuild and re-confirm before
creating.

**Always include keywords.** A signal collection without keywords is incomplete.
Use every relevant keyword from the demand research, grouped into searches by
theme or intent.

**Always show the platform link immediately.** The link is in the
`create_signal_collection` response. Show it the moment the collection is
saved. Never wait for the user to ask.

**Never mention backend details.** Do not reference vector search, keyword
hashes, signal IDs, database, API calls, or indexing in any user-facing
message. The user sees a dashboard being created - not a data pipeline.

**Vocabulary.** "Demand signals", "consumer interest", "demand". Never
"search volume", "keywords", "SEO", "indexed data", "no data found".

---

## Tool Reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID and available sources |
| `web_search` | 1 | Discover seed terms and real user queries |
| `search_signals` | 1 | Find matching demand signals in the database |
| `get_demand_volume` | 1 | Pull monthly volume time-series for signals |
| `forecast_demand` | 1 | 6-month demand forecast for the trend chart |
| `create_signal_collection` | 5 | Create the dashboard - only after user confirms draft |
| `save_dashboard_artifact` | 6 | Attach the HTML artifact to the signal collection |
| `generate_platform_link` | 7 | Generate authenticated link to the live dashboard |
| `create_trend_alert` | 8 | Set up email alerts for demand changes |
| `list_signal_stream_clusters` | 8 | List clusters for attaching to an agent |
| `attach_signal_stream_cluster` | 8 | Attach dashboard to an agent deployment |
| `get_credit_balance` | any | Check credits if a tool is blocked |
| `get_credit_packages` | any | Show credit packs and subscription plans |