
resource "azurerm_resource_group" "rg_app" {
  count = local.create_rg_app ? 1 : 0

  name     = local.rg_app
  location = var.location
}

module "aks" {
    source                  = "./modules/aks"
      count = local.create_aks ? 1 : 0


    location                = azurerm_resource_group.rg_app[0].location
    resource_group          = azurerm_resource_group.rg_app[0].name
    aks_name                = local.aks_name

    aks_node_pool_vm_size   = local.aks_node_pool_vm_size #"Standard_D2s_v3" 
    aks_os_disk_size_gb     = local.aks_os_disk_size_gb #"128" 
    system_pool_node_count   = local.system_pool_node_count #"1" 

    aks_subnet              = module.vnet.subnets_ids[local.aks_subnet].name
    aks_sub_id              = module.vnet.subnets_ids[local.aks_subnet].id
    # aks_vnet_01_name        = local.vnet
    automatic_upgrade_channel = local.automatic_channel_upgrade_aks

    vnet_resource_group_name = azurerm_resource_group.rg_network.name
    kubernetes_version = local.kubernetes_version

    private_cluster_enabled = local.private_cluster_enabled #true
    system_pool_zones = local.system_pool_zones #["1", "2", "3"]
    system_pool_enable_auto_scaling  = local.system_pool_enable_auto_scaling #true
    system_pool_min_count = local.system_pool_min_count #"1"
    system_pool_max_count = local.system_pool_max_count #"2"
    system_pool_max_pods = local.system_pool_max_pods #"30"
    system_pool_type = local.system_pool_type # "VirtualMachineScaleSets"
    system_pool_name = local.system_pool_name
    apppool_name = local.apppool_name


    create_apppool = local.create_apppool #true
    apppool_vm_size = local.apppool_vm_size #"Standard_D4s_v3"
    apppool_zones = local.apppool_zones # ["1", "2", "3"]
    apppool_enable_auto_scaling = local.apppool_enable_auto_scaling # true
    apppool_node_count = local.apppool_node_count #"1"
    apppool_min_count = local.apppool_min_count # "1"
    apppool_max_count = local.apppool_max_count # "5"

    network_plugin = local.aks_network_plugin # "azure"
    load_balancer_sku = local.aks_load_balancer_sku # "standard"
    network_policy = local.aks_network_policy # "calico"

    acr_name                = local.acr_name
    acr_resource_group_name = azurerm_resource_group.rg_app[0].name
    # vnet_vm_Name            = "${var.Vnet_VM}"
    # rg_vm_name              = "${var.RG_VM}"


    depends_on              = [module.vnet,module.acr]
}

module "acr" {
  source = "./modules/acr"
  count = local.create_aks ? 1 : 0

  location       = azurerm_resource_group.rg_app[0].location
  resource_group = azurerm_resource_group.rg_app[0].name
  acr_name           = local.acr_name

  acr_sku = local.acr_sku # "Premium"

  create_end_point           = local.acr_create_end_point # true
  endpoint_subnet_id         = module.vnet.subnets_ids[local.ep_subnet_acr].id
  endpoint_resource_group    = azurerm_resource_group.rg_network.name
  endpoint_dns_link_vnet_id  = module.vnet.vnet_id
  public_network_access_enabled = local.ac_public_network_access_enabled # true
}

