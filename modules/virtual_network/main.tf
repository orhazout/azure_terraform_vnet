resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  resource_group_name = var.vnet_rg_name
  address_space       = ["10.0.0.0/16"]
  location            = var.vnet_location
}

output "network_id" {
  value = azurerm_virtual_network.virtual_network.id
}

resource "azurerm_subnet" "web_subnet" {
  name                 = var.web_subnet
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [azurerm_virtual_network.virtual_network]
}


resource "azurerm_network_security_group" "web_nsg" {
  name                = var.web_nsg
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name

  security_rule {
    name                       = "Allow_Web_Port_8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }




  security_rule {
    name                       = "Allow_Web_Port_80"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "Allow_Web_Port_5000"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


    security_rule {
    name                       = "Allow_Web_Subnet_SSH"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "77.137.77.118"
    destination_address_prefix = "*"
  }
  depends_on =[azurerm_virtual_network.virtual_network]
}


resource "azurerm_subnet" "db_subnet" {
  name                 = "db_subnet"
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [azurerm_virtual_network.virtual_network]
}


resource "azurerm_network_security_group" "nsg_db" {
  name                = "db_nsg"
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name

  security_rule {
    name                       = "Allow_DB_Subnet_Inbound"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.2.0"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_DB_Subnet_SSH"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "77.137.77.118"
    destination_address_prefix = "*"
  }
  depends_on = [azurerm_virtual_network.virtual_network]
}

resource "azurerm_public_ip" "public_ip_db" {
  name                = "public-ip-db-prod"  
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name
  allocation_method   = "Static"
  depends_on = [azurerm_virtual_network.virtual_network]
}

output "db_public_ip" {
  value = azurerm_public_ip.public_ip_db.ip_address
}

resource "azurerm_network_interface" "nic_db" {
  name                = "nic-db-prod"
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name

  ip_configuration {
    name                          = "ipconfig-db-private"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10" 
    primary                       = true
  }

  ip_configuration {
    name                          = "ipconfig-db-public"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_db.id
  }
}

output "db_nic_id" {
  value = azurerm_network_interface.nic_db.id
}

resource "azurerm_public_ip" "public_ip_web" {
  name                = "public-ip-web"
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name
  allocation_method   = "Static"
}

output "web_public_ip" {
  value = azurerm_public_ip.public_ip_web.ip_address
}

resource "azurerm_network_interface" "nic_web" {
  name                = "nic-web"
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name

  ip_configuration {
    name                          = "ipconfig-web"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_web.id
  }
}

output "web_nic_id" {
  value = azurerm_network_interface.nic_web.id
}