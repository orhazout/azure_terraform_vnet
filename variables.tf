variable "rg_name" {
  description = "Name of the resource group"
  type        = string
}
variable project_location {
  description = "location of the project"
  type        = string
}

variable "db_password" {
  description = "data base password"
}

variable "db_key_data" {
  description = "db public ssh key"
}

variable "web_key_data" {
  description = "web public ssh key"
}
