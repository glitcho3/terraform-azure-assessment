# Module: database

Creates an Azure PostgreSQL Flexible Server (single server) and a database. The
server is publicly accessible by default for development; production usage
should set `public_network_access_enabled = false` and use private networking.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | string | n/a | Name of the PostgreSQL server |
| resource_group_name | string | n/a | Resource group name |
| location | string | n/a | Azure region |
| admin_username | string | `"pgadmin"` | Administrator login username |
| admin_password | string | n/a | Administrator password (sensitive) |
| database_name | string | `"hello"` | Name of the default database |
| sku_name | string | `"B_Standard_B1ms"` | SKU name (e.g., `B_Standard_B1ms`, `GP_Standard_D2s_v3`) |
| storage_mb | number | `32768` | Storage in MB |
| allowed_cidr | string | `"10.0.1.0/24"` | CIDR block (expands as allowlist to access the database ) |
| tags | map(string) | `{}` | Tags to apply |

## Outputs

| Name | Description |
|------|-------------|
| server_id | Resource ID of the PostgreSQL server |
| fqdn | Fully qualified domain name of the server |
