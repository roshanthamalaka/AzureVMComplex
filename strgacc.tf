resource "azurerm_storage_account" "bdg" {
  name                     = "dcabdstrgacc"
  resource_group_name      = azurerm_resource_group.dcarg.name
  location                 = azurerm_resource_group.dcarg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}