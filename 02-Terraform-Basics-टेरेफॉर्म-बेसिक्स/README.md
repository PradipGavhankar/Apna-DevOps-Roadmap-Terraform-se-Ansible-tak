# Terraform Basics – टेरेफॉर्म बेसिक्स (Azure Focus)

Terraform modern DevOps world में Azure infrastructure automation का एक powerful Infrastructure as Code (IaC) tool है।

Terraform is a powerful Infrastructure as Code (IaC) tool used to automate Azure infrastructure in modern DevOps environments.

---

## 🧠 Terraform क्या है?

Terraform एक open-source tool है जो हमें Azure cloud infrastructure को code के माध्यम से define, provision और manage करने की सुविधा देता है।

Terraform is an open-source tool that allows us to define, provision, and manage Azure cloud infrastructure using code.

मतलब Azure Resource Group, Virtual Machine, VNet — सब कुछ code से control कर सकते हैं।

That means Azure Resource Groups, Virtual Machines, and VNets can all be controlled using code.

---

## ❓ Azure में Terraform क्यों जरूरी है?

Azure Portal से manually resources create करना possible है…

लेकिन production environment में यह scalable नहीं है।

Creating resources manually from Azure Portal is possible,  
but it is not scalable in production environments.

अगर 20 VMs manually बनाओगे तो mistakes guaranteed हैं 😅

Terraform Azure infrastructure को:

- Repeatable बनाता है  
- Version controlled बनाता है  
- Automated बनाता है  
- Multi-environment ready बनाता है  

---

## 🔄 Terraform Workflow (Azure Context)

Terraform Azure के साथ 4 main steps में काम करता है:

### 1️⃣ terraform init

Azure provider download करता है।

Initializes the project and downloads the Azure provider.

---

### 2️⃣ terraform plan

Azure में कौन-कौन से resources create होंगे, उसका preview दिखाता है।

Shows what Azure resources will be created, modified, or destroyed.

(Production में यह step skip करना मतलब risk लेना 👀)

---

### 3️⃣ terraform apply

Azure subscription में actual resources create करता है।

Creates the actual resources inside the Azure subscription.

यही वो moment है जब bill भी शुरू हो सकता है 😎

---

### 4️⃣ terraform destroy

Azure resources delete करता है।

Destroys Azure resources.

Lab environment में best friend 😅

---

## 🗂️ Basic Azure Terraform File Structure

एक basic Azure Terraform project में ये files होती हैं:

- `provider.tf` → Azure provider configuration  
- `main.tf` → Azure resources definition  
- `variables.tf` → input variables  
- `outputs.tf` → output values  
- `terraform.tfvars` → variable values  

---

## 🌍 Modern Industry Sync (Azure DevOps Reality 2026)

आज Azure + Terraform use होता है:

- Azure Virtual Machine provisioning  
- Azure Kubernetes Service (AKS) automation  
- Azure DevOps CI/CD pipelines  
- Multi-region infrastructure deployment  
- Enterprise Landing Zone setup  

In enterprise Azure environments, Infrastructure as Code is mandatory.

---

## 🏗 Real-World Scenario (Azure Example)

मान लीजिए company को:

- Dev environment  
- Staging environment  
- Production environment  

तीनों में same infrastructure चाहिए।

Terraform के माध्यम से एक ही configuration से तीनों environment deploy किए जा सकते हैं।

Without Terraform?  
Portal में click-click-click marathon 😅

---

## 🧠 Quick Summary

- Terraform = Azure automation tool  
- Azure Portal = Manual method  
- Terraform = Scalable + Repeatable + DevOps friendly  
- 4 Commands = init, plan, apply, destroy  

---

## 😎 DevOps Reality Note

अगर Azure में अभी भी manually resources बना रहे हो…

तो Terraform सीखना जरूरी है —  
वरना future में सिर्फ resource group delete करने का काम मिलेगा 😅

---

# 🧪 उदाहरण: Azure में Resource Group बनाना (Step-by-Step)

## 🔹 1. हिन्दी में समझें

इस उदाहरण में हम Terraform की सहायता से Azure में एक Resource Group बनाएंगे।

Resource Group Azure में एक logical container होता है जिसमें हम Virtual Machine, Storage Account, Network आदि संसाधनों को रखते हैं।

Terraform क्या करेगा?

- Azure से जुड़ेगा
- Resource Group की configuration पढ़ेगा
- पहले बताएगा क्या बनने वाला है (Plan)
- फिर वास्तव में बना देगा (Apply)

---

## 🔹 2. Understand in English

In this example, we will create an Azure Resource Group using Terraform.

A Resource Group in Azure is a logical container that holds resources like Virtual Machines, Storage Accounts, and Networks.

Terraform will:

- Connect to Azure
- Read the configuration
- Show what will be created (Plan)
- Then actually create it (Apply)

---

## 🔹 3. Required Files and Code

---

### 📄 provider.tf

```hcl
# Terraform configuration block
terraform {

  # Required providers list
  required_providers {

    # Azure Resource Manager provider
    azurerm = {

      # Official HashiCorp provider source
      source  = "hashicorp/azurerm"

      # Version constraint (3.x versions allowed)
      version = "~> 3.0"
    }
  }
}

# Azure provider configuration
provider "azurerm" {

  # Mandatory empty block
  features {}
}
```

---

### 📄 variables.tf

```hcl
# Variable for Resource Group name
variable "resource_group_name" {

  # Description of variable
  description = "Azure Resource Group ka naam"

  # Data type string
  type = string
}

# Variable for Azure location
variable "location" {

  description = "Azure region jahan resource banega"

  type = string
}
```

---

### 📄 main.tf

```hcl
# Azure Resource Group creation block
resource "azurerm_resource_group" "rg" {

  # Name taken from variable
  name = var.resource_group_name

  # Location taken from variable
  location = var.location
}
```

---

### 📄 terraform.tfvars

```hcl
# Actual values provided here

resource_group_name = "rg-devops-demo"
location            = "Central India"
```

---

### 📄 outputs.tf

```hcl
# Output block to display Resource Group ID
output "resource_group_id" {

  value = azurerm_resource_group.rg.id
}
```

---

## 🔹 4. Terraform Commands

### Initialize project

```
terraform init
```

### See execution plan

```
terraform plan
```

Expected output example:

```
Plan: 1 to add, 0 to change, 0 to destroy.
```

Meaning:
- 1 new resource will be created
- No changes
- Nothing will be destroyed

### Apply configuration

```
terraform apply
```

### Destroy resources (if needed)

```
terraform destroy
```

---

## 🔹 5. What You Learned

✔ Terraform connects to Azure  
✔ Configuration files define infrastructure  
✔ Variables make code reusable  
✔ Plan shows preview  
✔ Apply creates resources  

---

