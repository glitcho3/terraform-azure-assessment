variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be placed"
  type        = string
}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Administrator username"
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = false
}

variable "custom_data" {
  description = "Cloud-init user data (unencoded)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "service_name" {
  description = "Service name used in logs"
  type        = string
}

variable "db_host" {
  description = "Database hostname (optional, can be empty)"
  type        = string
  default     = ""
}
