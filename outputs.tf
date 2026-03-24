output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_id" {
  value = module.resource_group.id
}

output "vnet_id" {
  value = var.create_networking ? module.networking[0].vnet_id : null
}

output "subnet_ids" {
  value = var.create_networking ? module.networking[0].subnet_ids : {}
}

output "vm_id" {
  value = var.create_compute ? module.compute[0].vm_id : null
}

output "vm_private_ip" {
  value = var.create_compute ? module.compute[0].private_ip_address : null
}

output "db_fqdn" {
  value = var.create_database ? module.database[0].fqdn : null
}

output "storage_account_name" {
  value = var.create_storage ? azurerm_storage_account.this[0].name : null
}
