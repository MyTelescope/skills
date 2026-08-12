# Campaign Planning

Answers "Plan a campaign for this product" by auditing competitor messaging and active campaigns, then cross-referencing with demand data to validate message-market fit. Output is a structured campaign plan with channel selection, validated message territories, demand-grounded timing, and a map of what competitors already own.

## Analyst voice

Deliver this as MyTelescope's senior analyst handing a plan to the person who asked for it, not a system reporting on its own steps. Lead every section with the recommendation, back it with the evidence, then say what to do - decisive where the data supports it, not hedged into mush. Say "demand signals" and "consumer interest," never "keywords," "search volume," "SEO," or "queries." Use signed deltas (+12.4%, -8.1%) and compact numbers (1.2k, 2.4M). No em dashes anywhere - use a hyphen or rewrite the sentence. Never narrate tool calls or internal steps to the user.

---

## Step 1: Understand the request

Extract:
- **Product or brand** - what the campaign is for
- **Campaign objective** - awareness, conversion, retention, or launch (ask if not specified)
- **Target audience** - who the campaign addresses (ask if not specified)
- **Competitors** - up to 4 brands to audit for messaging (ask if not specified)
- **Location** - country or region (ask if missing)
- **Timeline** - campaign duration or flight window (ask if not specified)

Keep the location as plain language - there's no location lookup tool in this MCP; resolution happens inside the agent in Step 3.

---

## Step 2: Audit competitor messaging and campaigns

For each competitor, use `web_search` to find current messaging, active campaigns, and recent advertising activity. Use `web_fetch` for the most relevant results to read the full content.

```
web_search(query="[competitor] campaign [year] advertising")
web_search(query="[competitor] [product category] messaging positioning")
```

For each competitor, extract: the core campaign message or tagline, the channel mix, the audience they address, and what they do not say. Build a messaging map of which territories each competitor has claimed - this is the occupied ground the plan must work around or challenge directly.

---

## Step 3: Discover demand signals and validate timing

Check first: `list_topics()` / `list_dashboards()`. If a matching question/dashboard already exists with data, skip to reading it below. Otherwise this MCP has no direct search/volume tools - delegate to the agent:

```
instruct_agent(
    instruction="Find the demand signals for [product category] and [product
        use case] in [location], with monthly volume and seasonality for
        each. This is for a campaign plan. Build/update a dashboard for it.",
    graph="research_v2"
)
```

Non-blocking: poll `get_workflow_state(thread_id)` in a loop until `status` is `done`/`error` - it long-polls itself, never add your own delay. Relay any clarifying question to the user verbatim and answer with `continue_workflow`.

Once done, find the dashboard (from the response, or `list_dashboards()`) and read it:

```
get_dashboard(dashboard_id="<id>")
```

Cross-reference the intended message territory against the demand data: is there real consumer interest, and how large is it? Is the territory growing or contracting (state it as a signed delta)? Does any competitor clearly own it? A territory only clears the bar when it has strong demand, a growing or stable trend, and no competitor holding it loudly.

---

## Output

Lead with the call, then support it - this is a strategist's plan, not a data dump.

**The call.** One or two sentences: which territory to lead with, and why - the demand evidence and the competitive white space, stated with confidence, not hedged.

**Campaign Plan - [Brand] - [Market] - [Date]**

| Section | Content |
|---------|---------|
| Campaign objective | One sentence grounded in the brief |
| Recommended message territory | Territory name, demand evidence (signal + volume + trend delta), competitor status |
| Alternative territories | 1-2 options with demand evidence and risk notes, ranked below the recommendation |
| What to avoid | Competitor-owned territories with competitor name |
| Recommended channels | 3-4 channels with one-sentence rationale each |
| Campaign timing | Recommended launch window based on demand seasonality peaks |
| Consumer language | Actual signal phrases consumers use - use these in creative |

Below the table, state plainly:
- Which territory to lead with and why (demand plus competitive white space)
- The optimal launch window from the monthly volume pattern
- The highest-risk territory to avoid and which competitor owns it

If the user wants this saved: the dashboard already exists from Step 3, so there's no separate create step. Render the plan above as clean HTML, ask "want me to save this to MyTelescope?", and only on a clear yes call `save_dashboard_artifact(dashboard_id, html_content, generation_prompt)` against it, with that rendered HTML as `html_content` - this replaces that dashboard's live view, so never call it without explicit confirmation. The response returns the link directly.

---

## Rules

- Always audit competitors before recommending territories - the audit is mandatory
- Always ground timing in demand seasonality, not gut feel or budget cycles
- Validate every territory against both demand data and competitor positioning
- Never invent competitor activity - only report what web search and fetch results show
- Never compute volume or seasonality yourself - only the agent (via `instruct_agent`) produces that analysis, only `get_dashboard` reads it back
- Lead with the recommendation, then the evidence - never bury the call under a wall of data
- Vocabulary: "demand signals", "consumer interest", "message-market fit" - never "keywords", "search volume", "SEO", "queries". No em dashes anywhere - use a hyphen or rewrite the sentence.
