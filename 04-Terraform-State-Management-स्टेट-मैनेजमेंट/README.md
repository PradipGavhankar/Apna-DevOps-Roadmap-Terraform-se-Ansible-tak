# Terraform State Management

---

# 🟢 पहले हिन्दी में आसान समझ

Terraform state file एक ऐसी file है जो Terraform को बताती है कि कौन-कौन से resources पहले से create हो चुके हैं।

अगर state file ना हो तो Terraform हर बार नया resource बना देगा।

State file = Terraform की memory 🧠

---

# 🔵 English Explanation

Terraform uses a state file (`terraform.tfstate`) to:

- Track created resources
- Map real infrastructure with configuration
- Detect changes
- Plan updates safely

Without state, Terraform cannot manage infrastructure properly.

---

# 🧱 Simple Example (State File Concept)

After running:

```
terraform apply
```

Terraform creates:

```
terraform.tfstate
```

This file contains:

- Resource IDs
- Metadata
- Dependencies
- Current infrastructure snapshot

---

# 🚀 Real Output Example

```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

State file updated automatically.

---

# 🌍 Local vs Remote State

## 🟢 हिन्दी में

Local state:
- Laptop में store होती है
- Team environment के लिए unsafe

Remote state:
- Cloud storage में store होती है
- Team collaboration safe बनाती है

---

## 🔵 English

Local backend:
- Stored on local machine
- Not safe for teams

Remote backend:
- Stored in shared storage
- Enables locking & collaboration

---

# ☁ Remote Backend – Azure Storage

## 🧱 Example Configuration

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "tfstateprod001"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

---

# 🚀 Backend Initialization

```
terraform init
```

Output:

```
Successfully configured the backend "azurerm"
```

---

# ✅ Good Practice

✔ Always use remote backend in production  
✔ Enable state locking  
✔ Secure storage account  
✔ Use separate state per environment  

---

# ❌ Bad Practice

❌ State file GitHub में push करना  
❌ Local state in team project  
❌ Same state file for all environments  

---

# 😂 DevOps Comedy

State file delete कर दिया?

Terraform बोलेगा:
"Achha sab dobara banau kya?" 😅

---

# 🔥 Production Mindset

✔ Use Azure Storage backend  
✔ Enable blob versioning  
✔ Restrict access with RBAC  
✔ Never expose state publicly