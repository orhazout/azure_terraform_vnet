resource "azurerm_virtual_machine" "web_vm" {
  name                  = "vm-webapp-prod"
  location              = var.web_location
  resource_group_name   = var.web_rg_name
  network_interface_ids = var.nic_web_id
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "osdisk-web"
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
    computer_name  = "vm-webapp-prod"
    admin_username = "orhazout"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/orhazout/.ssh/authorized_keys"
      key_data = var.web_key_data
    }
  }

  provisioner "remote-exec" {
    connection {
      host        = var.web_public_ip
      type        = "ssh"
      user        = "orhazout"
      private_key = file("~/.ssh/db-ssh-key")
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3-pip",
      "sudo -H pip3 install --upgrade pip",
      "sudo -H pip3 install flask flask-cors psycopg2-binary",
      "echo 'export DB_PASSWORD=\"${var.db_password}\"' >> ~/.bashrc",
      "echo '${file("./app.py")}' >> app.py",
      "python3 app.py",
   ]
  }
  

  storage_data_disk {
    name              = "datadisk-web"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    disk_size_gb      = 4
    lun               = 1
  }
}

