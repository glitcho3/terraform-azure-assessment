# ADR-00: Bootstrap Sandbox – Foundational Decisions

**Status**: Accepted  
**Date**: 2026-03

---

## Context

A reusable Terraform foundation for Azure, used as a starting point for various
projects. It must be simple, extensible, and include a working example
(VM with structured logs).

---

## Decisions

**D1: Workload and environment have no defaults.**  
Missing either fails fast to avoid accidental deployment.

**D2: Names composed in `locals.tf`; modules receive final strings.**  
Naming logic is centralised; modules stay portable.

**D3: Tags composed at the root.**  
Base tags are applied to all resources; caller tags merge on top.

**D4: Subnets use `for_each` over a map, not `count`.**  
Avoids replacement when the list changes.

**D5: Networking, compute, and database are independently opt‑in.**  
Default deploys only the resource group. Each capability is enabled with a boolean.

**D6: `.terraform.lock.hcl` is committed.**  
Pins provider hashes for reproducibility.

**D7: Tests run without Azure credentials (`init -backend=false`).**  
Validation ensures invalid inputs are rejected.

**D8: Logging format uses OpenTelemetry semantic convention keys.**  
`timestamp`, `service.name`, `host.name`, `log.level`, `message`.  
Any receiver can ingest without transformation.

**D9: DB connectivity check in cloud‑init is non‑fatal.**  
The VM logs reachability but continues even if the DB is not ready.

---

## Verification Criteria

- `make test` passes locally.
- Plan with only `create_* = false` shows 1 resource (resource group).
- Plan with `create_networking=true` shows 4 resources: RG, VNet, 2 subnets.
- Invalid workload/environment cause validation errors.
- After apply with `create_compute=true`, `/var/log/bootstrap.json` contains
  the expected events.

---

## Alternatives Discarded

- Naming inside modules → diverging conventions.
- `count` for subnets → order‑sensitive.
- Fatal DB check → deployment shouldn't fail because of a delayed database.
- Vendor‑specific log format → locks the VM to a single backend.
