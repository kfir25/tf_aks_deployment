# # variable "create_rg_app" {
#   type    = bool
# #   default = ""
# }
# variable "create_app_service_win_list" {
#   type    = bool
# #   default = ""
# }



variable "project" {
  type = string
}
variable "location" {
  type = string
}
variable "env" {
  type = string
}
variable "name_serial" {
  type    = string
}
variable "address_space_prefix" {
  type = string
  default = "172.22.0.0"
}
variable "address_space_sufix" {
  type = string
  default = "/20"
}
variable "tags" {
  type    = map(any)
}

variable "address_space_after_prefix" {
  type    = string
}
variable "address_space_before_sufix" {
  type    = string
}

variable "address_space_subnet_sufix" {
  type    = string
}
variable "location_short" {
  type = string
}