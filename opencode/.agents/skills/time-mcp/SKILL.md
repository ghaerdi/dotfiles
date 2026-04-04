---
name: time-mcp
description: Time MCP reference for timezone conversion and time queries. Use when converting between timezones, scheduling across regions, or coordinating global team timing.
---

Use the Time MCP tools when working with timezones, scheduling, or international coordination.

## When to Use

- Converting times between timezones
- Coordinating meetings across regions
- Scheduling tasks for different time zones
- Displaying time in user's local timezone

## Available Tools

| Tool | Purpose |
|------|---------|
| `time_get_current_time` | Get current time in a specific timezone |
| `time_convert_time` | Convert a time from one timezone to another |

## Common Patterns

### Get Current Time in User's Timezone
```
time_get_current_time({ timezone: "America/New_York" })
```

### Convert Meeting Time
```
time_convert_time({
  source_timezone: "America/New_York",
  time: "14:00",
  target_timezone: "Asia/Tokyo"
})
```

### Coordinate Global Team
```
// When user mentions a meeting, show times for all relevant zones
time_convert_time({ source_timezone: "UTC", time: "09:00", target_timezone: "America/Los_Angeles" })
time_convert_time({ source_timezone: "UTC", time: "09:00", target_timezone: "Europe/London" })
time_convert_time({ source_timezone: "UTC", time: "09:00", target_timezone: "Asia/Tokyo" })
```

## IANA Timezone Names

Always use IANA timezone format:
- `UTC` - Coordinated Universal Time
- `America/New_York` - US Eastern
- `America/Los_Angeles` - US Pacific
- `Europe/London` - UK
- `Asia/Tokyo` - Japan
- `Asia/Shanghai` - China
- `Australia/Sydney` - Australia Eastern

## Important Guidelines

1. **Always specify timezone** - never assume user's timezone
2. **Use IANA names** - not abbreviations like "EST" or "PST"
3. **Consider daylight saving** - IANA handles this automatically
4. **Show multiple zones** for international coordination