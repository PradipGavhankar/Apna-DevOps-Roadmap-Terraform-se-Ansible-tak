# Terraform Basics – टेरेफॉर्म बेसिक्स (Azure Focus)

Terraform modern DevOps world में Azure infrastructure automation का एक powerful Infrastructure as Code (IaC) tool है।

Terraform is a powerful Infrastructure as Code (IaC) tool used to automate Azure infrastructure in modern DevOps environments.

---

## 🧠 Terraform क्या है?

Terraform एक open-source Infrastructure as Code tool है जो हमें Azure cloud infrastructure को code के माध्यम से define, provision और manage करने की सुविधा देता है।

Terraform is an open-source Infrastructure as Code (IaC) tool that allows us to define, provision, and manage Azure cloud infrastructure using code.

मतलब Azure Resource Group, Virtual Machine, VNet — सब कुछ code से control कर सकते हैं।

---

## ❓ Azure में Terraform क्यों जरूरी है?

Azure Portal से manually resources create करना possible है…

लेकिन production environment में यह scalable नहीं है।

अगर 20 VMs manually बनाओगे तो mistakes guaranteed हैं 😅

Terraform Azure infrastructure को:

- Repeatable बनाता है  
- Version controlled बनाता है  
- Automated बनाता है  
- Multi-environment ready बनाता है  

---

# 🧱 Terraform Syntax & Block Structure

Terraform configuration **Blocks** और **Arguments** से मिलकर बनती है।

---

## 🔹 Block Structure (Basic Syntax)

```hcl
block_type "label1" "label2" {
  argument_name = value
}
```

Blocks infrastructure components define करते हैं।

---

## 🔹 Types of Blocks

### 1️⃣ Single Name Block

Used once per configuration file.

```hcl
terraform {
  required_version = ">= 1.0.0"
}
```

Purpose:
- Defines Terraform settings
- Specifies version constraints

---

### 2️⃣ Block with One Label

```hcl
provider "azurerm" {
  features {}
}
```

Explanation:
- `provider` → block type  
- `"azurerm"` → label  

Used to configure cloud providers.

---

### 3️⃣ Block with Two Labels

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "Central India"
}
```

Explanation:
- `resource` → block type  
- `"azurerm_resource_group"` → resource type  
- `"rg"` → user-defined name  

This is most commonly used block in Terraform.

---

## 🔹 Arguments

Arguments define properties inside blocks.

Example:

```hcl
name     = "rg-demo"
location = "Central India"
```

Argument Types:

- string  
- number  
- bool  
- list  
- map  
- set  

Arguments can be:
- Required  
- Optional  

---

## 🔄 Terraform Workflow (Azure Context)

Terraform Azure के साथ 4 main steps में काम करता है:

### 1️⃣ terraform init
- Initializes project  
- Downloads Azure provider  

### 2️⃣ terraform plan
- Preview दिखाता है क्या create / modify / destroy होगा  

### 3️⃣ terraform apply
- Azure subscription में actual resources create करता है  

### 4️⃣ terraform destroy
- Azure resources delete करता है  

---

## 🗂️ Basic Azure Terraform File Structure

A basic Azure Terraform project contains:

- `provider.tf` → Azure provider configuration  
- `main.tf` → Resource definitions  
- `variables.tf` → Input variables  
- `outputs.tf` → Output values  
- `terraform.tfvars` → Variable values  

---

# 🧪 Example: Azure Resource Group Creation (Step-by-Step)

## 🔹 provider.tf

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

---

## 🔹 variables.tf

```hcl
variable "resource_group_name" {
  description = "Azure Resource Group ka naam"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}
```

---

## 🔹 main.tf

```hcl
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
```

---

## 🔹 terraform.tfvars

```hcl
resource_group_name = "rg-devops-demo"
location            = "Central India"
```

---

## 🔹 outputs.tf

```hcl
output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}
```

---

## 🔹 Terraform Commands

### Initialize

```
terraform init
```

### Plan

```
terraform plan
```

Expected Output:

```
Plan: 1 to add, 0 to change, 0 to destroy.
```

### Apply

```
terraform apply
```

### Destroy

```
terraform destroy
```

---

## 🌍 Modern Industry Usage (Azure DevOps Reality)

Azure + Terraform commonly used for:

- Virtual Machine provisioning  
- Azure Kubernetes Service (AKS) automation  
- CI/CD pipelines  
- Multi-region deployments  
- Enterprise Landing Zones  

Infrastructure as Code is mandatory in enterprise environments.

---

## 🧠 Quick Summary

- Terraform = Azure automation tool  
- Terraform uses Blocks & Arguments  
- 3 Block Types = Single, One-label, Two-label  
- Core Commands = init, plan, apply, destroy  
- Makes infrastructure scalable & repeatable  

---

## 😎 DevOps Reality Note

अगर Azure में अभी भी manually resources बना रहे हो…

तो Terraform सीखना जरूरी है 😄  
DevOps world में automation ही future है।