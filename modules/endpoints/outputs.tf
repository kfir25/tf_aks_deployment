

output "dns_zone_name" {        
  value = azurerm_private_dns_zone.dns
}

output "dns_zone_group" {
  value = azurerm_private_endpoint.pe.private_dns_zone_group[0].private_dns_zone_ids
}
