# Introduction – परिचय

DevOps सीखने की इस यात्रा में आपका स्वागत है।

Welcome to the DevOps learning journey.

---

## 🎯 Roadmap Goal

यह रोडमैप उन beginners के लिए बनाया गया है जो Zero से शुरुआत करके Terraform और Ansible में confident बनना चाहते हैं।

This roadmap is designed for beginners who want to start from zero and become confident in Terraform and Ansible.

---

## 🧠 What is DevOps? – DevOps क्या है?

DevOps एक सांस्कृतिक और तकनीकी तरीका है जिसमें Development और Operations टीम मिलकर काम करती हैं ताकि software को तेज़ और भरोसेमंद तरीके से deliver किया जा सके।

DevOps is a cultural and technical approach where Development and Operations teams work together to deliver software faster and more reliably.

---

## 🚀 What Will You Learn? – आप क्या सीखेंगे?

आप Cloud basics से लेकर real-world infrastructure automation तक की पूरी journey सीखेंगे।

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

कम थ्योरी, ज्यादा प्रैक्टिकल इम्प्लीमेंटेशन।

Less theory, more practical implementation.

DevOps tools में महारत हासिल करने के लिए hands-on practice अनिवार्य है।

Hands-on practice is mandatory to master DevOps tools.

# 🧪 Mini Practical – Azure Portal (GUI) Hands-On

> 🎯 Goal: Terraform start karne se pehle Azure ko visually samajhna.

---

## 🟢 पहले हिन्दी में आसान समझ

Terraform शुरू करने से पहले Azure Portal में manually कुछ resources बनाना बहुत ज़रूरी है।

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

# 🧱 Step-by-Step Azure Portal Practice

---

## Step 1️⃣ – Create Resource Group

### 🟢 हिन्दी में:

- Azure Portal login करें  
- Search box में **Resource Groups** लिखें  
- Click ➜ **Create**  
- Name: `rg-devops-demo`  
- Region: East US (या nearest region)  
- Click **Review + Create** ➜ Create  

### 🔵 English:

Login → Resource Groups → Create → Give name & region → Create.

---

## Step 2️⃣ – Create Virtual Network

### 🟢 हिन्दी में:

- Search ➜ **Virtual Network**  
- Click ➜ Create  
- Resource Group select करें: `rg-devops-demo`  
- Name: `vnet-demo`  
- Address space default रहने दें  
- Review + Create  

### 🔵 English:

Create Virtual Network inside the same Resource Group.

---

## Step 3️⃣ – Create Storage Account

### 🟢 हिन्दी में:

- Search ➜ **Storage Account**  
- Click ➜ Create  
- Resource Group: `rg-devops-demo`  
- Storage name: unique होना चाहिए (example: `devopsstorage123`)  
- Region same रखें  
- Performance: Standard  
- Review + Create  

### 🔵 English:

Create a Storage Account in the same Resource Group.

---

# 🧠 Important Observations (Very Important 🔥)

Azure Portal में ध्यान दें:

- Resource का **Location**
- Resource का **Type**
- Resource का **Pricing Tier**
- Networking section
- Activity Log

👉 बाद में यही चीजें Terraform code में define होती हैं।

---

# 🔍 Concept Mapping (Portal → Terraform)

| Azure Portal Concept | Terraform Concept |
|----------------------|------------------|
| Resource Group       | azurerm_resource_group |
| Virtual Network      | azurerm_virtual_network |
| Storage Account      | azurerm_storage_account |
| Region               | location argument |
| Tags                 | tags block |

---

# 😂 Thoda DevOps Comedy

Manager:  
“Portal से बना दिया? Production ready है?”

DevOps Engineer:  
“Sir, Portal demo के लिए होता है… Production के लिए Terraform 😎”

---

# 🛑 Golden Rule

Portal से बनाना सिर्फ learning के लिए है।

Production में:

- Infrastructure as Code  
- Version Control  
- Remote Backend  
- Review Process  

Manual Portal changes = Drift Problem ⚠