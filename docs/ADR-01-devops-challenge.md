# ADR-01: DevOps Challenge – Assessment Additions

**Status**: Accepted  
**Date**: 2026-03

---

## Context

The technical assessment builds on the bootstrap (ADR‑00). It requires:

- A reusable VNET module.
- Multi‑environment setup (dev/prod) using tfvars.
- A VM and one additional resource (storage account).
- A GitHub Actions pipeline.

This ADR documents the decisions made to fulfil these requirements.

---

## Decisions

### D1: Use the existing modular structure but add missing modules

The bootstrap already defines a clean separation of resources. The assessment
requires a **reusable VNET module**. A `networking` module is created under
`modules/networking/` with its own variables, outputs, and documentation.
Similarly, `compute` and `database` modules are created to encapsulate VM and
PostgreSQL logic. The resource group is **not** turned into a module; it
remains in the root to keep the root simple.

### D2: Storage account as the additional resource

A storage account (blob) is added as an optional resource, controlled by
variable `create_storage`. It is placed directly in the root module to avoid
creating a separate module for a one‑off requirement.

### D3: Environments managed via separate tfvars files

The root module accepts `var.environment`. Two environment directories are
created under `environments/` (dev and prod), each containing a
`terraform.tfvars` file. The root module is reused without duplication. This
pattern scales easily to more environments.

### D4: Remote state with per‑environment keys

Remote state is configured using an Azure Storage account. Each environment
uses a distinct state key (`dev.tfstate`, `prod.tfstate`). The backend block is
commented in `versions.tf` with instructions, ready to be uncommented after the
storage account is created.

### D5: GitHub Actions workflow

A workflow is defined in `.github/workflows/terraform.yml`. It:
- Runs on pull requests: `fmt`, `validate`, `plan` for both environments.
- On push to `main`: runs plan; apply is triggered manually
  (`workflow_dispatch`) or after approval.
- Uses secrets for Azure authentication (OIDC recommended, but static
  credentials are acceptable for the assessment).

### D6: Testing extended to cover the new modules

The existing `validate.sh` is extended to test the networking module
independently. A separate test script (e.g., `tests/test_networking.sh`) runs
`terraform init` and `plan` on a minimal configuration that only uses the
module, verifying its inputs and outputs.

### D7: Documentation automation with `terraform-docs`

CI includes a step to run `terraform-docs` and ensure that module documentation
is up‑to‑date. This keeps the `README.md` files inside each module synchronised
with the code.

---

## Verification Criteria

- `make test` passes locally without Azure credentials.
- `terraform plan -var-file="environments/dev/terraform.tfvars"` shows creation
  of: RG, VNet, subnets, VM, storage account, and related resources.
- GitHub Actions workflow runs on PR and outputs plans for both environments.
- Remote state is configured for each environment with distinct keys.
- Networking module README is generated/updated via `terraform-docs` and CI check passes.

---

## Alternatives Considered

- **Separate root directories per environment**: Would create duplication;
  rejected in favour of tfvars separation.
- **Dedicated storage module**: Unnecessary; single resource in root suffices.
- **Auto‑apply on push**: Rejected to avoid accidental production changes.
- **Terratest**: Overkill; lightweight validation remains effective.
