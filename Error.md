# Error 1
```
Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Invalid provider configuration
│ 
│ Provider "registry.terraform.io/hashicorp/azurerm" requires explicit configuration. Add a provider block to the root module and configure
│ the provider's required arguments as described in the provider documentation.
│ 
╵
╷
│ Error: Missing required argument
│ 
│   with provider["registry.terraform.io/hashicorp/azurerm"],
│   on <empty> line 0:
│   (source code not available)
│ 
│ The argument "features" is required, but no definition was found.
```
# Reason=> No Provider Block in provider.tf
Bhai, error ka main reason simple hai: root module mein azurerm provider configure nahi ho raha, isliye Terraform ko features {} nahi mil raha.

## 🔴 Error ka meaning
Provider "azurerm" requires explicit configuration

aur:

The argument "features" is required, but no definition was found.

```
provider "azurerm" {
  features {}
}
```
## ✅ Agar tum module use kar rahe ho

Root / Environment (dev/provider.tf) mein:
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}


provider "azurerm" {
  features {}
}
```
Phir module:

## ⚠️ Important

Child module ke andar normally provider block mat rakho:

# ❌ Avoid this in child module
provider "azurerm" {
  features {}
}

Provider configuration root/environment module se child module ko inherit honi chahiye.

## 🚀 Ab commands

Environment folder ke andar run karo:

terraform fmt
terraform init -upgrade
terraform validate
terraform plan

Agar terraform init ke baad bhi same error aaye, check karo:

terraform providers

Isse pata chalega Terraform kaunsa azurerm provider root aur child modules mein use kar raha hai.

One-line rule yaad rakho:

## 🧠 required_providers tells Terraform WHICH provider to use; provider "azurerm" tells Terraform HOW to configure it.
---------------------------------------------------------