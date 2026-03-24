#!/usr/bin/env bash
# Validates the configuration without touching real infrastructure.
# Requires: terraform >= 1.7.0 in PATH. Does not require Azure credentials.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

pass() { printf 'PASS  %s\n' "$*"; }
fail() { printf 'FAIL  %s\n' "$*" >&2; exit 1; }

terraform fmt -recursive -check . \
  && pass "fmt" || fail "fmt: run 'terraform fmt -recursive' to fix"

terraform init -backend=false -input=false -no-color > /dev/null 2>&1 \
  && pass "init" || fail "init"

terraform validate -no-color \
  && pass "validate" || fail "validate"

terraform plan \
  -var="workload=test" -var="environment=dev" \
  -var="create_networking=false" -var="create_compute=false" -var="create_database=false" \
  -input=false -no-color -out=tfplan_ci > /dev/null 2>&1 \
  && pass "plan: rg only" || fail "plan: rg only"
rm -f tfplan_ci

terraform plan \
  -var="workload=test" -var="environment=dev" \
  -var="create_networking=true" -var="create_compute=false" -var="create_database=false" \
  -input=false -no-color -out=tfplan_ci > /dev/null 2>&1 \
  && pass "plan: rg + networking" || fail "plan: rg + networking"
rm -f tfplan_ci

# Validation guards: invalid inputs must be rejected.
terraform plan -var="workload=X" -var="environment=dev" \
  -input=false -no-color 2>&1 | grep -q "error_message" \
  && pass "guard: invalid workload rejected" \
  || fail "guard: invalid workload was not rejected"

terraform plan -var="workload=test" -var="environment=qa" \
  -input=false -no-color 2>&1 | grep -q "error_message" \
  && pass "guard: invalid environment rejected" \
  || fail "guard: invalid environment was not rejected"

printf '\nall checks passed\n'
