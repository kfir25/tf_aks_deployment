
resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = [var.address_space]
  #   dns_servers         = ["10.0.0.4", "10.0.0.5"]
  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                                           = "${each.value.subnet_name}"
  resource_group_name                            = var.resource_group
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [each.value.address_space]
  # enforce_private_link_service_network_policies  = true
  # enforce_private_link_endpoint_network_policies = true
  dynamic "delegation" {
    for_each = each.value.delegation != "" ? [each.value.delegation] : []
    content {
      name = "delegation"
      service_delegation {
        name = each.value.delegation
      }
    }
  }

  for_each = local.subnets

  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}

