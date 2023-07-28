resource "azurerm_resource_group" "default" {
  name     = var.rg_name
  location = var.project_location
}

module "virtual_network" {
  source = "./modules/virtual_network"
    vnet_rg_name  = var.rg_name
    vnet_location = var.project_location
    virtual_network_name = "tf_virtual_network"
    web_nsg = "web_nsg"
    web_subnet = "web_subnet"

    depends_on = [azurerm_resource_group.default]
}


module "data_base" {
  source = "./modules/data_base"
  db_rg_name  = var.rg_name
  db_location = var.project_location
  nic_db_id   = [module.virtual_network.db_nic_id]
  db_key_data = var.db_key_data
  # db_key_file = local_file.db_key.filename
  public_ip   = module.virtual_network.db_public_ip
  db_password = var.db_password

  depends_on = [module.virtual_network]
}

module "web_vm" {
  source = "./modules/web_vm"
  web_rg_name    = var.rg_name
  web_location   = var.project_location
  nic_web_id     = [module.virtual_network.web_nic_id]
  web_key_data   = var.db_key_data
  # web_key_file   = local_file.web_key.filename
  web_public_ip  = module.virtual_network.web_public_ip
  db_password    = var.db_password

  depends_on = [module.virtual_network]
}