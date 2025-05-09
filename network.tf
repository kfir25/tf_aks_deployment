

resource "azurerm_resource_group" "rg_network" {
  name     = local.rg_network
  location = var.location
}

module "vnet" { #vnet with subnets and ngs
# for_each = local.creat_vnet
  source = "./modules/vnet"
  tags   = var.tags

  location       = azurerm_resource_group.rg_network.location
  resource_group = azurerm_resource_group.rg_network.name
  name           = local.vnet_name

  address_space = local.address_space
  subnets       =  local.subnets   #each.value.vnet_key.subnets #each.value.subnets.id
  # vnets = local.vnets
}
