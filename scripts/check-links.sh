#!/bin/sh
# Verify every URL this org's public pages advertise actually serves what it claims.
#
# This exists because profile/README.md shipped `curl -fsSL rackctl.com/install | sh`
# against a PARKED domain for weeks. The holding page answers every path with HTTP 200
# and a 138KB HTML body, so `curl -f` does not fail — `sh` just executes HTML. A plain
# "is it 200?" check would have passed it. That is the bug this script is shaped around:
# a reachable URL is not a correct one.
#
# Two assertions, in order of how much they would have mattered:
#   1. The advertised install command serves a SHELL SCRIPT, not a web page.
#   2. Every other advertised link resolves (docs.rackctl.ai had no DNS record at all).
#
# Discipline notes, learned the hard way during the 2026-08-18 sweep:
#   - rc travels with every measurement. A missing binary returns 127 with empty
#     stdout, which reads exactly like "no problems found".
#   - never 2>/dev/null a probe whose emptiness you intend to report.
#   - zsh does not word-split unquoted expansions, so iterate with `while read`,
#     never `for x in $LIST`.

set -eu

FAILURES="$(mktemp)"
trap 'rm -f "$FAILURES"' EXIT

fail() { printf '%s\n' "$1" >> "$FAILURES"; }
report() { printf '  %-6s %-46s %s\n' "$1" "$2" "${3:-}"; }

# ── 1. The install command must serve a script ──────────────────────────────
#
# Extracted from the README rather than hardcoded, so the check follows the docs
# instead of drifting from them.
INSTALL_URL="$(grep -oE 'curl -fsSL [^ ]+/install' profile/README.md | head -1 | awk '{print $3}' || true)"

if [ -z "$INSTALL_URL" ]; then
  echo "FAIL: no install command found in profile/README.md."
  echo "      The grep matched nothing — that is a failure, not a pass."
  exit 1
fi

echo "install command:"

BODY=""
if ! BODY="$(curl -sS -L --max-time 25 "https://$INSTALL_URL" 2>&1)"; then
  report "ERR" "$INSTALL_URL" "request failed: $BODY"
  fail "$INSTALL_URL unreachable"
else
  CTYPE="$(curl -sS -o /dev/null -L --max-time 25 -w '%{content_type}' "https://$INSTALL_URL" 2>/dev/null || echo unknown)"
  case "$BODY" in
    '#!'*)
      report "ok" "$INSTALL_URL" "shell script, $CTYPE"
      ;;
    *)
      report "FAIL" "$INSTALL_URL" "NOT a script — $CTYPE"
      echo
      echo "  The advertised install command does not serve a shell script."
      echo "  First lines received:"
      # sed rather than `head -c`, which closes the pipe early and makes printf
      # emit a spurious "write error: Broken pipe" over the actual diagnostic.
      printf '%s\n' "$BODY" | sed -n '1,4p' | sed 's/^/    /'
      echo
      echo "  This is the parked-domain failure: a 200 response that pipes HTML"
      echo "  into sh. Point the README at the canonical domain."
      fail "$INSTALL_URL serves $CTYPE, not a script"
      ;;
  esac
fi

# ── 2. Every advertised link must resolve ───────────────────────────────────
echo
echo "links:"

grep -ohE 'https://[a-zA-Z0-9./_-]+' \
     profile/README.md README.md SECURITY.md CONTRIBUTING.md CODE_OF_CONDUCT.md \
  | sed 's/[.,)]*$//' \
  | sort -u > "$FAILURES.urls"

while IFS= read -r url; do
  code="$(curl -sS -o /dev/null -L --max-time 25 -w '%{http_code}' "$url" 2>/dev/null || echo 000)"
  case "$code" in
    2*|3*)
      report "$code" "$url"
      ;;
    000)
      report "DEAD" "$url" "did not resolve"
      fail "$url did not resolve"
      ;;
    404)
      # A private repo and a deleted one are indistinguishable to anonymous curl —
      # both 404. Disambiguate with an authenticated call rather than guessing,
      # because the two need opposite responses: a deleted repo is a broken link,
      # a private one is a visibility decision for the maintainer.
      slug="$(printf '%s' "$url" | sed -n 's|^https://github\.com/\([^/]*/[^/]*\)$|\1|p')"
      if [ -n "$slug" ] && command -v gh >/dev/null 2>&1 \
         && vis="$(gh api "repos/$slug" --jq .visibility 2>/dev/null)" && [ -n "$vis" ]; then
        report "$code" "$url" "repo is $vis — public visitors see a 404"
        # Not a build failure: the link is correct, the repo is simply not public.
        # Surfaced loudly because this page's audience IS the public.
      else
        report "404" "$url" "not found"
        fail "$url returned 404"
      fi
      ;;
    *)
      report "$code" "$url" "unexpected status"
      fail "$url returned $code"
      ;;
  esac
done < "$FAILURES.urls"
rm -f "$FAILURES.urls"

# ── verdict ─────────────────────────────────────────────────────────────────
echo
COUNT="$(wc -l < "$FAILURES" | tr -d ' ')"
if [ "$COUNT" -gt 0 ]; then
  echo "FAILED — $COUNT problem(s):"
  sed 's/^/  - /' "$FAILURES"
  exit 1
fi
echo "ok — install command serves a script, all links resolve"
