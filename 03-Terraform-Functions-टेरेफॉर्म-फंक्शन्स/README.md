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

अब main.tf में:

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
✔ Dynamic naming  

---

# 🎯 Interview Questions

1. count और for_each में क्या अंतर है?
2. Conditional expression कैसे काम करता है?
3. Default variable value कब उपयोग होती है?
4. Terraform functions का उपयोग क्यों किया जाता है?

---

# 😎 DevOps Reality

Production में infrastructure static नहीं होता।

Real DevOps engineer वही है जो:

- Reusable code लिखे
- Dynamic naming करे
- Environment based automation करे

Click-click engineer नहीं 😄

---
