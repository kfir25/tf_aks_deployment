variable "resource_group" {
  type = string
}

variable "location" {
  type        = string
  description = "location or region"
}

variable "name" {
  type        = string
  description = "the name of the vnet"
}

#### ip address for the vnet ####
variable "address_space" {
  type        = string
  description = "IP prefix for the VNET"
}

#### ip address for the subnets ####
variable "subnets" {
  type = map(any)
}

variable "tags" {
  type = map(any)
}
 
# variable "create_nsg" {
#   type = bool
#   default = true
# }