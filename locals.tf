# Naming convention: Azure CAF
# {type_abbrev}-{workload}-{environment}-{region_abbrev}
# Abbreviations: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
#
# All derived names are composed here. Modules receive final strings.

locals {
  region_abbrev = {
    westeurope         = "weu"
    northeurope        = "neu"
    eastus             = "eus"
    eastus2            = "eus2"
    westus             = "wus"
    westus2            = "wus2"
    uksouth            = "uks"
    ukwest             = "ukw"
    germanywestcentral = "gwc"
    swedencentral      = "swc"
    francecentral      = "frc"
    switzerlandnorth   = "chn"
  }

  region = lookup(local.region_abbrev, var.location, var.location)

  prefix = "${var.workload}-${var.environment}-${local.region}"

  resource_group_name  = "rg-${local.prefix}"
  virtual_network_name = "vnet-${local.prefix}"
  vm_name              = "vm-${local.prefix}"
  nic_name             = "nic-${local.prefix}"
  psql_name            = "psql-${local.prefix}"
  storage_account_name = substr(replace("st${local.prefix}", "-", ""), 0, 24)

  # Base tags applied to every resource. Caller tags are merged on top;
  # caller values win on key collision.
  base_tags = {
    workload    = var.workload
    environment = var.environment
    location    = var.location
    managed-by  = "terraform"
  }

  tags = merge(local.base_tags, var.tags)
}

