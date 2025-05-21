terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.29.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

locals {
  subscription_id         = "537bb5af-974a-40ed-9493-5761b69e345a"
  resource_group_name     = "ngalipot-rg"
  resource_group_location = "West Europe"
  vnets = [
    { vnet_name             = "ngalipot-vnet1"
      vnet_address_space    = "10.0.0.0/16"
      subnet_name           = "ngalipot-subnet1"
      subnet_address_prefix = "10.0.1.0/24"
      open_ports            = ["80", "443"]
    },
    { vnet_name             = "ngalipot-vnet2"
      vnet_address_space    = "10.1.0.0/16"
      subnet_name           = "ngalipot-subnet2"
      subnet_address_prefix = "10.1.1.0/24"
      open_ports            = ["80", "443"]
    },
  ]
}

resource "azurerm_resource_group" "ngalipot_rg" {
  name     = local.resource_group_name
  location = local.resource_group_location
}

module "azure_rg" {
  count = length(local.vnets)

  source          = "./modules/azure_rg"
  subscription_id = local.subscription_id
  resource_group = { name = local.resource_group_name
    location = local.resource_group_location
  }
  vnet_name             = local.vnets[count.index].vnet_name
  vnet_address_space    = local.vnets[count.index].vnet_address_space
  subnet_name           = local.vnets[count.index].subnet_name
  subnet_address_prefix = local.vnets[count.index].subnet_address_prefix
  open_ports            = local.vnets[count.index].open_ports
}