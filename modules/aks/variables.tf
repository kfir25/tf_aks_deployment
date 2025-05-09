
variable "location" {
    type        = string
    default     = ""
    description = "location for all resources"
}

variable "resource_group" {
    type        = string
    default     = ""
    description = "rg name"
}

variable "automatic_upgrade_channel" {
  type = string
}
variable "aks_vnet_01_name" {
    type        = string
    default     = ""
    description = "vnet name"
}

variable "aks_subnet" {
    type        = string
    default     = ""
    
}
variable "aks_sub_id"{
    type        = string
    default     = ""
}
 variable "aks_name" {
    type        = string
    default     = ""
}
variable "aks_node_pool_vm_size" {
    type        = string
    default     = "Standard_B2s"
}

variable "system_pool_node_count" {
    type        = string
    default     = "1"
}
variable "aks_os_disk_size_gb" {
    type        = string
    default     = "128"
}
variable "acr_name" {
    type        = string
    default     = ""
}
 variable "tier" {
    type        = string
    default     = ""   
}
variable "vnet_Hub_id" {
    type        = string
    default     = ""
    description = "vnet hub name"
 }

variable "vnet_vm_Name" {
    type        = string
    default     = ""
    description = "vnet vm name"
 }

variable "rg_vm_name" {
    type        = string
    default     = ""
    description = "RG vm name"
 }

variable "apppool_vm_size" {
    type        = string
    default     = "Standard_B2s"
 }

variable "create_apppool" {
    type        = bool
    default     = false
 }

variable "kubernetes_version" {
  type        = string
  default     = null# empty string means "use latest"
  description = "Kubernetes version for the AKS cluster. Leave blank to use latest."
}

# variable "dns_name" {
#     type        = string
#     default     = ""
#     description = "vnet hub name"
#  }

# variable "aks_resource_group_name" {
#     type        = string
#     default     = ""
#     description = "aks resource group name"
#  } 
  

  
# variable "create_end_point" {
#   type = bool
# }

# variable "endpoint_subnet_id" {
#   type    = string
#   default = ""
# }
# variable "endpoint_resource_group" {
#   type    = string
#   default = ""
# }
# variable "endpoint_dns_link_vnet_id" {
#   type    = string
#   default = ""
# }
variable "acr_resource_group_name" {
  type    = string
  default = ""
}
variable "vnet_resource_group_name" {
  type    = string
  default = ""
}

   
variable "private_cluster_enabled" {
  type    = bool
  default = true
}

variable "system_pool_name" {
  type    = string
  default = ""
}
variable "system_pool_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}
variable "system_pool_enable_auto_scaling" {
  type    = bool
  default = true
}
variable "system_pool_max_pods" {
  type    = string
  default = "30"
}
variable "system_pool_min_count" {
  type    = string
  default = "1"
}
variable "system_pool_max_count" {
  type    = string
  default = "2"
}
variable "system_pool_type" {
  type    = string
  default = "VirtualMachineScaleSets"
}


# variable "apppool_vm_size" {
#   type    = string
#   default = ""
# }
variable "apppool_node_count" {
  type    = string
  default = "1"
}
variable "apppool_enable_auto_scaling" {
  type    = bool
  default = true
}
variable "apppool_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}
variable "apppool_name" {
  type    = string
  default = ""
}
variable "apppool_max_count" {
  type    = string
  default = "5"
}
variable "apppool_min_count" {
  type    = string
  default = "1"
}


variable "network_policy" {
  type    = string
  default = ""
}
variable "load_balancer_sku" {
  type    = string
  default = ""
}
variable "network_plugin" {
  type    = string
  default = "azure"
}
