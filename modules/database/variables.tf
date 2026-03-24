variable "name" {
  description = "Name of the PostgreSQL server"
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

variable "admin_username" {
  description = "Administrator login username"
  type        = string
  default     = "pgadmin"
}

variable "admin_password" {
  description = "Administrator password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the default database"
  type        = string
  default     = "hello"
}

variable "sku_name" {
  description = "SKU name for the server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Storage in MB"
  type        = number
  default     = 32768
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access the database"
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
