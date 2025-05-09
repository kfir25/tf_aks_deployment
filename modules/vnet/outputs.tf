output "vnet_name" {
  value = "${azurerm_virtual_network.vnet.name}"
  #{ for k, v in local.vnets: k => azurerm_virtual_network.vnet[k].name }
  #"${azurerm_virtual_network.vnet.name}"
}

output "vnet_id" {
  value = "${azurerm_virtual_network.vnet.id}"
  #{ for k, v in local.vnets: k => azurerm_virtual_network.vnet[k].id }
  #"${azurerm_virtual_network.vnet.id}"
}

output "subnets_ids" {
  value = { for k, v in local.subnets: k => azurerm_subnet.subnet[k] }
}


output "nsgs_ids" {
  # value = { for k, v in local.subnets: k => azurerm_network_security_group.nsg[k] }
    value = { for k, v in local.nsg_create: k => azurerm_network_security_group.nsg[k] }

}

output "nsg_associations" {
  value = merge({ for k, v in local.nsg_create: k => azurerm_subnet_network_security_group_association.nsga[k] },
                  { for k, v in local.nsg_associate: k => azurerm_subnet_network_security_group_association.multi_nsg[k] })
}