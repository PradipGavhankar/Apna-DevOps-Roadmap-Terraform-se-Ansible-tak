# 05 – Terraform State Management + Remote Backend
**Local State | Remote Backend | State Locking | Best Practices**

---

## 🎯 Goal

Terraform State ka complete production-level understanding + Azure Remote Backend setup.

---

## 1️⃣ Terraform State Kya Hai?

Terraform har resource ka mapping `terraform.tfstate` file me rakhta hai.

Is file se Terraform jaanta hai:
- Kaunse resources already exist karte hain
- Unki current configuration kya hai
- Kya change karna hai (plan)

---

## 2️⃣ Local State vs Remote State

| Type          | Location              | Team Use | Locking | Production |
|---------------|-----------------------|----------|---------|------------|
| Local State   | Local disk            | ❌       | ❌      | ❌         |
| Remote State  | Azure Storage / S3    | ✅       | ✅      | ✅         |

**Rule:** Production me hamesha **Remote Backend** use karo.

---

## 3️⃣ Azure Remote Backend Setup (Recommended)

### Step 1: Storage Account + Container banao (one-time)

```bash
# Resource Group
az group create --name tfstate-rg --location westeurope

# Storage Account (name globally unique hona chahiye)
az storage account create \
  --name tfstatepaymentprod \
  --resource-group tfstate-rg \
  --sku Standard_LRS \
  --encryption-services blob

# Container
az storage container create \
  --name tfstate \
  --account-name tfstatepaymentprod
```

### Step 2: backend.tf

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatepaymentprod"
    container_name       = "tfstate"
    key                  = "payment/prod.terraform.tfstate"
  }
}
```

### Step 3: Initialize

```bash
terraform init
```

Agar pehle local state tha to Terraform migrate karne ko kahega → `yes` bol dena.

---

## 4️⃣ State Locking

Azure Blob Storage automatically **lease-based locking** provide karta hai.

Iska fayda:
- Do log ek saath `terraform apply` nahi chala sakte
- State corruption se bachav

---

## 5️⃣ Useful State Commands

```bash
terraform state list
terraform state show azurerm_resource_group.main
terraform state pull > backup.tfstate
terraform state mv <old> <new>
terraform state rm <resource>
```

---

## 6️⃣ Partial Backend Config (CI/CD friendly)

```hcl
terraform {
  backend "azurerm" {}
}
```

Aur CI/CD me:

```bash
terraform init \
  -backend-config="resource_group_name=tfstate-rg" \
  -backend-config="storage_account_name=tfstatepaymentprod" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=payment/dev.tfstate"
```

---

## ✅ Production Best Practices

- Har environment ka alag state file (`dev.tfstate`, `prod.tfstate`)
- State file ko kabhi Git me mat daalo (`.gitignore` me `*.tfstate*`)
- Regular state backup lo
- `prevent_destroy` critical resources pe lagao
- Access control (RBAC) Storage Account pe tight rakho

---

## ❌ Common Mistakes

- Local state ko production me use karna
- State file ko GitHub pe push kar dena
- Ek hi state file me saare environments rakhna
- Lock ignore karke force unlock karna (sirf emergency me)

---

## 🎯 Interview Questions

**Q1. Terraform State kya hota hai?**  
Terraform ka database jo real infrastructure aur code ke beech mapping rakhta hai.

**Q2. Remote Backend kyun zaroori hai?**  
Team collaboration + State locking + Security + Backup.

**Q3. Azure me State locking kaise hota hai?**  
Blob lease mechanism se.

---

## 📌 Author
**Pradip Gavhankar**  
*DevOps | Cloud | DevSecOps Learning Journey*
```
