variable "workload" {
  description = "Workload identifier (e.g., app name)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.workload))
    error_message = "Workload must be 2-10 alphanumeric lowercase."
  }
}

variable "environment" {
  description = "Deployment environment (dev, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "create_networking" {
  description = "Create networking resources"
  type        = bool
  default     = false
}

variable "create_compute" {
  description = "Create compute resources (VM)"
  type        = bool
  default     = false
}

variable "create_database" {
  description = "Create database resources"
  type        = bool
  default     = false
}

variable "create_storage" {
  description = "Create a storage account (blob)"
  type        = bool
  default     = false
}

variable "admin_ssh_public_key_path" {
  description = "Path to the SSH public key for the VM"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "db_admin_password" {
  description = "Password for PostgreSQL administrator"
  type        = string
  sensitive   = true
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

