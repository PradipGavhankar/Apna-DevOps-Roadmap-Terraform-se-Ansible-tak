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
# ☁️ Terraform Azure Interview Q&A (Easy Hinglish)

---

### 1. What is the difference between `count` and `for_each`?
**प्रश्न: `count` और `for_each` में क्या अंतर है?**

*   **`count`**: 
    *   जब आपको एक जैसी (identical) कई चीज़ें बनानी हों, तब `count` का यूज़ होता है।
    *   जैसे: Azure में 3 एक जैसे Virtual Machines (VM) बनाने हैं।
    *   **नुकसान**: अगर आप बीच में से कोई VM डिलीट करोगे, तो Terraform बाकी VMs को भी हिला देता है (index बदल जाता है)।

*   **`for_each`**: 
    *   जब आपको अलग-अलग नाम या कॉन्फ़िगरेशन वाली चीज़ें बनानी हों।
    *   जैसे: 3 अलग-अलग नाम के Storage Accounts।
    *   **फायदा**: इसमें हर resource की अपनी एक पहचान (Key) होती है। एक डिलीट करने पर दूसरों पर कोई असर नहीं पड़ता।

---

### 2. How do Conditional Expressions work?
**प्रश्न: Conditional expression कैसे काम करता है?**

यह बिल्कुल `if-else` की तरह काम करता है। इसका फार्मूला है: `condition ? true : false`

*   **Azure Example**: 
    मान लो आप चाहते हो कि Public IP सिर्फ "Prod" environment में बने, "Dev" में नहीं।
    *   `count = var.env == "prod" ? 1 : 0`
    *   (अगर env 'prod' है, तो 1 बनाओ, वरना 0 यानी कुछ मत बनाओ)।

---

### 3. When is the Default Variable value used?
**प्रश्न: Default variable value कब उपयोग होती है?**

जब हम variable की कोई value बाहर से (command line या .tfvars फ़ाइल से) नहीं देते, तब Terraform ऑटोमैटिक **Default value** उठा लेता है।

*   **Azure Example**: 
    आपने variable बनाया `location` और default दी `East US`। अगर deployment के टाइम आपने location नहीं बताई, तो Terraform अपने आप उसे `East US` में बना देगा। यह code को फटने (error) से बचाता है।

---

### 4. Why are Terraform Functions used?
**प्रश्न: Terraform functions का उपयोग क्यों किया जाता है?**

Terraform functions का काम डेटा को "Modify" या "Calculate" करना है ताकि हमें बार-बार हाथ से कोडिंग न करनी पड़े।

*   **आसान उदहारण (Examples)**:
    *   **`lower()`**: Azure में Storage Account का नाम हमेशा **lowercase** (छोटी ABC) में होना चाहिए। अगर user ने गलती से "MyStorage" लिख दिया, तो `lower()` function उसे अपने आप "mystorage" कर देगा ताकि error न आये।
    *   **`lookup()`**: एक लिस्ट में से सही चीज़ चुनना। जैसे: अगर "Windows" है तो "2019-Datacenter" image उठाओ, अगर "Linux" है तो "Ubuntu" उठाओ।
    *   **`join()`**: दो शब्दों को जोड़कर एक नाम बनाना। जैसे: "ProjectName" + "Resource" = "ProjectName-Resource"。
    *   **`cidrsubnet()`**: यह function अपने आप calculate करता है कि आपके VNet के अंदर Subnet की IP Range क्या होगी। आपको खुद हिसाब नहीं लगाना पड़ता।

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
