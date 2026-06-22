---
name: mytelescope-signal-monitoring
description: >
  Use this skill when the user wants to be alerted when a demand signal moves
  or crosses a threshold. Trigger for: "Alert me when this changes", "Monitor
  this signal", "Notify me if [signal] moves", "Set up an alert for [topic]",
  "Tell me when demand for [topic] drops below X", "Warn me if [competitor]
  spikes", or any request to track a signal and receive a notification when
  something changes. This skill sets up an alert only — it does not create a
  dashboard.
---

# Signal Monitoring

## What this skill does

Sets up a demand alert that will notify the user when a specified signal
crosses a threshold or changes by a meaningful amount. There is no dashboard
and no visual artifact in this flow. The output is a clear confirmation of
what alert was created, for which signal, and what will trigger it.

The one tool that drives this skill:
- `create_trend_alert` - creates a monitoring alert for a demand signal

---

## Step 1: Understand the alert request

Extract from the user's message:
- **Signal** - the exact demand signal to monitor
- **Condition** - what should trigger the alert (e.g. rises above X, drops
  below X, changes by more than X% week-on-week)
- **Location** - country or region (ask if missing)

If the signal is vague, ask for clarification:
> "Which signal exactly should I monitor? For example: a specific brand name,
> product, or topic term."

If the condition is missing or vague, suggest sensible defaults and confirm:
> "Should I alert you on any significant movement, or do you have a specific
> threshold in mind - for example, a 20% drop week-on-week?"

If location is missing, ask:
> "Which market should I monitor this in? For example: United States, Germany,
> United Kingdom."

Get clear answers before proceeding. A poorly specified alert is not useful.

---

## Step 2: Create the alert

Call `create_trend_alert` with the confirmed signal, condition, and location.

```
create_trend_alert(
    keyword="<signal>",
    location_id="<id>",
    condition="<threshold or condition>",
    ...
)
```

Pass all parameters required by the tool based on the user's confirmed inputs.

---

## Step 3: Confirm the alert

Once the alert is created, confirm it clearly and concisely. No dashboard.
No artifact. Just a clean confirmation that tells the user exactly what was
set up.

Respond with:
- The signal that is now being monitored
- The location
- The condition that will trigger a notification
- A brief note on how they will be notified (if the tool returns that detail)

Example confirmation format:

> **Alert set.**
>
> Monitoring: [signal name]
> Market: [location]
> Triggers when: [condition]
>
> You will receive a notification when this threshold is crossed.

Keep it short. Do not add charts, analysis, or suggestions for further action
unless the user asks.

---

## Hard rules

**No dashboard.** This is the only skill with no visual artifact. Do not build
a chart or HTML artifact. Do not offer to save a dashboard. Do not call
`create_signal_collection`, `save_dashboard_artifact`, or
`generate_platform_link`.

**Always confirm the signal and condition before creating the alert.** An alert
for a vague or misunderstood signal is worse than no alert. If anything is
unclear, ask.

**Keep the confirmation concise.** The user asked for a monitoring alert, not
an analysis. A clean confirmation is the right output.

**Never skip clarification if the condition is ambiguous.** "Alert me when
this changes" is not enough to create a useful alert. Get the threshold or
condition confirmed first.

**Vocabulary.** "Demand signals", "consumer interest", "monitoring" —
never "keywords", "search volume", "SEO", "queries".

---

## Tool reference

| Tool | Step | Purpose |
|------|------|---------|
| `get_location_details` | 1 | Resolve location name to ID |
| `create_trend_alert` | 2 | Create the monitoring alert for the signal |