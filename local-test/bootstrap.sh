#!/usr/bin/env bash
# Local equivalent of cloud-init.yaml.
# Same log contract, same DB check, same output file.

set -euo pipefail

apt-get update -qq && apt-get install -y -qq netcat-openbsd > /dev/null 2>&1

log() {
  local service="$1" level="$2" message="$3"
  local ts host
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  host=$(hostname)
  printf '{"timestamp":"%s","service.name":"%s","host.name":"%s","log.level":"%s","message":"%s"}\n' \
    "$ts" "$service" "$host" "$level" "$message" \
    | tee -a /var/log/bootstrap.json
}

log "$SERVICE" INFO bootstrap-start
log "$SERVICE" INFO hello-world

if [ -n "${DB_HOST:-}" ]; then
  log "$SERVICE" INFO "checking-db $DB_HOST"
  if nc -zv "$DB_HOST" 5432 2>/dev/null; then
    log "$SERVICE" INFO "db-reachable $DB_HOST"
  else
    log "$SERVICE" ERROR "db-unreachable $DB_HOST"
  fi
fi

log "$SERVICE" INFO bootstrap-complete
