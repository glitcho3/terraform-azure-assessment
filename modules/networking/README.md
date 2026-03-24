# Module: networking

Creates a VNet and subnets.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | string | n/a | VNet name |
| resource_group_name | string | n/a | Resource group name |
| location | string | n/a | Azure region |
| address_space | list(string) | `["10.0.0.0/16"]` | Address space for the VNet |
| subnet_definitions | map(object) | n/a | (each object contains `address_prefixes`) |

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | VNet resource ID |
| subnet_ids | Map of subnet name ID |
