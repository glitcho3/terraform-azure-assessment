# Module: resource_group

Creates an Azure Resource Group. Basic building block, always created.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | string | n/a | Name of the resource group |
| location | string | n/a | Azure region |
| tags | map(string) | `{}` | Tags to apply |

## Outputs

| Name | Description |
|------|-------------|
| id | Resource ID of the resource group |
| name | Name of the resource group |
| location | Location of the resource group |
