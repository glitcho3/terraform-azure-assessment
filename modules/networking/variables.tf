variable "name" {
  description = "Name of the VNet"
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

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_definitions" {
  description = "Map of subnet names to address prefixes"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    "default" = { address_prefixes = ["10.0.1.0/24"] }
  }
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "nsg_rules" {
  description = "Map of NSG rules (name -> rule config). Default includes SSH from a variable CIDR."
  type = map(object({
    priority           = number
    direction          = string
    access             = string
    protocol           = string
    source_port_range  = string
    destination_port_range = string
    source_address_prefix  = string
    destination_address_prefix = string
  }))
  default = {}
}

variable "nsg_ssh_cidr" {
  description = "CIDR block allowed to SSH to the VM (if public IP is enabled)"
  type        = string
  default     = "0.0.0.0/0"   # restrict in production
}
