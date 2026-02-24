# 📦 Module 1 – Terraform Basics (Provider + Resource Group)

---

## 🟢 पहले हिन्दी में आसान समझ

Terraform ek Infrastructure as Code tool hai jisse hum cloud resources code ke through bana sakte hain.

Is module me hum:

- Provider configure karenge
- Resource Group create karenge

---

## 🔵 English Explanation

Terraform allows you to provision infrastructure using code.

In this module:

- We configure Azure provider
- Create a Resource Group

---

## 🧱 Simple Code (Hindi Comments)

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0" # version constraint
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-demo"   # resource group ka naam
  location = "East US"          # region
}
```

---

## ✅ Good Practice

- Version constraint use karo
- Naming standard follow karo
- Code ko Git me maintain karo

---

## ❌ Bad Practice

- Version specify na karna
- Hardcoded random names
- Manual portal changes

---

## 😂 Thoda DevOps Comedy

Junior: "Sir portal se bana du?"

Senior: "Nahi beta, warna Terraform ro dega 😆"

---

## 🚀 Real Output Example

```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## ✅ Production Ready Mindset

✔ Always use version constraint  
✔ Variables use karo  
✔ terraform plan production me mandatory  
✔ Remote backend use karo  

## ❌ Danger Zone

❌ Hardcoded subscription ID  
❌ Direct apply in production  
❌ No version control  

# 🌐 Module 2 – Variables & Outputs

---

## 🟢 पहले हिन्दी में आसान समझ

Variables se hum reusable aur flexible code likhte hain.

---

## 🔵 English Explanation

Variables make Terraform configurations reusable and dynamic.

---

## 🧱 Simple Code (Hindi Comments)

```hcl
variable "location" {
  description = "Azure region"
  default     = "East US"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-demo"
  location = var.location   # variable use kiya
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}
```

---

## ✅ Good Practice

- Variables file separate rakho
- Sensitive data mark karo

---

## ❌ Bad Practice

- Hardcoded region
- Secrets plain text me

---

## 😂 DevOps Comedy

"Code reusable nahi hai?"

"Kyuki tumne sab hardcode kiya hai bhai 😆"

---

## 🚀 Real Output

```
Outputs:
rg_name = rg-devops-demo
```

---

## ✅ Production Ready Mindset

✔ Variables use karo  
✔ Secrets ke liye tfvars use karo  
✔ Plan before apply  

## ❌ Danger Zone

❌ Password Git me push karna  
❌ Hardcoded values  

# 🧠 Module 3 – State Management

---

## 🟢 पहले हिन्दी में आसान समझ

Terraform state file infrastructure ki actual condition store karti hai.

---

## 🔵 English Explanation

Terraform state keeps track of real infrastructure.

---

## 🧱 Simple Code

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-backend"
    storage_account_name = "tfstate12345"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

---

## ✅ Good Practice

- Remote backend use karo
- State lock enable karo

---

## ❌ Bad Practice

- Local state use in team
- State file Git me commit karna

---

## 😂 DevOps Comedy

"State file delete ho gayi 😭"

"Ab terraform bhi confuse hai aur tum bhi 😆"

---

## 🚀 Real Output

```
Successfully configured the backend "azurerm"
```

---

## ✅ Production Ready Mindset

✔ Remote backend mandatory  
✔ State ko secure rakho  

## ❌ Danger Zone

❌ State GitHub me push karna  
❌ Local laptop pe production state  

# 🏗 Module 4 – Modules

---

## 🟢 पहले हिन्दी में आसान समझ

Modules reusable Terraform blocks hote hain.

---

## 🔵 English Explanation

Modules allow reusable and structured Terraform code.

---

## 🧱 Simple Code

```hcl
module "rg" {
  source   = "./modules/resource_group"
  name     = "rg-devops"
  location = "East US"
}
```

---

## ✅ Good Practice

- Reusable modules banao
- Folder structure maintain karo

---

## ❌ Bad Practice

- Sab code ek hi file me likhna
- Copy paste repetition

---

## 😂 DevOps Comedy

"Module use nahi karunga."

"Fir har project me copy paste karte rehna 😆"

---

## 🚀 Real Output

```
module.rg.azurerm_resource_group.rg: Creation complete
```

---

## ✅ Production Ready Mindset

✔ Modular architecture  
✔ Versioned modules  

## ❌ Danger Zone

❌ Repeated code  
❌ No structure  

# 🤖 Module 5 – Terraform + Ansible Integration

---

## 🟢 पहले हिन्दी में आसान समझ

Terraform infra banata hai.  
Ansible configuration karta hai.

---

## 🔵 English Explanation

Terraform provisions infrastructure.  
Ansible configures servers.

---

## 🧱 Simple Flow Example

```bash
terraform apply
ansible-playbook playbook.yml
```

---

## ✅ Good Practice

- Clear separation of responsibilities
- Inventory dynamic rakho

---

## ❌ Bad Practice

- Terraform se configuration karna
- Ansible se infra banana

---

## 😂 DevOps Comedy

"Terraform se package install kar raha ho?"

"Role confuse ho gaya kya? 😆"

---

## 🚀 Real Output

```
PLAY RECAP
server1 : ok=5 changed=2 failed=0
```

---

## ✅ Production Ready Mindset

✔ Infra + Config separation  
✔ CI/CD integration  

## ❌ Danger Zone

❌ Manual SSH changes  
❌ No automation  

