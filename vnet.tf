resource "azurerm_virtual_network" "dcavnet" {
  name                = var.vnetname
  location            = azurerm_resource_group.dcarg.location
  resource_group_name = azurerm_resource_group.dcarg.name
  address_space       = ["172.16.0.0/16"]


  tags = {
    environment = "Test"
  }

    depends_on = [ azurerm_resource_group.dcarg ]

}

resource "azurerm_subnet" "public" {
    name = "public1"
    resource_group_name = azurerm_resource_group.dcarg.name
    virtual_network_name = azurerm_virtual_network.dcavnet.name
    address_prefixes = ["172.16.100.0/24"]

    depends_on = [ azurerm_resource_group.dcarg,azurerm_virtual_network.dcavnet ]
}