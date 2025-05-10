
locals {
    rg_app = "rg-app-${var.project}-${var.env}-${var.location_short}-${var.name_serial}"
    rg_network = "rg-network-${var.project}-${var.env}-${var.location_short}-${var.name_serial}"


##############################################################################
### vnet - subnets - nsgs ###
##############################################################################

  # vnet1 
    vnet_name     = "vnet-application-${var.project}-${var.env}-${var.location_short}-${var.name_serial}"
    address_space = "${var.address_space_prefix}.${var.address_space_after_prefix}.${var.address_space_before_sufix}${var.address_space_sufix}"
     
    subnets = {
        aks_subnet = {
          name          = "snet-aks-${var.name_serial}"
          address_space = "${var.address_space_prefix}.1.${var.address_space_before_sufix}${var.address_space_subnet_sufix}"
        #   nsg_name      = "nsg-application-${var.project}-${var.env}-${var.location_short}-${var.name_serial}"
        }

        shared-ep = {
          name          = "snet-shared-ep-${var.name_serial}"
          address_space = "${var.address_space_prefix}.3.${var.address_space_before_sufix}${var.address_space_subnet_sufix}"
          nsg_name      = "nsg-shared-${var.project}-${var.env}-${var.location_short}-${var.name_serial}"
        }

    }



##############################################################################
                     ###### applications ######
##############################################################################
create_rg_app = true

##############################################################################
                  # AKS + ACR #
##############################################################################
  create_aks = true
  aks_name = "aks-${var.project}-${var.env}-${var.location_short}-${var.name_serial}"
  acr_name = "acr${var.project}${var.env}${var.location_short}${var.name_serial}"
  ep_subnet_acr = "shared-ep"
  acr_sku = "Premium"
  system_pool_name = lower("cp${var.project}${var.env}")
  apppool_name = lower("app${var.project}${var.env}") #between 1 and 12 characters
  automatic_channel_upgrade_aks = "stable"

  aks_subnet = "aks_subnet"
  aks_node_pool_vm_size ="Standard_B2s" 
  aks_os_disk_size_gb ="128" 
  system_pool_node_count ="1" 
  kubernetes_version = null

  private_cluster_enabled =false
  system_pool_zones = null #["1","2"] 
  system_pool_enable_auto_scaling = true
  system_pool_min_count = "1"
  system_pool_max_count = "2"
  system_pool_max_pods = "30"
  system_pool_type = "VirtualMachineScaleSets" 

  create_apppool  = true
  apppool_vm_size  = "Standard_B2s"
  apppool_zones  =  null # ["1","2"] 
  apppool_enable_auto_scaling  =  true
  apppool_node_count  = "1"
  apppool_min_count  =  "1"
  apppool_max_count  =  "2"

  aks_network_plugin  =  "azure"
  aks_load_balancer_sku  =  "standard"
  aks_network_policy  =  "azure"
  acr_create_end_point = true
  ac_public_network_access_enabled = true






}