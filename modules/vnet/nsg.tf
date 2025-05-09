### create all nsg from address_prefixes map ###
resource "azurerm_network_security_group" "nsg" {
  name                = each.value.nsg_name
  location            = var.location
  resource_group_name = var.resource_group

  for_each = local.nsg_create    #nsg_create   #nsg
  
  #{#local.nsg if local.create_nsg 
  # for k,v in local.nsg : k => v
  # if v.create_nsg != false
  # }
  tags = var.tags
}


### associate the nsg with the right subnet ###
resource "azurerm_subnet_network_security_group_association" "nsga" {
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id          #local.nsgs_id      #each.value.nsg_name.id     #azurerm_network_security_group.nsg[each.key].id
  for_each = local.nsg_create             #nsg

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_subnet.subnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "multi_nsg" {
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.nsg_associate_key].id          #local.nsgs_id      #each.value.nsg_name.id     #azurerm_network_security_group.nsg[each.key].id
  for_each = local.nsg_associate             #nsg

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_subnet.subnet
  ]
}
# resource "azurerm_network_interface_security_group_association" "example" {
#   count                     = length(azurerm_network_security_group.nsg.*.id)
#   network_interface_id      = element(azurerm_network_security_group.nsg.*.id, count.index)
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }