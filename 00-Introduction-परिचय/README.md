# Introduction – परिचय

DevOps सीखने की इस यात्रा में आपका स्वागत है.  
Welcome to the DevOps learning journey.

---

## 🎯 Roadmap Goal

यह रोडमैप उन beginners के लिए बनाया गया है जो Zero से शुरुआत करके Terraform (Application or Website chalaneka Resources/Infra bananeka HCL Language Coding Software)(Terraform is an Infrastructure as Code (IaC) tool that lets you define, provision, and manage cloud resources using human-readable configuration files)और Ansible (Ansible is an open-source IT automation tool that sets up servers and installs software across multiple computers at once without needing extra helper software installed on them) में confident बनना चाहते हैं.

This roadmap is designed for beginners who want to start from zero and become confident in Terraform and Ansible.

---

## 🧠 What is DevOps? – DevOps क्या है?

DevOps एक सांस्कृतिक और तकनीकी तरीका है जिसमें Development और Operations टीम मिलकर काम करती हैं ताकि software को तेज़ और भरोसेमंद तरीके से deliver किया जा सके.

DevOps is a cultural and technical approach where Development and Operations teams work together to deliver software faster and more reliably.

---

## 🚀 What Will You Learn? – आप क्या सीखेंगे?

आप Cloud basics से लेकर real-world infrastructure automation तक की पूरी journey सीखेंगे.

You will learn the complete journey from cloud basics to real-world infrastructure automation.

- क्लाउड के मूल सिद्धांत  
  Cloud Fundamentals  

- इंफ्रास्ट्रक्चर ऐज़ कोड  
  Infrastructure as Code (IaC)  

- टेरेफॉर्म – बेसिक से एडवांस तक  
  Terraform (Beginner to Advanced)  

- स्टेट मैनेजमेंट  
  State Management  

- मॉड्यूल्स  
  Modules  

- एन्सिबल कॉन्फ़िगरेशन मैनेजमेंट  
  Ansible Configuration Management  

- वास्तविक प्रोजेक्ट इम्प्लीमेंटेशन  
  Real World Project  

---

## 💡 Golden Rule – स्वर्ण नियम

कम थ्योरी, ज्यादा प्रैक्टिकल इम्प्लीमेंटेशन.  
Less theory, more practical implementation.

DevOps tools में महारत हासिल करने के लिए hands-on practice अनिवार्य है.  
Hands-on practice is mandatory to master DevOps tools.

---

# 🧪 Mini Practical – Azure Portal (GUI) Hands-On

> 🎯 Goal: Terraform start करने से पहले Azure को visually समझना.

---

## 🟢 पहले हिन्दी में आसान समझ

Terraform शुरू करने से पहले Azure Portal में manually कुछ resources बनाना बहुत ज़रूरी है.

हम यह 3 चीज़ें बनाएंगे:

1. Resource Group  
2. Virtual Network  
3. Storage Account  

इससे आपको समझ आएगा:

- Resource Group क्या होता है  
- Region क्यों important है  
- Resources एक-दूसरे से कैसे जुड़े होते हैं  
- Naming rules क्या होते हैं  

👉 पहले Portal से manually बनाओ  
👉 फिर वही चीज Terraform से automate करो  

---

## 🔵 English Explanation

Before starting Terraform, we will manually create a small setup using Azure Portal (GUI).

We will create:

1. Resource Group  
2. Virtual Network  
3. Storage Account  

This helps you understand:

- Logical grouping of resources  
- Importance of region selection  
- Resource dependencies  
- Naming conventions  

First create manually → Then automate using Terraform.

---

## 🧱 Step-by-Step Azure Portal Practice

### Step 1️⃣ – Create Resource Group

**हिन्दी:**  
- Azure Portal login करें  
- Search box में **Resource Groups** लिखें  
- Click ➜ **Create**  
- Name: `rg-devops-demo`  
- Region: East US (या nearest region)  
- Click **Review + Create** ➜ Create  

**English:**  
Login → Resource Groups → Create → Give name & region → Create.

---

### Step 2️⃣ – Create Virtual Network

**हिन्दी:**  
- Search ➜ **Virtual Network**  
- Click ➜ Create  
- Resource Group select करें: `rg-devops-demo`  
- Name: `vnet-demo`  
- Address space default रहने दें  
- Review + Create  

