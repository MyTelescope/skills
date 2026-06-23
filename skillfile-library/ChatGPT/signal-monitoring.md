# Signal Monitoring

Sets up a demand alert that notifies the user when a specified signal crosses a threshold or changes by a meaningful amount. There is no dashboard or visual artifact in this flow — output is a clean confirmation of what alert was created, for which signal, and what will trigger it.

---

## Step 1: Understand the alert request

Extract:
- **Signal** - the exact demand signal to monitor
- **Condition** - what should trigger the alert (rises above X, drops below X, changes by more than X% week-on-week)
- **Location** - country or region (ask if missing)

If the signal is vague, ask: "Which signal exactly should I monitor? For example: a specific brand name, product, or topic term."

If the condition is missing or vague, suggest sensible defaults and confirm: "Should I alert you on any significant movement, or do you have a specific threshold in mind — for example, a 20% drop week-on-week?"

Call `get_location_details` to resolve the location ID.

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

## Output

Confirm the alert clearly and concisely. No dashboard. No chart. No further analysis.

**Alert set.**

| Field | Value |
|-------|-------|
| Monitoring | [signal name] |
| Market | [location] |
| Triggers when | [condition] |
| Notification | [how the user will be notified, if tool returns this detail] |

---

## Rules

- No dashboard — this is the only workflow with no visual artifact; do not build a chart or HTML artifact
- Always confirm the signal and condition before creating the alert — a vague alert is worse than no alert
- Keep the confirmation concise — the user asked for a monitoring alert, not an analysis
- Never skip clarification if the condition is ambiguous — "alert me when this changes" is not enough
- Vocabulary: "demand signals", "consumer interest", "monitoring" - never "keywords", "search volume", "SEO"