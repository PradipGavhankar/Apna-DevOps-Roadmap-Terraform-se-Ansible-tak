first create subflders child module, parent or root module
step 2 create reources folder under child module and Envirnement folder under Envirnement
step3 resource folders like resource group, storage,vnet, subnet, nic, vm
step 4 Envirnement folders like dev, prod, qa, test
step 5 under dev envirnement create 4 files that is, main.tf,provider.tf,variables.tf and terraform.tfvars
dev main.tf used to call modules, provider.tf to define providers plugin and version of terraform, variables.tf to define variables used in terraform.tfvards files in key=value structure as per our need
in addition to that dev envirnement providers.tf include Backend block use to store terraform code state file on centralised container registry for everyones easy access.
for backend block manditory need of resource_group_name,storage_account_name,container_name and key(name of statefile for that envirnement)
  backend "azurerm" {
    resource_group_name            = "Pradip-RG"                       # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name             = "pradipstoragekhu"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name                   = "pradipconatiner"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                              = "pradip.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
once the backend block set in dev providers.tf, statefile will remove automatically from vs code and store in container as centralise access
main.tf and variables.tf is manditory files in every folders to define things to remove errors
Dev envirnement infra code writing should be starts from terraform.tfvars for easy unsersanding like
RG={
  "Resource-PG" = {
    name     = "Pradip-RG"
    location = "West Europe"
  }
}
Dev Envirnement variables need to be define as per terraform.tfvars
variable "RG" {}
#variable is a container, that store the value and we can use this value whenever we want

fir child block me azurerm_resource_group folder me main.tf me include 
resource "azurerm_resource_group" "Resource-PG" {
    for_each = var.RG
  name     = each.value.name #ye terrform.tfvars file se same hota hai, jo bhi value chiye usake liye
  location = each.value.location #ye terrform.tfvars file se same hota hai, jo bhi value chiye usake liye
}
Resource-PG is the block name, an it is the lable 2
/*
azurerm_resource_group is the resource type ham asure cloude pe resource group create kar rahe hai
azurerm_resouce_group label 1
{ jo bhi {} blacket ke andar ayega we sare arguuments hote hai
name me ham resource group ka name hota hai jo azure pe dikhata hai
*/
var.RG varibale ham child block ke main.tf file me use kar rahe hai to usaka variable variable.tf me defile kar denge
variable "RG" {}
#variable is a container, that store the value and we can use this value whenever we want
fir ham usi child module ko dev envirnement ke main.tf through call karenge as usng below code.
module "azurerm_resource_group" {
    source = "../../../Child module/Azurerm_Resource_group"
    RG = var.RG
  
}
ye sab basics resource ka logic sikhane ke liye hai fir hame data block k  use karana hota hai, ye data.tf file child block ke resource me banai jati hai. isaka uddesya portal se resource id ane ke liye hota hai
child module azurerm_nic folder me data.tf ka code
data "azurerm_subnet" "snet" {
  for_each=var.nic
  name                = each.value.subnet_name
  resource_group_name = each.value.resource_group_name
  virtual_network_name=each.value.virtual_network_name
}

data "azurerm_public_ip" "pip" {
  for_each=var.nic
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}
child module azurerm_nic folder me main.tf ka code
resource "azurerm_network_interface" "Pradip-nic" {
    for_each=var.nic
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration_name
   *** subnet_id                     = data.azurerm_subnet.snet[each.key].id
    private_ip_address_allocation = "Dynamic"
   *** public_ip_address_id=data.azurerm_public_ip.pip[each.key].id
  }
}
child module azurerm_nic folder me variable.tf ka code
variable"nic"{}

dev envirnment main.tf
module "azurerm_nic" {
    depends_on=[module.azurerm_subnet,module.public_ip]
    source = "../../../Child module/Azurerm_NIC"
    nic = var.nic
}
dev envirnement providers.tf as above
dev envirnement terraform.tfvars code
nic={
    nic1={
  nic_name                = "frontend-nic"
  location            = "West Europe"
  resource_group_name = "Pradip-RG"
  subnet_name="frontend-subnet"
  virtual_network_name="Pradip-Vnet"
  public_ip_name="frontend-pip"
ip_configuration_name="ip1"
}
    nic2={
  nic_name                = "backend-nic"
  location            = "West Europe"
  resource_group_name = "Pradip-RG"
  subnet_name="backend-subnet"
  virtual_network_name="Pradip-Vnet"
  public_ip_name="backend-pip"
ip_configuration_name="ip2"
}
}
dev envirnement variable.tf
variable "nic"{}
# 🚀 Terraform First Infrastructure Project (Azure) – Complete Beginner Guide

