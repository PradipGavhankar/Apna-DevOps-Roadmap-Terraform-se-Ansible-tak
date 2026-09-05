# 08 – Terraform Workspaces
**Multiple Environments with Same Code**

---

## 🎯 Goal

Ek hi Terraform code se multiple environments (dev / qa / prod) manage karna using Workspaces.

---

## 1️⃣ Workspace Kya Hai?

Workspace = alag state file same configuration ke liye.

Default workspace: `default`

---

## 2️⃣ Basic Commands

```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new dev
terraform workspace new qa
terraform workspace new prod

# Switch workspace
terraform workspace select dev

# Show current workspace
terraform workspace show

# Delete workspace (empty hona chahiye)
terraform workspace delete qa
```

---

## 3️⃣ Practical Example

```hcl
locals {
  environment = terraform.workspace

  name_prefix = "${var.project_name}-${terraform.workspace}"
}

resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.location

  tags = {
    Environment = terraform.workspace
    ManagedBy   = "terraform"
  }
}
```

Ab:
- `terraform workspace select dev` → `payment-dev-rg`
- `terraform workspace select prod` → `payment-prod-rg`

---

## 4️⃣ Workspace + Remote Backend

Remote Backend ke saath har workspace ka alag state file automatically ban jata hai.

Example key structure:
```
payment/dev.terraform.tfstate
payment/qa.terraform.tfstate
payment/prod.terraform.tfstate
```

---

## 5️⃣ Kab Use Karein / Kab Na Karein

### ✅ Achha use-case
- Chhote projects
- Same code, thode different variables
- Quick environment switching

### ❌ Avoid
- Bohot alag infrastructure (alag modules better hain)
- Complex multi-account / multi-subscription setups
- Large teams (separate folders + separate state better hota hai)

---

## ✅ Best Practices

- Workspace name ko resource naming me use karo
- `terraform.workspace` ko locals me store karo
- Production workspace ko protect karo (policy / pipeline)

---

## 🎯 Interview Questions

**Q1. Terraform Workspace kya hota hai?**  
Same configuration ke multiple independent state files.

**Q2. Default workspace ka naam kya hai?**  
`default`

**Q3. Workspace vs Separate Folders?**  
Chhote projects → Workspace  
Bade / complex projects → Separate directories + separate backends

---

## 📌 Author
**Pradip Gavhankar**  
*DevOps | Cloud | DevSecOps Learning Journey*
```
