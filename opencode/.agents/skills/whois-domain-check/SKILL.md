---
name: whois-domain-check
description: Check domain name availability for any TLD using nix-shell whois. Use this whenever the user asks to check if a domain is available, find available domain names, brainstorm domain names for a project, or validate domain name ideas. Triggers on phrases like "is X taken", "check domain", "find available domains", "domain name ideas", "is .com available", etc.
---

# Whois Domain Check

Check domain availability in bulk using the system `whois` command via `nix-shell`.

## How to Check Domains

Run domains through `nix-shell -p whois` and parse the output for availability signals:

```bash
nix-shell -p whois --run 'whois "example.com"' 2>/dev/null
```

## Interpreting Results

A domain is **AVAILABLE** if the whois output contains any of these signals:
- `No match`
- `NOT FOUND`
- `Domain not found`
- `is available`
- `not been registered`
- `The queried object does not exist`
- `DOMAIN NOT FOUND`
- `No object found`
- `No Data Found`

A domain is **TAKEN** if the whois returns registration details (registrar, dates, name servers).

A domain is **UNSUPPORTED** if the output says `TLD is not supported`.

## Batch Checking

For efficient batch checking, pass a list of domains:

```bash
nix-shell -p whois --run '
for name in "example.com" "example.app" "example.io"; do
  result=$(whois "$name" 2>/dev/null)
  if echo "$result" | grep -qi "No match\|NOT FOUND\|Domain not found\|is available\|The queried object does not exist\|DOMAIN NOT FOUND"; then
    echo "AVAILABLE: $name"
  elif echo "$result" | grep -qi "TLD is not supported"; then
    echo "UNSUPPORTED: $name"
  else
    echo "TAKEN: $name"
  fi
done
'
```

## Output Format

Present results in a clean table:

| Domain | Status |
|--------|--------|
| myname.com | ✅ Available |
| myname.app | ❌ Taken |
| myname.io | ❌ Taken |

## Tips

- `.com` and `.app` are the most commonly desired TLDs — always check those first
- Many short/meaningful words are squatted; try compound words (passvaultr.com), modified spellings (krypkeep.com), or unique coinages
- Avoid TLDs the system whois doesn't support (listed as UNSUPPORTED)
