variable "vnet_rg_name" {
  description = "Name of the vnet resource group"
  type        = string
}

variable "vnet_location" {
  description = "Name of the vnet location"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "web_subnet" {
  description = "Name of the web subnet"
  type        = string
}

variable "web_nsg" {
  description = "Name of the web network security group"
  type        = string
}

# variable "db_subnet" {
#   description = "Name of the db subnet"
#   type        = string
# }

# variable "db_nsg" {
#   description = "Name of the db network security group"
#   type        = string
# }

