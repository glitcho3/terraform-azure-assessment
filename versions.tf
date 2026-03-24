# ~> 3.100 means >=3.100.0, <4.0.0.
# .terraform.lock.hcl records the exact hash used; commit that file.

terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  # The storage account must exist before terraform init can use this backend.
  # Provision it outside this module, then run: terraform init -reconfigure
  #
  # backend "azurerm" {
  #   resource_group_name  = "rg-tfstate-shared-weu"
  #   storage_account_name = "sttfstateXXXXXXXX"
  #   container_name       = "tfstate"
  #   key                  = "bootstrap/dev.tfstate"
  # }
}

# Authentication order: ARM_* environment variables → az login → Managed Identity.
# Do not put credentials in .tf files.
provider "azurerm" {
  features {
    resource_group {
      # Requires child resources to be destroyed before the resource group.
      # Default is false (silent destroy-all-children).
      prevent_deletion_if_contains_resources = true
    }

    virtual_machine {
      delete_os_disk_on_deletion = true
      # Errors instead of silently stopping a running VM to apply changes.
      graceful_shutdown = false
    }
  }
}