**English:**  
Create Virtual Network inside the same Resource Group.

---

### Step 3️⃣ – Create Storage Account

**हिन्दी:**  
- Search ➜ **Storage Account**  
- Click ➜ Create  
- Resource Group: `rg-devops-demo`  
- Storage name: unique होना चाहिए (example: `devopsstorage123`)  
- Region same रखें  
- Performance: Standard  
- Review + Create  

**English:**  
Create a Storage Account in the same Resource Group.

---

## 🧠 Important Observations (Very Important 🔥)

Azure Portal में ध्यान दें:

- Resource का **Location**
- Resource का **Type**
- Resource का **Pricing Tier**
- Networking section
- Activity Log

👉 बाद में यही चीजें Terraform code में define होती हैं.

---

## 🔍 Concept Mapping (Portal → Terraform)

| Azure Portal Concept | Terraform Concept              |
|----------------------|--------------------------------|
| Resource Group       | `azurerm_resource_group`       |
| Virtual Network      | `azurerm_virtual_network`      |
| Storage Account      | `azurerm_storage_account`      |
| Region               | `location` argument            |
| Tags                 | `tags` block                   |

---

## 😂 Thoda DevOps Comedy

Manager:  
“Portal से बना दिया? Production ready है?”

DevOps Engineer:  
“Sir, Portal demo के लिए होता है… Production के लिए Terraform 😎”

---

## 🛑 Golden Rule

Portal से बनाना सिर्फ learning के लिए है.

Production में:
- Infrastructure as Code  
- Version Control  
- Remote Backend  
- Review Process  

Manual Portal changes = Drift Problem ⚠

---

# 🏗️ Terraform – Technical Overview (Deep Understanding)

---

## 🟢 पहले हिन्दी में आसान समझ

Terraform एक **Open Source Infrastructure as Code (IaC)** tool है जिसकी मदद से हम Cloud Infrastructure को **Code** के माध्यम से बना (Provision), बदल (Modify) और हट (Destroy) सकते हैं.

Terraform को **HashiCorp** ने विकसित (Develop) किया था और आज यह Infrastructure Automation की दुनिया का सबसे लोकप्रिय IaC Tool माना जाता है.

साल **2023** में IBM ने HashiCorp का अधिग्रहण (Acquisition) किया, इसलिए अब Terraform का स्वामित्व (Ownership) IBM के पास है. हालांकि Terraform का विकास अभी भी HashiCorp टीम के माध्यम से जारी है.

Terraform का Source Code मुख्य रूप से **Go (Golang)** Programming Language में लिखा गया है.

इसी कारण Terraform:

- बहुत तेज़ (Fast) है  
- Cross Platform है (Windows, Linux, macOS)  
- Single Binary Application है  
- आसानी से हजारों Cloud Resources को Manage कर सकता है  
- Multi-threading की सहायता से बेहतर Performance देता है  

---

## 🔵 English Explanation

Terraform is an **Open Source Infrastructure as Code (IaC)** tool developed by **HashiCorp**.

It allows engineers to define, provision, update, and destroy cloud infrastructure using code instead of manually creating resources through cloud portals.

In **2023**, IBM announced the acquisition of HashiCorp. Terraform is now part of IBM while the product continues to be developed by the HashiCorp engineering team.

Terraform is primarily written in **Go (Golang)**, making it lightweight, fast, portable, and highly scalable.

Also Terraform code Run Block by block.

---

## 📌 Terraform Technical Details

| Property                | Details                                      |
|-------------------------|----------------------------------------------|
| Tool Name               | Terraform                                    |
| Developed By            | HashiCorp                                    |
| Current Owner           | IBM (HashiCorp acquired by IBM)              |
| Category                | Infrastructure as Code (IaC)                 |
| Programming Language    | Go (Golang)                                  |
| Configuration Language  | HCL (HashiCorp Configuration Language)       |
| License                 | Open Source (license terms have evolved)     |
| Platform Support        | Windows, Linux, macOS                        |
| First Release           | 2014                                         |
| Latest Major Version    | Terraform 1.x Series                         |
| Official Registry       | https://registry.terraform.io                |
| Official Documentation  | https://developer.hashicorp.com/terraform/docs |

---

## 🧠 Why Terraform is Written in Go?

