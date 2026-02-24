# 🚀 DevOps Terraform Roadmap – 5 Core Modules (Hinglish Edition)

---

# 📦 Module 1 – Provider aur Resource Group

## 🟢 पहले हिन्दी में आसान समझ

Terraform ek Infrastructure as Code tool hai jisse hum Azure me resources code se bana sakte hain.

Is module me hum:
- Azure provider configure karenge
- Ek Resource Group create karenge

Matlab: Portal se nahi, code se infrastructure banega 💪

---

## 🔵 English Explanation

Terraform is an Infrastructure as Code tool used to provision Azure resources using code.

In this module:
- We configure the Azure provider
- Create a Resource Group

---

## 🧱 Simple Code (Hindi Comments)

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"  # version constraint lagana zaruri hai
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-demo"  # resource group ka naam
  location = "East US"         # region
}
```

---

## ✅ Good Practice

- Version constraint lagao  
- Naming standard follow karo  
- Code Git me rakho  

---

## ❌ Bad Practice

- Version specify na karna  
- Random naam rakh dena  
- Portal se manually change karna  

---

## 😂 Thoda DevOps Comedy

Junior: "Sir portal se bana du?"  
Senior: "Nahi beta, warna Terraform bolega – mujhe kyun laaye ho 😄"

---

## 🚀 Real Output Example

```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## ✅ Good Practice (Production Ready Mindset)

✔ Always use version constraint  
✔ Variables use karo, hardcoding mat karo  
✔ terraform plan production me mandatory  
✔ Remote backend use karo  

---

## ❌ Bad Practice (Danger Zone)

❌ Hardcoded subscription ID  
❌ Direct apply in production  
❌ No version control  
❌ Portal se manually change karna  

---

# 🌐 Module 2 – Variables aur Outputs

## 🟢 पहले हिन्दी में आसान समझ

Variables use karne se code flexible aur reusable ban jata hai.

Output se hum resource ki info dekh sakte hain.

---

## 🔵 English Explanation

Variables make Terraform configurations reusable and flexible.

Outputs display resource values after execution.

---

## 🧱 Simple Code (Hindi Comments)

```hcl
variable "location" {
  description = "Azure region"
  default     = "East US"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-demo"
  location = var.location   # yaha variable use kiya gaya hai
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}
```

---

## ✅ Good Practice

- Variables alag file me rakho  
- Sensitive values hide karo  
- tfvars file use karo  

---

## ❌ Bad Practice

- Sab kuch hardcode kar dena  
- Password Git me daal dena  

---

## 😂 DevOps Comedy

"Har project me region change karna pad raha hai 😩"  
"Kyunki tumne variable use hi nahi kiya 😄"

---

## 🚀 Real Output Example

```
Outputs:
rg_name = rg-devops-demo
```

---

## ✅ Good Practice (Production Ready Mindset)

✔ Variables use karo hardcoding mat karo  
✔ terraform plan production me mandatory  
✔ Version constraint lagao  

---

## ❌ Bad Practice (Danger Zone)

❌ Hardcoded values  
❌ Direct apply in production  
❌ No version control  

---

# 🧠 Module 3 – Terraform State aur Remote Backend

## 🟢 पहले हिन्दी में आसान समझ

State file batati hai ki actual cloud me kya bana hua hai.

Team environment me state ko local machine pe nahi, remote backend me rakhna chahiye.

---

## 🔵 English Explanation

Terraform state tracks real infrastructure.

Remote backend is required for team collaboration.

---

## 🧱 Simple Code (Hindi Comments)

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
- State secure rakho  
- Team me state lock enable karo  

---

## ❌ Bad Practice

- Local state team me use karna  
- State file GitHub me push karna  

---

## 😂 DevOps Comedy

"State file delete ho gayi 😭"  
"Ab Terraform bhi bolega – main kya karu bhai 😄"

---

## 🚀 Real Output Example

```
Successfully configured the backend "azurerm"
```

---

## ✅ Good Practice (Production Ready Mindset)

✔ State file Git me commit mat karo  
✔ Remote backend mandatory  
✔ terraform plan production me mandatory  

---

## ❌ Bad Practice (Danger Zone)

❌ State file GitHub me push karna  
❌ Direct apply in production  
❌ No version control  

---

# 🏗 Module 4 – Terraform Modules

## 🟢 पहले हिन्दी में आसान समझ

Modules reusable blocks hote hain.

Isse code clean, structured aur professional ban jata hai.

---

## 🔵 English Explanation

Modules help structure and reuse Terraform configurations.

---

## 🧱 Simple Code (Hindi Comments)

```hcl
module "rg" {
  source   = "./modules/resource_group"
  name     = "rg-devops"
  location = "East US"
}
```

---

## ✅ Good Practice

- Code ko modules me divide karo  
- Proper folder structure rakho  
- Reusable design rakho  

---

## ❌ Bad Practice

- Sab kuch ek hi file me likh dena  
- Copy paste karte rehna  

---

## 😂 DevOps Comedy

"Module kyun banaun?"  
"Taaki future me khud ko gaali na deni pade 😄"

---

## 🚀 Real Output Example

```
module.rg.azurerm_resource_group.rg: Creation complete
```

---

## ✅ Good Practice (Production Ready Mindset)

✔ Modular architecture use karo  
✔ Version control maintain karo  
✔ terraform plan production me mandatory  

---

## ❌ Bad Practice (Danger Zone)

❌ No version control  
❌ Direct apply in production  
❌ Portal se manually change karna  

---

# 🤖 Module 5 – Terraform + Ansible Integration

## 🟢 पहले हिन्दी में आसान समझ

Terraform infrastructure banata hai.  
Ansible server configuration karta hai.

Dono ka role alag hai, mix mat karo.

---

## 🔵 English Explanation

Terraform provisions infrastructure.

Ansible configures servers after provisioning.

---

## 🧱 Simple Flow Example (Hindi Comments)

```bash
terraform apply         # pehle infrastructure banega
ansible-playbook site.yml   # phir configuration hogi
```

---

## ✅ Good Practice

- Infra aur configuration alag rakho  
- Manual SSH avoid karo  
- Automation complete rakho  

---

## ❌ Bad Practice

- Terraform se software install karna  
- Ansible se VM create karna  
- Manual server changes  

---

## 😂 DevOps Comedy

"Terraform se nginx install karu?"  
"Role clarity naam ki bhi koi cheez hoti hai 😄"

---

## 🚀 Real Output Example

```
PLAY RECAP
server1 : ok=5 changed=2 failed=0
```

---

# 🏁 Final DevOps Rule

Automation + Version Control + Review Process  
= Safe Production Infrastructure 🚀