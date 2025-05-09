# Creating ACR

resource "azurerm_container_registry" "acr" {
  name                          = "${var.acr_name}"
  resource_group_name           = "${var.resource_group}"
  location                      = var.location
  sku                           = "${var.acr_sku}"
  public_network_access_enabled = var.public_network_access_enabled #false
}


module "endpoint" {
  source = "../endpoints"

  count                   = var.create_end_point ? 1 : 0
  location                = var.location
  endpoint_resource_group = var.endpoint_resource_group
  resource_type           = "registry"
  private_dns_zone_name   = "privatelink.azurecr.io"


  resource_name = azurerm_container_registry.acr.name
  subnet_id     = var.endpoint_subnet_id
  resource_id   = azurerm_container_registry.acr.id

  dns_link_vnet_id = var.endpoint_dns_link_vnet_id
}