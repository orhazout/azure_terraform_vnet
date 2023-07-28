variable "db_rg_name" {
  description = "Name of the db resource group"
  type        = string
}

variable "db_location" {
  description = "Name of the db location"
  type        = string
}

variable "nic_db_id" {
  description = "nic db id"
}

variable "db_key_data" {
  description = "db public ssh key"
}

variable "public_ip" {
  description = "db public ip address"
}

variable "db_password" {
  description = "data base password"
}

# variable "db_key_file" {
#   description = "ssh key file location"
# }