# Advanced Terraform Concepts

---

# 🟢 Lifecycle Meta Arguments (Hindi)

Lifecycle block resource behavior control करता है।

Example:
- Resource destroy होने से बचाना
- Replace order control करना
- Changes ignore करना

---

# 🔵 English Explanation

Lifecycle meta-arguments modify resource behavior.

Used inside resource block.

---

# 🧱 Example

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "Central India"

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
    ignore_changes = [ tags ]
  }
}
```

---

# 🔍 Explanation

- prevent_destroy → Resource accidental delete से बचाता है  
- create_before_destroy → Zero downtime replacement  
- ignore_changes → Certain changes ignore करता है  

---

# 🚀 Real Output Example

If destroy attempted:

```
Error: Instance cannot be destroyed
```

Because prevent_destroy = true

---

# 🧠 Dependency Graph

Terraform automatically builds dependency graph.

Example:

VM depends on:
- Resource Group
- Network Interface
- VNet

Terraform internally calculates order.

---

# 🧱 Manual Dependency Example

```hcl
resource "azurerm_virtual_machine" "vm" {
  depends_on = [
    azurerm_resource_group.rg
  ]
}
```

---

# 🚀 Graph Command

```
terraform graph
```

Generates dependency graph.

---

# ✅ Good Practice (Production Ready Mindset)

✔ Always use version constraint  
✔ Variables use करो hardcoding मत करो  
✔ terraform plan production में mandatory  
✔ Use remote backend  
✔ Use lifecycle protection for critical resources  

---

# ❌ Bad Practice (Danger Zone)

❌ Hardcoded subscription ID  
❌ Direct apply in production  
❌ No version control  
❌ Portal से manually change करना  

---

# 😂 DevOps Reality

Production में resource delete कर दिया?

Manager:
"Backup hai na?"

DevOps:
"Lifecycle block laga dete तो अच्छा रहता…" 😅