HashiCorp selected **Go Language** because it provides:

✅ **Fast Compilation**  
Go code compiles into a single executable binary.

✅ **Cross Platform Support**  
The same source code can generate binaries for Windows, Linux, and macOS.

✅ **High Performance**  
Terraform executes thousands of infrastructure operations efficiently.

✅ **Lightweight**  
No runtime installation is required. Simply download `terraform` (or `terraform.exe`) and start using it.

✅ **Easy Concurrency**  
Go supports Goroutines. Terraform can communicate with multiple cloud APIs simultaneously.

Example: Instead of creating VM-1 → VM-2 → VM-3 one after another, Terraform can process multiple independent resources in parallel whenever dependencies allow.

---

## 🏗️ What is HCL?

Terraform does **NOT** use Go language for writing Infrastructure Code.

Instead, users write configurations in **HashiCorp Configuration Language (HCL)**.

Example:

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "Pradip-RG"
  location = "West Europe"
}
```

Terraform internally converts HCL into API requests.

---

## 🔄 How Terraform Actually Works?

```
Developer
     │
     ▼
Terraform HCL Code
     │
     ▼
Terraform Core
     │
     ▼
Provider Plugin
     │
     ▼
Azure REST API
     │
     ▼
Azure Cloud
     │
     ▼
Resource Created
```

---

## 🏗️ Terraform Architecture

```
                 Terraform Core
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
 Azure Provider   AWS Provider   GCP Provider
        │              │              │
        ▼              ▼              ▼
 Azure APIs       AWS APIs       Google APIs
```

Terraform Core never talks directly to Azure.  
It always communicates through a **Provider Plugin**.

---

## 🌍 Why Terraform is So Powerful?

Terraform is cloud-agnostic.

One tool can manage:

- Microsoft Azure  
- Amazon Web Services (AWS)  
- Google Cloud Platform (GCP)  
- Oracle Cloud  
- Alibaba Cloud  
- Kubernetes  
- VMware  
- GitHub  
- Azure DevOps  
- Docker  
- Helm  
- Cloudflare  

and hundreds of other platforms through Providers.

---

## 📦 What is a Provider?

A Provider is a plugin that allows Terraform to communicate with an external platform.

**Azure example:**

```hcl
provider "azurerm" {
  features {}
}
```

**AWS example:**

```hcl
provider "aws" {
  region = "ap-south-1"
}
```
# ☁️ What is a Provider in Terraform?

## 🟢 पहले हिन्दी में आसान समझ

Terraform खुद Azure, AWS, GCP या VMware की language नहीं समझता।

उसे किसी ऐसे component की जरूरत होती है जो Terraform के instructions को Cloud Provider की language में translate करे।

इसी component को **Provider** कहते हैं।

**Provider = Terraform और Cloud Platform के बीच का Translator (Middleman).**

जब हम Terraform में कोई resource लिखते हैं, Provider उस request को Azure/AWS/GCP की API तक पहुंचाता है और response वापस Terraform को देता है।

---

## 🔵 English Explanation

A **Provider** is a plugin that acts as a bridge between Terraform and a cloud platform.

It translates Terraform configuration into API calls that the cloud provider understands.

Without a Provider, Terraform does not know:

- How to communicate with Azure
- How to create a VM
- How to create a Storage Account
- How to delete a Resource Group

The Provider handles all communication with the cloud platform.

---

# 🧠 Easy Real-Life Example

Imagine you are in Japan but only speak Hindi.

You want to order food.

You cannot directly communicate with the waiter.

So you use a translator.

```
You
   │
   ▼
Translator
   │
   ▼
Waiter
```

Similarly,

```
Terraform
     │
     ▼
Provider
     │
     ▼
Azure REST API
     │
     ▼
Azure Resources
```

The **Provider** translates Terraform code into Azure API requests.

---

# 🏗 Azure Example

```hcl
provider "azurerm" {
  features {}
}
```

### Explanation

- `provider` → Terraform block type
- `"azurerm"` → Azure Resource Manager Provider
- `features {}` → Enables Azure provider features (required block)

---

# 🚀 What Happens Internally?

When you run: Terraform one of below command

```bash
terraform apply
```

Terraform performs these steps:

```
Terraform Code
      │
      ▼
Terraform Core
      │
      ▼
Azure Provider
      │
      ▼
