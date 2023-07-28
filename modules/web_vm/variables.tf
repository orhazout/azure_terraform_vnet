variable "web_rg_name" {
  description = "Name of the web resource group"
  type        = string
}

variable "web_location" {
  description = "Name of the web location"
  type        = string
}

variable "nic_web_id" {
  description = "nic web id"
}

variable "web_key_data" {
  description = "web public ssh key"
}

variable "web_public_ip" {
  description = "web public ip address"
}

variable "db_password" {
  description = "data base password"
}

# variable "web_key_file" {
#   description = "ssh key file location"
# }