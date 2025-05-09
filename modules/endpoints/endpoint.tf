resource "azurerm_private_endpoint" "pe" {
  name                = "ep-${var.resource_name}"
  location            = var.location
  resource_group_name = var.endpoint_resource_group
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [var.dns_zone_id != "" ? var.dns_zone_id : azurerm_private_dns_zone.dns[0].id]
  }

  private_service_connection {
    name                           = "pse-${var.resource_name}"
    private_connection_resource_id = var.resource_id
    is_manual_connection           = false
    subresource_names              = [var.resource_type] #["sites"]
  }

  depends_on = [
    azurerm_private_dns_zone.dns
  ]
}
# data "azurerm_private_dns_zone" "exist" {
#   name = var.private_dns_zone_name 
#   depends_on = [
    
#   ]
# }
resource "azurerm_private_dns_zone" "dns" {
  count = var.create_dns_zone ? 1 : 0

  name                = var.private_dns_zone_name     ###local.private_dns_zone[var.resource_type] # "privatelink.azurewebsites.net"
  resource_group_name = var.endpoint_resource_group
  # lifecycle {
  #   ignore_changes = [
      
  #   ]
  # }
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_ep_link" {
  count = var.create_dns_zone  ? 1 : 0 ##&& !data.azurerm_private_dns_zone.dns ? 1 : 0

  name                  = "dns_ep_link"
  resource_group_name   = var.endpoint_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.dns[0].name
  virtual_network_id    = var.dns_link_vnet_id
}

locals {
  create_zone = var.dns_zone_id == ""
  private_dns_zone = {
    # type = map(string)
    sites            = "privatelink.azurewebsites.net"
    redisCache       = "privatelink.redis.cache.windows.net"
    vault            = "privatelink.vaultcore.azure.net"
    blob             = "privatelink.blob.core.windows.net"
    postgresqlServer = "privatelink.postgres.database.azure.com"
    singlePSql       = "Microsoft.DBforPostgreSQL/servers"
    Sql              = "privatelink.documents.azure.com"
    sqlServer        = "privatelink.database.windows.net"
    registry         = "privatelink.azurecr.io"
    dataFactory      = "privatelink.datafactory.azure.net"
    synapse          = "privatelink.azuresynapse.net"
    synapseSql       = "privatelink.sql.azuresynapse.net"
    file = "privatelink.file.core.windows.net"

  }
    ep_subresource_name = {
    # type = map(string)
    sites            = "sites"
    redisCache       = "redisCache"
    vault            = "vault"
    blob             = "blob"
    postgresqlServer = "postgresqlServer"
    singlePSql       = "singlePSql"
    Sql              = "Sql"
    sqlServer        = "sqlServer"
    registry         = "registry"
    dataFactory      = "dataFactory"
    synapse          = "synapse"
    synapseSql       = "Sql"
    file = "File"
  }
}
# dns zone link https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns