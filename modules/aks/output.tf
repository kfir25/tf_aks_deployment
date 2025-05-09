output "AKS1_name" {
  value =  azurerm_kubernetes_cluster.aks.name
  }

output "AKS1_id" {
  value =  azurerm_kubernetes_cluster.aks.id
  }
 

 output "AKS1_identity" {
  value =  azurerm_kubernetes_cluster.aks.identity[0].principal_id
  }
# output "AKS1_principal_id" {
#   value =  azurerm_kubernetes_cluster.aks.principal_id
#   }



  # module.Aks.AKS1_identity