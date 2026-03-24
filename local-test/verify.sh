#!/usr/bin/env bash
# Verifies the local test produced expected log events.
# Exit 0 = pass, 1 = fail.

LOG="./logs/bootstrap.json"

pass() { printf 'PASS  %s\n' "$*"; }
fail() { printf 'FAIL  %s\n' "$*" >&2; exit 1; }

[ -f "$LOG" ] || fail "bootstrap.json not found"

grep -q '"message":"hello-world"'        "$LOG" && pass "hello-world logged"      || fail "hello-world missing"
grep -q '"message":"bootstrap-complete"' "$LOG" && pass "bootstrap-complete logged" || fail "bootstrap-complete missing"
grep -q '"message":"db-reachable'        "$LOG" && pass "db-reachable logged"      || fail "db-reachable missing"

echo ""
echo "--- log output ---"
cat "$LOG"
