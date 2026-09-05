resource "azurerm_resource_group" "example" {

  name     = "Pradip-RG"
  location = "West Europe"

  tags = var.tags
}