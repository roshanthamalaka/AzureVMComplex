resource "azurerm_network_security_group" "dcasg" {
  name                = "AllowSSH"
  location            = azurerm_resource_group.dcarg.location
  resource_group_name = azurerm_resource_group.dcarg.name

  security_rule {
    name                       = "SSH_Allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Test"
  }

  depends_on = [ azurerm_resource_group.dcarg ]
}