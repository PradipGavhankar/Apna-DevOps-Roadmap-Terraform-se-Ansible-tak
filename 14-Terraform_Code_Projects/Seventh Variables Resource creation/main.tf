resource "azurerm_resource_group" "example" {

  count = var.resource_group.enabled ? 1 : 0

  name     = var.resource_group.name
  location = var.resource_group.location

}