# Module: compute

Deploys a Linux virtual machine (Ubuntu 22.04) with a network interface.
Supports optional public IP and cloud‑init user data.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | string | n/a | Name of the VM |
| resource_group_name | string | n/a | Resource group name |
| location | string | n/a | Azure region |
| subnet_id | string | n/a | ID of the subnet where the VM will be placed |
| vm_size | string | `"Standard_B1s"` | VM size |
| admin_username | string | `"azureuser"` | Administrator username |
| admin_ssh_public_key_path | string | n/a | Path to the SSH public key file |
| public_ip | bool | `false` | Whether to assign a public IP address |
| custom_data | string | `""` | Cloud‑init user data (unencoded, will be base64‑encoded by Terraform) |
| tags | map(string) | `{}` | Tags to apply |

## Outputs

| Name | Description |
|------|-------------|
| vm_id | Resource ID of the VM |
| private_ip_address | Private IP address of the VM |
| public_ip_address | Public IP address (if `public_ip = true`), otherwise `null` |
