terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0.0" #Version number: major.minor.patch — yahan major=1, minor=5, patch=0
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true #Jab Terraform Key Vault ko destroy karega, toh sirf "soft delete" (recovery ke liye 90 din) nahi karega — completely permanently delete karega
    }
  }
}

