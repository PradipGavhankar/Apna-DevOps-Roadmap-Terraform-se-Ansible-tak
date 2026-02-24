# Terraform Functions – टेरफॉर्म फंक्शन (Azure Focus)

---

## 🔹 1. हिन्दी में समझें

अब तक हमने एक ही Resource बनाया।

लेकिन वास्तविक प्रोजेक्ट में हमें:

- कई Virtual Machines बनानी होती हैं
- अलग-अलग नाम देने होते हैं
- Environment (Dev / Prod) के अनुसार बदलाव करना होता है

यह सब करने के लिए Terraform में Functions और Expressions का उपयोग किया जाता है।

Functions की सहायता से हम:

- Text बदल सकते हैं
- Multiple resources बना सकते हैं
- Conditions लगा सकते हैं
- Code को intelligent बना सकते हैं

---

## 🔹 2. Understand in English

Until now, we created only one resource.

In real-world Azure projects, we often need:

- Multiple virtual machines
- Dynamic naming
- Environment-based configurations

Terraform Functions and Expressions help us:

- Manipulate strings
- Create multiple resources
- Apply conditions
- Make infrastructure dynamic

---

# 🧪 Example 1: count (Multiple Resources)



यदि हमें 3 Resource Groups बनाने हों, तो हम `count` का उपयोग कर सकते हैं।



If we want to create 3 Resource Groups, we can use the `count` argument.

---

### 📄 main.tf

```hcl
resource "azurerm_resource_group" "rg" {

  # count का मतलब कितनी बार resource बनेगा
  count = 3

  # प्रत्येक Resource Group का नाम अलग होगा
  name = "rg-demo-${count.index}"

  location = "Central India"
}
```

### समझें

- count = 3 → 3 बार resource बनेगा
- count.index → 0, 1, 2

Azure में बनेगा:
- rg-demo-0
- rg-demo-1
- rg-demo-2

---

# 🧪 Example 2: Variables with Default Value


यदि हम variable को default value देना चाहें तो ऐसा कर सकते हैं।


We can assign default values to variables.

---

### 📄 variables.tf

```hcl
variable "environment" {

  description = "Environment name"
  type        = string
  default     = "dev"
}
```

अब main.tf में: ${} Interpoletion use karenge

```hcl
name = "rg-${var.environment}"
```

अगर tfvars में कुछ नहीं दिया तो default "dev" उपयोग होगा।

---

# 🧪 Example 3: Conditional Expression


यदि environment prod है तो अलग नाम, अन्यथा अलग नाम।


We can apply conditional logic.

---

```hcl
name = var.environment == "prod" ? "rg-production" : "rg-development"
```

यदि environment = prod → rg-production  
अन्यथा → rg-development

---

# 🧪 Example 4: Built-in Function (upper)


हम नाम को uppercase में बदल सकते हैं।


We can transform strings using built-in functions.

---

```hcl
name = upper("rg-devops-demo")
```

Output:

RG-DEVOPS-DEMO

---

# 📌 What You Learned

✔ count से multiple resources  
✔ Variables में default value  
✔ Conditional logic  
✔ Built-in functions  
✔ Dynamic naming and Expression

---

# ☁️ Terraform for Azure: Interview Questions & Answers

This document focuses on Terraform concepts applied specifically to Azure infrastructure.

---

### 1. Difference between `count` and `for_each` in Azure context?
**प्रश्न: Azure के संदर्भ में `count` और `for_each` में क्या अंतर है?**

*   **`count`**: 
    *   Best for creating multiple **identical** resources.
    *   *Azure Example*: Creating 3 identical Virtual Machines named `vm-0`, `vm-1`, `vm-2`.
    *   *Code*: `name = "vm-${count.index}"`
*   **`for_each`**: 
    *   Best for creating resources with **different configurations** (like different sizes or subnet names).
    *   *Azure Example*: Creating multiple Storage Accounts with unique names defined in a map.
    *   *Advantage*: If you delete one storage account from the map, others remain unaffected. Using `count` might cause unwanted re-creations.

---

### 2. How do Conditional Expressions work in Azure?
**प्रश्न: Azure के लिए Conditional expression कैसे काम करता है?**

It follows the `condition ? true : false` logic. It's very useful for environment-based logic (Dev vs Prod).

*   **Azure Example**: Only create a **Public IP** if the environment is 'Prod'.
    ```hcl
    resource "azurerm_public_ip" "pip" {
      count               = var.env == "prod" ? 1 : 0
      name                = "prod-pip"
      resource_group_name = azurerm_resource_group.main.name
      location            = azurerm_resource_group.main.location
      allocation_method   = "Static"
    }
    ```

---

### 3. When is the Default Variable value used?
**प्रश्न: Default variable value कब उपयोग होती है?**

If you don't provide a value via a `.tfvars` file or command line, Terraform falls back to the `default`.

*   **Azure Use Case**: Setting a default Azure region.
    ```hcl
    variable "location" {
      type    = string
      default = "East US"
    }
    ```
    If the user doesn't specify a location, Terraform will automatically deploy resources to **East US**.

---

### 4. Why are Terraform Functions used in Azure?
**प्रश्न: Azure deployments में Terraform functions का उपयोग क्यों किया जाता है?**

Functions help in dynamic resource naming and complex networking logic.

*   **Common Azure Examples**:
    *   **`lookup()`**: To pick a specific Image SKU from a map based on the OS type.
    *   **`element()`**: To distribute Virtual Machines across different Availability Zones.
    *   **`lower()`**: Azure Storage Accounts must have **lowercase** names. Using `lower(var.storage_name)` ensures the deployment doesn't fail due to naming rules.
    *   **`cidrsubnet()`**: Automatically calculating the next available Subnet range within an Azure VNet.

---

### Key Azure Resource Reference Table


| Feature | Azure Resource Example |
| :--- | :--- |
| **Logic** | `azurerm_resource_group` |
| **Iteration** | `azurerm_virtual_network` subnets |
| **Naming** | `azurerm_storage_account` (must be unique/lowercase) |

---


---

# 😎 DevOps Reality

Production में infrastructure static नहीं होता।

Real DevOps engineer वही है जो:

- Reusable code लिखे
- Dynamic naming करे
- Environment based automation करे

Click-click engineer नहीं 😄

---
