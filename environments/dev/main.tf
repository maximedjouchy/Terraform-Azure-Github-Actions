terraform {

  backend "azurerm" {
    resource_group_name  = "rg-terraform-mgmt"
    storage_account_name = "tfstatemaxdjou6428"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }

  required_version = ">= 1.9, < 2.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.116, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azapi" {}

provider "random" {}

resource "azurerm_resource_group" "my_devops_rg" {
  name     = "rg-dev"
  location = "East US"
}

module "network" {
  source  = "../../modules/network"
  rg_name = azurerm_resource_group.my_devops_rg.name
}

module "vm_dev" {
  source         = "../../modules/compute"
  vm_name        = "vm-dev-01"
  vm_size        = "Standard_B1s"
  rg_name        = azurerm_resource_group.my_devops_rg.name
  location       = azurerm_resource_group.my_devops_rg.location
  subnet_id      = module.network.subnet_id
  ssh_public_key = var.ssh_public_key
}