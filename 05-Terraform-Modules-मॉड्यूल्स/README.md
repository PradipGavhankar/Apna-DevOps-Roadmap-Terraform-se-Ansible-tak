# 🚀 DevOps Terraform Roadmap – 5 Core Modules

---

# 📦 Module 1 – Provider aur Resource Group

## 🟢 पहले हिन्दी में आसान समझ

टेरेफॉर्म एक ऐसा उपकरण है जिससे हम क्लाउड में संसाधन को कोड के माध्यम से बना सकते हैं।  
Terraform ek aisa tool hai jisse hum cloud me resources ko code ke through bana sakte hain.

इस मॉड्यूल में हम एज़्योर प्रदाता को जोड़ेंगे और एक संसाधन समूह बनाएंगे।  
Is module me hum Azure provider configure karenge aur ek Resource Group banayenge.

---

## 🔵 English Explanation

Terraform is a tool used to create cloud resources using code.

In this module, we configure the Azure provider and create a Resource Group.

---

## 🧱 Simple Code (Hindi Comments)

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"  # संस्करण सीमा निर्धारित करना आवश्यक है
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-demo"  # संसाधन समूह का नाम
  location = "East US"         # क्षेत्र
}
```

---

## ✅ Good Practice

हमेशा संस्करण सीमा निर्धारित करें।  
Always define version constraint.

चर का उपयोग करें और सीधे मान न लिखें।  
Use variables and avoid hardcoding.

कोड को संस्करण नियंत्रण प्रणाली में रखें।  
Keep code in version control.

---

## ❌ Bad Practice

सदस्यता पहचान संख्या सीधे कोड में लिखना।  
Hardcoding subscription ID.

उत्पादन में बिना योजना देखे लागू करना।  
Applying directly in production without plan.

पोर्टल से सीधे परिवर्तन करना।  
Making manual portal changes.

---

## 😂 Thoda DevOps Comedy

"पोर्टल से बना दिया है।"  
"I created it from portal."

"तो फिर टेरेफॉर्म क्यों सीखा?"  
"Then why did you learn Terraform? 😄"

---

## 🚀 Real Output Example

```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## ✅ Good Practice (Production Ready Mindset)

✔ हमेशा संस्करण सीमा निर्धारित करें  
✔ चर का उपयोग करें, सीधे मान न लिखें  
✔ स्थिति फ़ाइल को Git में commit न करें  
✔ उत्पादन में terraform plan अनिवार्य है  
✔ दूरस्थ backend का उपयोग करें  

---

## ❌ Bad Practice (Danger Zone)

❌ Hardcoded subscription ID  
❌ State file GitHub में push करना  
❌ Direct apply in production  
❌ No version control  
❌ Portal से manually change करना  

---

# 🌐 Module 2 – Variables aur Outputs

## 🟢 पहले हिन्दी में आसान समझ

चर कोड को लचीला और पुनः उपयोग योग्य बनाते हैं।  
Variables make code flexible and reusable.

आउटपुट हमें बनाए गए संसाधनों की जानकारी दिखाते हैं।  
Outputs show information about created resources.

---

## 🔵 English Explanation

Variables make Terraform configurations reusable.

Outputs display values after execution.

---

## 🧱 Simple Code (Hindi Comments)

```hcl
variable "location" {
  description = "Azure region"
  default     = "East US"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-demo"
  location = var.location  # यहाँ चर का उपयोग किया गया है
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}
```

---

## ✅ Good Practice

चर को अलग फ़ाइल में रखें।  
Keep variables in separate file.

संवेदनशील जानकारी सुरक्षित रखें।  
Keep sensitive data secure.

---

## ❌ Bad Practice

पासवर्ड को सार्वजनिक भंडार में डालना।  
Pushing passwords to GitHub.

सभी मान सीधे कोड में लिखना।  
Hardcoding all values.

---

## 😂 DevOps Comedy

"हर बार कोड बदलना पड़ता है।"  
"I have to change code every time."

"क्योंकि तुमने चर का उपयोग नहीं किया।"  
"Because you did not use variables 😄"

---

## 🚀 Real Output Example

```
Outputs:
rg_name = rg-devops-demo
```

---

# 🧠 Module 3 – State aur Backend

## 🟢 पहले हिन्दी में आसान समझ

स्थिति फ़ाइल वास्तविक क्लाउड की स्थिति को सुरक्षित रखती है।  
State file stores actual infrastructure state.

टीम में काम करते समय इसे दूरस्थ स्थान पर रखना चाहिए।  
In team environment, it should be stored remotely.

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

स्थिति फ़ाइल को सुरक्षित रखें।  
Keep state file secure.

दूरस्थ backend का उपयोग करें।  
Use remote backend.

---

## ❌ Bad Practice

स्थिति फ़ाइल GitHub में डालना।  
Pushing state file to GitHub.

स्थानीय मशीन में production state रखना।  
Keeping production state locally.

---

## 😂 DevOps Comedy

"State file delete हो गई!"  
"State file got deleted!"

"अब Terraform भी confused है।"  
"Now Terraform is also confused 😄"

---

## 🚀 Real Output Example

```
Successfully configured the backend "azurerm"
```

---

# 🏗 Module 4 – Modules

## 🟢 पहले हिन्दी में आसान समझ

मॉड्यूल कोड को व्यवस्थित और पुनः उपयोग योग्य बनाते हैं।  
Modules make code organized and reusable.

---

## 🔵 English Explanation

Modules help structure and reuse Terraform code.

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

कोड को छोटे भागों में बाँटें।  
Divide code into small modules.

साफ़ फ़ोल्डर संरचना रखें।  
Maintain clean folder structure.

---

## ❌ Bad Practice

पूरा कोड एक ही फ़ाइल में लिखना।  
Writing everything in one file.

---

## 😂 DevOps Comedy

"मॉड्यूल क्यों?"  
"Why module?"

"ताकि भविष्य में दिक्कत न हो।"  
"So that future me you don’t suffer 😄"

---

## 🚀 Real Output Example

```
module.rg.azurerm_resource_group.rg: Creation complete
```

---

# 🤖 Module 5 – Terraform + Ansible

## 🟢 पहले हिन्दी में आसान समझ

टेरेफॉर्म आधारभूत संरचना बनाता है।  
Terraform builds infrastructure.

एन्सिबल सर्वर की व्यवस्था करता है।  
Ansible configures servers.

---

## 🔵 English Explanation

Terraform provisions infrastructure.

Ansible configures servers after provisioning.

---

## 🧱 Simple Flow Example

```bash
terraform apply
ansible-playbook site.yml
```

---

## ✅ Good Practice

ढाँचा और व्यवस्था अलग रखें।  
Keep infra and configuration separate.

स्वचालन बनाए रखें।  
Maintain automation.

---

## ❌ Bad Practice

हाथ से सर्वर में बदलाव करना।  
Making manual server changes.

---

## 😂 DevOps Comedy

"सब कुछ Terraform से कर दूँ?"  
"Should I do everything with Terraform?"

"नहीं, काम का विभाजन समझो 😄"  
"No, understand role separation 😄"

---

# 🏁 Final DevOps Rule

स्वचालन + संस्करण नियंत्रण + जाँच प्रक्रिया  
Automation + Version Control + Review Process  

= सुरक्षित उत्पादन वातावरण 🚀  
= Safe Production Infrastructure 🚀