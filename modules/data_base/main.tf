resource "azurerm_virtual_machine" "db_vm" {
  name                  = "vm-db-prod"
  location              = var.db_location
  resource_group_name   = var.db_rg_name
  network_interface_ids = var.nic_db_id
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "osdisk-db"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm-db-prod"
    admin_username = "orhazout"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/orhazout/.ssh/authorized_keys"
      key_data = var.db_key_data
    }
  }

  connection {
    type        = "ssh"
    user        = "shachar"
    host        = var.public_ip
    private_key = file("~/.ssh/db-ssh-key")
  }
  provisioner "remote-exec" {
    connection {
      host        = var.public_ip
      type        = "ssh"
      user        = "orhazout"
      private_key = file("~/.ssh/db-ssh-key")
    }

    inline = [
    "sudo apt-get update",
    "sudo apt-get install -y postgresql postgresql-client",
    "sudo service postgresql start",
    "sleep 10",
    "sudo sed -i '/^# IPv4 local connections:/a host    all             all             10.0.2.0/24             trust' /etc/postgresql/10/main/pg_hba.conf",
    "sudo sed -i \"s/^#listen_addresses = .*$/listen_addresses = '*'/\" /etc/postgresql/10/main/postgresql.conf",
    "sudo service postgresql restart",
    "sudo -u postgres psql -c \"CREATE USER orhazout WITH SUPERUSER PASSWORD '${var.db_password}';\"",
    "sudo -u postgres psql -c \"CREATE DATABASE dogspatroldb;\"",
    "sudo -u postgres psql -d dogspatroldb -c \"CREATE TABLE data (name VARCHAR, weight_value INTEGER, mytime TIMESTAMP);\"",
    "sudo -u postgres psql -c \"\\q\"",
    "sudo service postgresql restart",
    "psql -U orhazout -d dogspatroldb;",
    ]
  }

  storage_data_disk {
    name              = "datadisk-db"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    disk_size_gb      = 4
    lun               = 1
  }
}

