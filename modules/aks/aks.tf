
resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "${var.aks_name}"
  location                = var.location
  resource_group_name     = var.resource_group
  dns_prefix              = "${var.aks_name}"
  private_cluster_enabled = var.private_cluster_enabled #true
  # private_dns_zone_id     = azurerm_private_dns_zone.dns_zone_aks.id
  automatic_upgrade_channel = var.automatic_upgrade_channel
  kubernetes_version  = var.kubernetes_version 
  
  default_node_pool {
  name                  = var.system_pool_name #"systempool"
  zones    = var.system_pool_zones #["1", "2", "3"]
  vm_size               = "${var.aks_node_pool_vm_size}"
  os_disk_size_gb       = "${var.aks_os_disk_size_gb}"
  vnet_subnet_id        = "${var.aks_sub_id}"
  auto_scaling_enabled   = var.system_pool_enable_auto_scaling #true
  min_count             = var.system_pool_min_count #"1"  
  max_count             = var.system_pool_max_count #"2"
  node_count            = "${var.system_pool_node_count}"
  max_pods              = var.system_pool_max_pods #"30"
  type                  = var.system_pool_type #"VirtualMachineScaleSets" 
  
  }
    lifecycle {
    ignore_changes = [
      
     default_node_pool
    ]
  }

  network_profile {
    network_plugin          = var.network_plugin #"azure"
    load_balancer_sku       = var.load_balancer_sku #"standard"
    network_policy          = var.network_policy #"calico/azure"
    
  }


  identity {
    type = "SystemAssigned"
  }


}
#add aditional pool

resource "azurerm_kubernetes_cluster_node_pool" "nodepool1" {
  count               = var.create_apppool ? 1 : 0
  name                  = var.apppool_name #"apppool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  os_disk_size_gb       = "${var.aks_os_disk_size_gb}"
  vm_size               = var.apppool_vm_size #"Standard_D4s_v3"
  node_count            = var.apppool_node_count #1
  min_count             =  var.apppool_min_count#    "1"  
  max_count             = var.apppool_max_count #"5"
  auto_scaling_enabled   = var.apppool_enable_auto_scaling #true

  zones    = var.apppool_zones #["1", "2", "3"]

#var.apppool_enable_auto_scaling ? var.apppool_min_count : ""
  lifecycle {
    ignore_changes = [
      tags,
      vnet_subnet_id,
      # enable_host_encryption,
      # enable_node_public_ip,
      fips_enabled,
      node_taints
    
    ]
  }
} 


#  Add role assignment on RG for connect AKS to VNET
# data  "azurerm_resource_group" "Resource_Group_vnet" {
#   name     = "${var.vnet_resource_group_name}"
#  }
 
# resource "azurerm_role_assignment" "role_AKSpool" {
#   scope                            = data.azurerm_resource_group.Resource_Group_vnet.id
#   role_definition_name             = "Contributor"
#   principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
#   skip_service_principal_aad_check = true
#    depends_on = [azurerm_kubernetes_cluster.aks]
# }


#####create acr-pull role
data "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}"
  resource_group_name = "${var.acr_resource_group_name}"
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}
