# Terraform Azure for DevOps Challenge

This repository contains a modular Terraform solution for provisioning Azure
infrastructure, created as part of the DevOps technical assessment. It
demonstrates:

- A reusable Virtual Network (VNet) module.
- Multi‑environment setup (dev/prod) using separate tfvars files.
- A Linux virtual machine (Ubuntu) with cloud‑init that logs structured JSON
  (OpenTelemetry format).
- An additional resource (Azure Storage Account).
- A GitHub Actions CI pipeline (plan on PR, manual apply).
- Documentation of design decisions via Architecture Decision Records (ADRs).

## Project Structure

```
.
├── .github/workflows/terraform.yml       # GitHub Actions pipeline
├── Makefile                              # Common tasks
├── README.md
├── cloud-init.yaml                       # Cloud‑init script (structured logging)
├── docs/
│   ├── ADR-00-bootstrap-sandbox.md       # Generic foundation decisions
│   └── ADR-01-devops-challenge.md        # Assessment‑specific decisions
├── environments/
│   ├── dev/terraform.tfvars.example      # Example dev variables 
│   └── prod/terraform.tfvars.example     # Example prod variables 
├── local-test/                           # Docker‑based local testing of logging
│   ├── bootstrap.sh
│   ├── docker-compose.yml
│   └── verify.sh
├── modules/
│   ├── compute/                          # Linux VM module
│   ├── database/                         # PostgreSQL flexible server module
│   ├── networking/                       # VNet + subnets module
│   └── resource_group/                   # Resource group module
├── outputs.tf
├── variables.tf
├── versions.tf
├── locals.tf
├── main.tf
├── plan.txt                              # Sample terraform plan output (dev)
└── terraform.tfvars.example              # Example root variables
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.7.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  (optional for local run, required for plan/apply)
- Docker (optional, for `make local-test`)

## Quick Start

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo
   ```

2. **Set up environment variables**  
   Copy the example tfvars and edit with your values (do not commit the actual tfvars):

   ```bash
   cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars

   # edit environments/dev/terraform.tfvars (set workload, environment, location, ssh key path)
   ```

3. **Authenticate to Azure** (if you want to see a plan)

   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

4. **Run a plan** (without applying)

   You can use the provided `Makefile` (defaults to the dev environment):
   ```bash
   make plan
   ```

   Or run Terraform directly:
   ```bash
   terraform plan -var-file=environments/dev/terraform.tfvars -out=tfplan
   ```

5. **View the included plan output**  
   The repository contains a sample `plan.txt` generated from a successful plan. This shows what resources would be created.

6. **Apply the infrastructure** (optional – only if you intend to deploy)

   Using the Makefile:
   ```bash
   make apply
   ```

   Or directly:
   ```bash
   terraform apply tfplan
   ```

7. **Destroy the infrastructure** when done

   Using the Makefile:
   ```bash
   make destroy
   ```

   Or directly:
   ```bash
   terraform destroy -var-file=environments/dev/terraform.tfvars
   ```

## Modules

| Module           | Purpose                                                  |
|------------------|----------------------------------------------------------|
| `networking`     | Creates a VNet and subnets (`default` and `db`).         |
| `compute`        | Deploys a Ubunto VM with cloud‑init and structured logs. |
| `database`       | Creates a PostgreSQL flexible server (optional).         |
| `resource_group` | Creates the resource group (always present).             |

Each module is independent and can be enabled via boolean variables
(`create_networking`, `create_compute`, `create_database`). The storage account
is added directly in the root and is also optional.

For detailed input/output documentation, see the individual module READMEs in `modules/`:

- [networking](./modules/networking/README.md) – VNet and subnets
- [compute](./modules/compute/README.md) – Linux VM with structured logs
- [database](./modules/database/README.md) – PostgreSQL flexible server
- [resource_group](./modules/resource_group/README.md) – resource group

## Observability & Logging

This format is vendor‑neutral and can be ingested by any logging system (New
Relic, Logstash, Fluent Bit, etc.) without transformation. The local test
(`make local-test`) verifies the same contract.

**Variables**:

- `timestamp`
- `service.name`
- `host.name`
- `log.level`
- `message`

### Bootstrap Configuration

The file `vm-bootstrap.yaml` configures the VM at first boot:
- Writes structured JSON logs to `/var/log/bootstrap.json` using OpenTelemetry
  keys (`timestamp`, `service.name`, `host.name`, `log.level`, `message`).
- Optionally checks PostgreSQL connectivity if `db_host` is provided.
- Logs a simple sequence: `bootstrap-start`, `hello-world`, `db-reachable`/`db-unreachable`, `bootstrap-complete`.


## GitHub Actions CI

The pipeline (`.github/workflows/terraform.yml`) runs on every pull request and
push to `main`. It checks formatting, validates the code, and runs `terraform
plan` for both `dev` and `prod` environments.  

> **Note**: To run the plan successfully in the pipeline, you need to set up
> Azure service principal secrets in the repository. The pipeline is included
> for demonstration.

## Design Decisions

Key decisions are documented in the `docs/` folder:

- **ADR‑00**: Generic bootstrap decisions (naming, tags, logging contract, opt‑in components, etc.).
- **ADR‑01**: Assessment‑specific decisions (storage account, environments via tfvars, GitHub workflow, testing approach).


## License

This project is for assessment purposes only.
