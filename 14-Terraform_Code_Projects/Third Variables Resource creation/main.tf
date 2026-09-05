resource "azurerm_resource_group" "example" {

  count = var.vm_count

  name     = "Pradip-RG-${count.index + 1}"
  location = "West Europe"

}