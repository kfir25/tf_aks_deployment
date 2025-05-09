
locals { 
  subnets = { for snet_key,v in var.subnets: snet_key => {
    subnet_name = v.name
    nsg_name = try(v.nsg_name, "")
    address_space = v.address_space
    delegation = try(v.delegation, "")
    service_endpoints = try(v.service_endpoints, "")
    create_nsg = try(v.create_nsg, true)
    nsg_associate_key = try(v.nsg_associate_key, "")
   }
  }
  nsg = { for k,v in local.subnets: k => v if v.nsg_name != "" }
    # create_nsg = try(v.create_nsg, true)
    #  }
  nsg_create = { for k,v in local.subnets: k => v if v.create_nsg == true && v.nsg_name != "" }

  nsg_associate = { for k,v in local.subnets: k => v if v.create_nsg != true && v.nsg_name != "" }


  # nsgs_id = { for k, nsg in azurerm_network_security_group.nsg : nsg.name => nsg.id ... }
}

