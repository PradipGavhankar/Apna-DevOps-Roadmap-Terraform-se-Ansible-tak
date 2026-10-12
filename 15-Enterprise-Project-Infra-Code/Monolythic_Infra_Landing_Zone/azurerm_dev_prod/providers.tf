terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0.0" #Version number: major.minor.patch — yahan major=1, minor=5, patch=0
    }
  }
}
