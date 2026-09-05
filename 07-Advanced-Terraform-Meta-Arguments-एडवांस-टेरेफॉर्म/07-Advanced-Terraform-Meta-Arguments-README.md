# 07 – Advanced Terraform Meta-Arguments
**depends_on | lifecycle | dynamic blocks | Advanced for_each**

---

## 🎯 Goal

Is section me aap Terraform ke **advanced meta-arguments** seekhenge jo production-grade code likhne ke liye mandatory hain.

Topics covered:
- `depends_on`
- `lifecycle` blocks
- `dynamic` blocks
- Advanced `for_each` + Modules patterns

---

## 1️⃣ depends_on

### Kya hai?

`depends_on` explicit dependency create karta hai jab Terraform automatic dependency detect nahi kar pata.

### Kab use karein?

- Resource A banne ke baad hi Resource B banana hai
- Implicit dependency nahi bani (jaise data source ya null_resource)

### Example (Azure)

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  # Explicit dependency (optional here because already implicit)
  depends_on = [azurerm_resource_group.rg]
}
```

### Production Tip
Jitna possible ho **implicit dependency** (reference through attributes) use karo.  
`depends_on` sirf tab use karo jab bilkul zaroori ho.

---

## 2️⃣ lifecycle Blocks

`lifecycle` resource ke create / update / destroy behaviour ko control karta hai.

### Common Meta-Arguments

| Argument                  | Use Case                                      |
|---------------------------|-----------------------------------------------|
| `create_before_destroy`   | Zero-downtime updates                         |
| `prevent_destroy`         | Production resources ko galti se delete hone se bachana |
| `ignore_changes`          | Kuch attributes ko Terraform ignore karwana   |

### Example 1: prevent_destroy (Production Safety)

```hcl
resource "azurerm_resource_group" "prod" {
  name     = "rg-payment-prod"
  location = "West Europe"

  lifecycle {
    prevent_destroy = true
  }
}
```

Agar koi `terraform destroy` karega to error aayega.

### Example 2: create_before_destroy

```hcl
resource "azurerm_network_interface" "nic" {
  name                = "nic-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  lifecycle {
    create_before_destroy = true
  }
}
```

### Example 3: ignore_changes

```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  # ... other config ...

  lifecycle {
    ignore_changes = [
      tags["LastModified"],
      custom_data
    ]
  }
}
```

---

## 3️⃣ dynamic Blocks

`dynamic` block se aap nested blocks ko programmatically generate kar sakte ho (jaise multiple security rules, multiple ip_configurations).

### Example: Multiple NSG Rules

```hcl
variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
```

---

## 4️⃣ Advanced for_each + Modules Pattern

### Module + for_each (Recommended Production Pattern)

```hcl
module "resource_groups" {
  source   = "./modules/resource-group"
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
  tags     = merge(var.common_tags, each.value.tags)
}
```

### Nested for_each Example

```hcl
resource "azurerm_subnet" "subnets" {
  for_each = {
    for item in local.subnet_list : "${item.vnet}-${item.name}" => item
  }

  name                 = each.value.name
  resource_group_name  = each.value.rg
  virtual_network_name = each.value.vnet
  address_prefixes     = [each.value.prefix]
}
```

---

## ✅ Good Practices

- `prevent_destroy = true` production critical resources pe lagao
- `depends_on` sirf jab bilkul zaroori ho
- `dynamic` blocks ko readable rakho (bohot nested mat banao)
- Module + `for_each` ko prefer karo multiple similar resources ke liye

---

## ❌ Bad Practices

- Har jagah `depends_on` laga dena
- `ignore_changes` ka overuse
- `dynamic` blocks se code unreadable bana dena

---

## 🎯 Interview Questions

**Q1. depends_on kab use karte hain?**  
Jab Terraform automatic dependency detect nahi kar pata.

**Q2. prevent_destroy ka kya use hai?**  
Production resources ko accidental destroy se bachana.

**Q3. dynamic block kab use karte hain?**  
Jab nested blocks ki quantity runtime pe decide hoti hai (NSG rules, multiple disks, etc.).

---

## 📌 Author
**Pradip Gavhankar**  
*DevOps | Cloud | DevSecOps Learning Journey*
```
