resource "azurerm_resource_group" "example" {

  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location

}