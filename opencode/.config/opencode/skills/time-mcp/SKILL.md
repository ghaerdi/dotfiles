---
name: time-mcp
description: Time MCP reference for timezone conversion and time queries. Use when converting between timezones, scheduling across regions, or coordinating global team timing.
---

# Time MCP Reference

## When to Use This Skill

Activate this skill when you need:
- Quick reference for Time MCP tools
- Timezone conversion patterns
- Scheduling across timezones
- Understanding Time MCP capabilities
- Manual lookup instead of invoking the time agent

## Time MCP Tools

| Tool | Purpose | Parameters |
|------|---------|-------------|
| `get_current_time` | Get current time in timezone | `timezone` (IANA format) |
| `convert_time` | Convert time between zones | `source_timezone`, `time` (HH:MM), `target_timezone` |

## Timezone Formats

| Format | Example | Notes |
|--------|---------|-------|
| IANA | `America/New_York` | Standard format, use these |
| IANA | `Europe/London` | Supports 600+ zones |
| IANA | `Asia/Tokyo` | Asia/Pyongyang, Asia/Hong_Kong |
| IANA | `America/Santiago` | User's local timezone |

## Common Workflows

### Workflow A: Get Current Time in Any Timezone

```markdown
# Get current time
time_get_current_time(timezone="America/New_York")

# Get current time in user's local timezone (Santiago)
time_get_current_time(timezone="America/Santiago")

# Get current time in multiple zones
time_get_current_time(timezone="Europe/London")
time_get_current_time(timezone="Asia/Tokyo")
```

### Workflow B: Convert Meeting Time Across Zones

```markdown
# User in New York wants to schedule with London team
# 3pm New York = 8pm London
time_convert_time(source_timezone="America/New_York", time="15:00", target_timezone="Europe/London")

# Result: 20:00 (8pm) in London
```

### Workflow C: Convert Unix/Timestamp to Human Readable

```markdown
# Convert UTC to specific timezone
time_convert_time(source_timezone="UTC", time="14:30", target_timezone="America/Los_Angeles")

# Convert Tokyo time to Santiago
time_convert_time(source_timezone="Asia/Tokyo", time="09:00", target_timezone="America/Santiago")
```

### Workflow D: Handle 24-Hour Format

```markdown
# 24-hour format examples
# 14:30 = 2:30 PM
# 09:00 = 9:00 AM
# 23:59 = 11:59 PM

time_convert_time(source_timezone="America/New_York", time="23:59", target_timezone="Europe/Paris")
```

## Timezone Quick Reference

| City/Region | IANA Timezone | UTC Offset |
|------------|---------------|------------|
| New York | `America/New_York` | UTC-5 / UTC-4 (DST) |
| Los Angeles | `America/Los_Angeles` | UTC-8 / UTC-7 (DST) |
| London | `Europe/London` | UTC+0 / UTC+1 (DST) |
| Paris | `Europe/Paris` | UTC+1 / UTC+2 (DST) |
| Tokyo | `Asia/Tokyo` | UTC+9 |
| Santiago | `America/Santiago` | UTC-4 / UTC-3 (DST) |
| Sydney | `Australia/Sydney` | UTC+10 / UTC+11 (DST) |

## Common Use Cases

| Use Case | Example |
|----------|---------|
| **Team standup scheduling** | "9am Tokyo = 4pm previous day LA" |
| **CI/CD deployment windows** | "Deploy at 6pm EST when Europe starts workday" |
| **Log analysis** | "This 14:30 UTC timestamp is 9:30am LA time" |
| **API rate limits** | "Rate limit resets at midnight UTC" |
| **Meeting coordination** | "Weekly sync: 10am NYC = 3pm London = 11pm Tokyo" |

## Agent vs. Skill

| Use Case | Use Agent | Use Skill |
|----------|-----------|-----------|
| Autonomous timezone coordination | ✅ `task(subagent_type="time")` | |
| Quick reference lookup | | ✅ `skill(name="time-mcp")` |
| Scheduled task timing | Agent handles automatically | Reference patterns here |
| Manual conversion | | ✅ Reference tool syntax |

## Error Handling

| Error | Meaning | Solution |
|-------|---------|----------|
| `Invalid timezone` | Not valid IANA format | Use format like `America/New_York` not `EST` |
| `Time out of range` | HH:MM must be 00:00-23:59 | Use 24-hour format |
| `Ambiguous timezone` | DST overlap (e.g., 1:30am occurs twice) | Specify date or use UTC |

## Best Practices

1. **Always use IANA format** - `America/New_York` not `EST` or `GMT-5`
2. **Specify timezone explicitly** - Don't assume user's local timezone
3. **Use 24-hour format** - `14:30` not `2:30 PM`
4. **Consider DST** - Many zones shift twice yearly
5. **Quote time in response** - "3pm New York time (20:00 UTC)"

## Example: Complete Time Coordination Flow

```markdown
# 1. Get current time in multiple zones
time_get_current_time(timezone="America/Santiago")  # User's timezone

time_get_current_time(timezone="America/New_York")  # US East coast

time_get_current_time(timezone="Europe/London")  # EU team

# 2. Convert a proposed meeting time
# User suggests 4pm their time (Santiago)
time_convert_time(source_timezone="America/Santiago", time="16:00", target_timezone="Europe/London")

# 3. Report back with all conversions
# "4pm Santiago = 8pm London = 12pm NYC = 9pm Paris"
```

## Reference

- **Agent**: Use `task(subagent_type="time")` for autonomous timezone coordination
- **MCP Tools**: Full tool documentation in agent file `@opencode/.config/opencode/agent/time.md`