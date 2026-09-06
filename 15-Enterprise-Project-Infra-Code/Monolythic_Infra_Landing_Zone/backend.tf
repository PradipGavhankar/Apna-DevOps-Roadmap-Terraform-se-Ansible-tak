terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatepradip001"
    container_name       = "tfstate"
    key                  = "monolithic/dev.terraform.tfstate"
  }
}