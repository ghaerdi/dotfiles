#!/usr/bin/env bash
# qa-branch-diff — Extract unique NV ticket identifiers (NV-XXXX) that differ
# between two sequential QA branches.
#
# Usage:
#   qa-branch-diff.sh                          # auto-detect latest two QA branches
#   qa-branch-diff.sh qa-79 qa-80              # explicit branches
#   qa-branch-diff.sh --full qa-79 qa-80       # full commit messages, not just NV IDs
#   qa-branch-diff.sh -h                       # help
#
# Output:
#   Bullet list of NV-XXXX tickets with Linear URLs, sorted numerically.

set -euo pipefail

# --- helpers ----------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }
warn() { echo "WARN: $*" >&2; }

usage() {
  sed -n '2,/^$/s/^# //p' "$0"
  exit 0
}

# --- argument parsing -------------------------------------------------------

FULL_MODE=false
OLDER=""
NEWER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)    usage ;;
    --full)       FULL_MODE=true; shift ;;
    *)
      if [[ -z "$OLDER" ]]; then
        OLDER="$1"
      elif [[ -z "$NEWER" ]]; then
        NEWER="$1"
      else
        die "too many arguments"
      fi
      shift
      ;;
  esac
done

# --- branch detection -------------------------------------------------------

ref_prefix() {
  echo "origin/"
}

# List incremental QA branches matching qa-[0-9]{2} (exactly two digits).
# This excludes non-standard branches like qa-2026-77.
list_qa_branches() {
  git ls-remote --heads origin 'qa-*' 2>/dev/null | grep -oP 'refs/heads/\Kqa-\d{2}$' | sort -u
}

if [[ -z "$OLDER" && -z "$NEWER" ]]; then
  ALL_BRANCHES=$(list_qa_branches)
  [[ -z "$ALL_BRANCHES" ]] && die "no qa-[0-9]{2} branches found — try specifying branches explicitly"
  LATEST_NUM=$(echo "$ALL_BRANCHES" | grep -oP '\d{2}$' | sort -n | tail -1)
  PREV_NUM=$((10#$LATEST_NUM - 1))  # base-10 to avoid octal issues with leading zeros
  # Pad back to two digits
  PREV=$(printf "qa-%02d" "$PREV_NUM")
  LATEST="qa-${LATEST_NUM}"
  OLDER="$PREV"
  NEWER="$LATEST"
  echo "» Auto-detected: older=$OLDER  newer=$NEWER"
elif [[ -z "$NEWER" ]]; then
  die "provide both older and newer branch, or neither (auto-detect)"
fi

PREFIX=$(ref_prefix)
OLDER_REF="${PREFIX}${OLDER}"
NEWER_REF="${PREFIX}${NEWER}"

# --- fetch ------------------------------------------------------------------

echo "» Fetching $OLDER $NEWER ..."
git fetch origin "$OLDER" "$NEWER" 2>/dev/null || warn "fetch may have failed — continuing with existing refs"

# --- verify branches exist --------------------------------------------------

REMOTE_EXISTS=$(git ls-remote --heads origin "$OLDER" "$NEWER" 2>/dev/null | grep -c . || true)
if [[ "$REMOTE_EXISTS" -eq 0 ]]; then
  if ! git rev-parse --verify "$OLDER_REF" >/dev/null 2>&1; then
    die "branch '$OLDER' does not exist on remote 'origin' — try \`git remote prune origin\` to clean stale refs, then re-run"
  fi
fi

if ! git rev-parse --verify "$OLDER_REF" >/dev/null 2>&1; then
  warn "pruning stale remote refs and retrying..."
  git remote prune origin 2>/dev/null
  git fetch origin "$OLDER" "$NEWER" 2>/dev/null || true
  if ! git rev-parse --verify "$OLDER_REF" >/dev/null 2>&1; then
    die "branch '$OLDER_REF' does not exist"
  fi
fi
if ! git rev-parse --verify "$NEWER_REF" >/dev/null 2>&1; then
  die "branch '$NEWER_REF' does not exist"
fi

# --- find the cut point -----------------------------------------------------

# Strategy 1: match the HEAD commit message of the older branch in the newer branch's history.
# This handles cherry-picks where the hash changes but the message stays the same.
CUT_HASH=""
OLDER_MSG=$(git log -1 --format="%s" "$OLDER_REF")
echo "» Older branch HEAD message: $OLDER_MSG"

# Search the newer branch for the same commit message.
MATCHES=$(git log "$NEWER_REF" --oneline --grep="$OLDER_MSG" 2>/dev/null || true)
MATCH_COUNT=$(echo "$MATCHES" | grep -c . || true)

if [[ "$MATCH_COUNT" -gt 0 ]]; then
  CUT_HASH=$(echo "$MATCHES" | head -1 | awk '{print $1}')
  if [[ "$MATCH_COUNT" -gt 1 ]]; then
    warn "multiple matches for commit message — using first: $CUT_HASH"
  fi
  echo "» Found cut point via commit message: $CUT_HASH"
else
  warn "commit message not found in newer branch — falling back to merge-base"
  CUT_HASH=$(git merge-base "$OLDER_REF" "$NEWER_REF" 2>/dev/null || true)
  if [[ -z "$CUT_HASH" ]]; then
    die "could not find merge-base between $OLDER_REF and $NEWER_REF"
  fi
  echo "» Using merge-base as cut point: $CUT_HASH"
fi

# --- extract NV tickets -----------------------------------------------------

COMMIT_RANGE="${CUT_HASH}..${NEWER_REF}"

if $FULL_MODE; then
  echo ""
  echo "=== Commits between $COMMIT_RANGE ==="
  git log "$COMMIT_RANGE" --oneline
else
  echo ""
  echo "=== NV tickets unique to $NEWER (vs $OLDER) ==="
  TICKETS=$(git log "$COMMIT_RANGE" --oneline --grep="NV-[0-9]\{4\}" | \
            grep -oP 'NV-\d{4}' | \
            sort -t- -k2 -n | \
            uniq)

  if [[ -z "$TICKETS" ]]; then
    echo "(none)"
  else
    TICKET_COUNT=$(echo "$TICKETS" | wc -l)
    echo "Found $TICKET_COUNT tickets:"
    echo ""

    # Format each ticket as a markdown bullet with Linear URL
    echo "$TICKETS" | while IFS= read -r tid; do
      echo "- $tid (https://linear.app/nectarvet/issue/$tid)"
    done
  fi
fi
