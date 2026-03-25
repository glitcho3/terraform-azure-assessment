# Resource group (always created)
module "resource_group" {
  source   = "./modules/resource_group"
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

# Networking (optional)
module "networking" {
  count  = var.create_networking ? 1 : 0
  source = "./modules/networking"

  name                = local.virtual_network_name
  resource_group_name = module.resource_group.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  subnet_definitions = {
    "default" = { address_prefixes = ["10.0.1.0/24"] }
    "db"      = { address_prefixes = ["10.0.2.0/24"] }
  }
  tags         = local.tags
  nsg_ssh_cidr = var.nsg_ssh_cidr # add this variable in root variables.tf

}

# Compute (optional, requires networking)
module "compute" {
  count  = var.create_compute ? 1 : 0
  source = "./modules/compute"

  name                      = local.vm_name
  resource_group_name       = module.resource_group.name
  location                  = var.location
  subnet_id                 = module.networking[0].subnet_ids["default"] # Use default subnet for VM
  admin_ssh_public_key_path = var.admin_ssh_public_key_path
  custom_data = templatefile("${path.module}/vm-bootstrap.yaml", {
    service = var.service_name
    db_host = var.db_host
  })
  tags = local.tags
}

# Database (optional, requires networking)
module "database" {
  count  = var.create_database ? 1 : 0
  source = "./modules/database"

  name                = local.psql_name
  resource_group_name = module.resource_group.name
  location            = var.location
  admin_password      = var.db_admin_password
  allowed_cidr        = module.networking[0].subnet_ids["default"] != "" ? cidrhost(module.networking[0].subnet_ids["default"], 0) : "10.0.1.0/24" # approximate
  tags                = local.tags
}

# Storage account (optional, independent)
resource "azurerm_storage_account" "this" {
  count                    = var.create_storage ? 1 : 0
  name                     = local.storage_account_name
  resource_group_name      = module.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}
