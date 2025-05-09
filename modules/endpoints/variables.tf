
variable "location" {
  type        = string
  description = "location or region"
}
variable "endpoint_resource_group" {
  type = string
}
variable "resource_type" {
  type = string
}
variable "resource_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "resource_id" {
  type = string
}

variable "dns_zone_id" {
  type    = string
  default = ""
}

variable "create_dns_zone" {
  type    = bool
  default = true
}
variable "dns_link_vnet_id" {
  type    = string
  default = ""
}
variable "private_dns_zone_name" {
  type    = string
  default = ""
}
