resource "azurerm_resource_group" "RG" {
  name     = "Pradip-RG"
  location = "Central India"
}

resource "azurerm_public_ip" "example" {
  count = var.enable_public_ip ? 1 : 0

  name                = "${azurerm_resource_group.RG.name}-Public-IP"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location

  allocation_method = "Static"
  sku               = "Standard"
}