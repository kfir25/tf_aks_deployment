

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


variable "aks_sub_id"{
    type        = string
    default     = ""
}
# variable "private_endpoint_subnet_name" {
#     type        = string
#     default     = ""
#     description = "vnet name"
# }
# variable "private_endpoint_vnet_01_name" {
#     type        = string
#     default     = ""
# }

variable "acr_name" {
    type        = string
    default     = ""
}

variable "acr_sku" {
    type        = string
    default     = "Premium"
}



variable "create_end_point" {
  type = bool
}

variable "endpoint_subnet_id" {
  type    = string
  default = ""
}
variable "endpoint_resource_group" {
  type    = string
  default = ""
}
variable "endpoint_dns_link_vnet_id" {
  type    = string
  default = ""
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}