Azure REST API
      │
      ▼
Azure Creates Resources
```

---

# 🌍 Popular Terraform Providers

| Provider | Used For |
|-----------|----------|
| azurerm | Microsoft Azure |
| aws | Amazon Web Services |
| google | Google Cloud Platform |
| kubernetes | Kubernetes Cluster |
| helm | Helm Charts |
| docker | Docker |
| github | GitHub Repositories |
| azuread | Microsoft Entra ID (Azure AD) |
| random | Generate random values |
| local | Create local files |

---

# 🧱 Practical Azure Example

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
```

---

# 🔍 Why Do We Need a Provider?

Without a Provider:

❌ Terraform cannot connect to Azure.

❌ Terraform cannot authenticate.

❌ Terraform cannot create resources.

❌ Terraform cannot delete resources.

The Provider is responsible for all communication with Azure.

---

# 🚀 Real Output Example

```bash
terraform init
```

Output:

```
Initializing provider plugins...

- Finding hashicorp/azurerm versions...
- Installing hashicorp/azurerm v4.x.x...
- Installed hashicorp/azurerm
```

This means Terraform downloaded the Azure Provider plugin.

---

# ✅ Good Practice

✔ Always specify the provider version.

✔ Use the latest stable version.

✔ Store authentication securely.

✔ Keep providers updated after testing.

---

# ❌ Bad Practice

❌ Hardcoding Subscription IDs.

❌ Using old provider versions.

❌ Not locking provider versions.

❌ Ignoring provider compatibility.

---

# 😂 DevOps Comedy

Terraform:
> "Mujhe Azure ki language nahi aati."

Provider:
> "Tension mat le bhai, main translation kar deta hoon!" 😄

---

# 🎯 Interview Question

**Q:** What is a Terraform Provider?

**Answer:**

A Provider is a plugin that acts as a bridge between Terraform and a target platform. It translates Terraform configuration into platform-specific API calls, enabling Terraform to create, update, and manage infrastructure resources.

---

## 🏢 Real Company Example

Suppose an enterprise wants to create:

- 50 Virtual Machines  
- 20 VNets  
- 80 Storage Accounts  
- 15 SQL Servers  

**Without Terraform:**  
Cloud Engineer manually creates each resource from the Azure Portal.  
Estimated effort: ❌ 2–3 days with higher chances of human error.

**Using Terraform:**  
One codebase → One command:

```bash
terraform apply
```

Infrastructure is created automatically.

---

## 🚀 Real Output Example

```
Plan: 165 to add, 0 to change, 0 to destroy.
```

Terraform understands exactly what needs to be created before making changes.

---

## ✅ Good Practice (Production Ready)

✔ Always pin Provider versions  
✔ Keep Terraform version consistent across the team  
✔ Store code in Git  
✔ Use Remote Backend for State Files  
✔ Use Modules for reusable code  
✔ Use Variables instead of hardcoding values  
✔ Follow enterprise naming conventions  

---

## ❌ Bad Practice

❌ Hardcoding Subscription IDs  
❌ Hardcoding Passwords  
❌ Pushing `terraform.tfstate` to GitHub  
❌ Using the latest provider version without testing  
❌ Manually changing resources from the Azure Portal after Terraform deployment  

---

## 🎯 Interview Questions

**Q1. Who developed Terraform?**  
**Answer:** HashiCorp developed Terraform.

**Q2. Who owns Terraform today?**  
**Answer:** IBM acquired HashiCorp in 2023, so Terraform is now part of IBM.

**Q3. Which programming language is Terraform written in?**  
**Answer:** Go (Golang).

**Q4. Which language is used to write Terraform configuration files?**  
**Answer:** HashiCorp Configuration Language (HCL).

**Q5. Does Terraform directly communicate with Azure?**  
**Answer:** No. Terraform communicates through the AzureRM Provider Plugin, which calls Azure REST APIs.

---

## 😂 DevOps Comedy

Manager:  
"Kitne resources bana sakte ho?"

DevOps Engineer:  
"Question ye nahi hai...  
Question ye hai ki `terraform apply` ke baad coffee peene ka time kitna milega!" ☕😄

---

## 📌 Author

**Pradip Gavhankar**  
*DevOps | Cloud | DevSecOps | FinOps Learning Journey*
