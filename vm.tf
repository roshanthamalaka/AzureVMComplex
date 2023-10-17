#Create Public IP address 

resource "azurerm_public_ip" "pubip" {
  name                = var.publicipname
  resource_group_name = azurerm_resource_group.dcarg.name
  location            = azurerm_resource_group.dcarg.location
  allocation_method   = "Dynamic"
  
}

#Create Network Interface and associate Public IP 
resource "azurerm_network_interface" "dcavmint" {
  name                = "dcavm-int"
  location            = azurerm_resource_group.dcarg.location
  resource_group_name = azurerm_resource_group.dcarg.name

  ip_configuration {
    name                          = var.vmname
    subnet_id = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
}

#Association Security Group with the Network Interface 
resource "azurerm_network_interface_security_group_association" "ngsassoc" {
  network_interface_id      = azurerm_network_interface.dcavmint.id
  network_security_group_id = azurerm_network_security_group.dcasg.id
}




resource "azurerm_virtual_machine" "main" {
  name                  = var.vmname
  location              = azurerm_resource_group.dcarg.location
  resource_group_name   = azurerm_resource_group.dcarg.name
  network_interface_ids = [azurerm_network_interface.dcavmint.id]
  vm_size               = "Standard_B1s"

  
  

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  #Enable Boot Diagnostics
  boot_diagnostics {
    enabled = true
    storage_uri = azurerm_storage_account.bdg.primary_blob_endpoint
  }

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "mydockervm"
    admin_username = "roshan"
    admin_password = "Thamalaka@1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }




  tags = {
    environment = "testing"
  }

   

  /*provisioner "remote-exec" {
      
    inline = [
            "sudo apt-get update",
            "sudo apt-get install ca-certificates curl gnupg -y",
            "sudo install -m 0755 -d /etc/apt/keyrings -y",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
            "sudo chmod a+r /etc/apt/keyrings/docker.gpg",

            # Add the repository to Apt sources:
            "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
            "sudo apt-get update",

            "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"


    ]

    connection {
    type     = "ssh"
    user     = "roshan"
    password = "Thamalaka@1234"
    host     = azurerm_public_ip.pubip.ip_address
   }


  }*/



  depends_on = [ azurerm_network_interface.dcavmint,azurerm_public_ip.pubip,azurerm_storage_account.bdg ]
}