> **Author:** Pradip – DevOps & Cloud Learning Journey

---

# 📖 Introduction

This repository demonstrates an **Enterprise Terraform Folder Structure** used in real Azure DevOps projects.

Learning flow:

1. Create project folder
2. Create Child Modules
3. Create Environment folders
4. Configure Backend
5. Write Infrastructure in `terraform.tfvars`
6. Call Child Modules from Environment
7. Run `terraform init`
8. Run `terraform plan`
9. Run `terraform apply`
10. Destroy resources

---

# 🏗️ Enterprise Folder Structure

```text
Terraform-Project/
│
├── Child module/
│   ├── Azurerm_Resource_group/
│   ├── Azurerm_Storage/
│   ├── Azurerm_Vnet/
│   ├── Azurerm_Subnet/
│   ├── Azurerm_PIP/
│   ├── Azurerm_NIC/
│   └── Azurerm_VM/
│
└── Parent or root module/
    └── Envirment folder/
        ├── Dev/
        ├── QA/
        ├── Test/
        └── Prod/
```

---

# Step 1 – Create Child Modules

Create dedicated folders for every Azure resource.

- Resource Group
- Storage Account
- Virtual Network
- Subnet
- Public IP
- Network Interface
- Virtual Machine

Every child module contains:

- main.tf
- variables.tf
- outputs.tf (optional)
- data.tf (if required)

---

# Step 2 – Create Environment Folder

Create:

- Dev
- QA
- Test
- Prod

Each environment contains:

- provider.tf
- main.tf
- variables.tf
- terraform.tfvars

---

# Step 3 – Configure Backend

Example:

```hcl
backend "azurerm" {
  resource_group_name  = "Pradip-RG"
  storage_account_name = "pradipstoragekhu"
  container_name       = "pradipcontainer"
  key                  = "dev.terraform.tfstate"
}
```

Purpose:

- Centralized State
- Team Collaboration
- No local tfstate
- Production Best Practice

---

# Step 4 – Write Infrastructure in terraform.tfvars

Always start from terraform.tfvars.

Example:

```hcl
RG = {
 Resource-PG = {
   name="Pradip-RG"
   location="West Europe"
 }
}
```

---

# Step 5 – Declare Variables

variables.tf

```hcl
variable "RG" {}
```

Variables act as containers.

---

# Step 6 – Child Module

main.tf

```hcl
resource "azurerm_resource_group" "Resource-PG" {

  for_each = var.RG

  name     = each.value.name
  location = each.value.location

}
```

---

# Step 7 – Call Module

Environment main.tf

```hcl
module "azurerm_resource_group" {

 source="../../../Child module/Azurerm_Resource_group"

 RG=var.RG

}
```

---

# Step 8 – Data Block

Use data blocks whenever existing Azure resources are required.

Example:

```hcl
data "azurerm_subnet" "snet" {
 for_each=var.nic
 name=each.value.subnet_name
 resource_group_name=each.value.resource_group_name
 virtual_network_name=each.value.virtual_network_name
}
```

---

# Step 9 – NIC Example

Use IDs from Data Blocks.

```hcl
subnet_id=data.azurerm_subnet.snet[each.key].id
public_ip_address_id=data.azurerm_public_ip.pip[each.key].id
```

---

# Deployment Flow

terraform init

↓

terraform fmt

↓

terraform validate

↓

terraform plan

↓

terraform apply

↓

terraform destroy

---

# Good Practices

- Use Modules
- Use Variables
- Use Remote Backend
- Use Version Control
- Never Commit tfstate
- Use terraform fmt

---

# Bad Practices

- Hardcoding
- Local State in Team
- Manual Portal Changes
- No Backend
- Direct Production Apply

---

# Interview Tip

Infrastructure starts from terraform.tfvars.

Modules consume variables.

Resources consume variables.

Terraform creates Azure infrastructure.

🎉 Congratulations! आपका पहला Infrastructure as Code Project पूरा हुआ।