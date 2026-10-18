# Cloud Fundamentals – क्लाउड मूल तत्व
# Imperative vs Declarative & Terraform Introduction
# इम्पेरेटिव vs डिक्लेरेटिव और टेरेफॉर्म परिचय

---

## 1. Site / Application Chalane ke Different Tarike

Koi bhi website ya application chalane ke liye mainly 4 options hote hain:

1. **Personal PC / Laptop**
2. **Killercoda** (Browser based free lab environment)
3. **On-Premises Server**
4. **Cloud** (AWS / Azure / Google Cloud)

Cloud sabse powerful, scalable aur industry standard option hai.

---

## 2. Cloud pe Resources Banane ke 3 Approaches

### A. Manual (Portal)
- Azure Portal / AWS Console mein manually click karke resources banana
- Beginners ke liye accha hai
- Production mein scalable nahi hota

### B. Imperative
- Commands ek-ek karke chalana
- Example: Azure CLI (`az` commands)
- **Nature**: Single command at a time
- Problem: Bahut saare resources hone par difficult + error prone + time consuming

### C. Declarative (Recommended)
- Desired state (kya chahiye) likh do
- Tool khud dekh ke resources create / update / delete karta hai
- Examples:
  - **Terraform** (Multi-cloud + HCL) ★ Recommended
  - Bicep (Azure only)
  - ARM Templates (Azure only)

---

## 3. Imperative vs Declarative – Clear Difference

| Point              | Imperative                      | Declarative                          |
|--------------------|---------------------------------|--------------------------------------|
| Style              | "Kaise banana hai" batao        | "Kya chahiye" batao                  |
| Commands           | Ek-ek command                   | Desired state ek saath               |
| Tool Example       | `az` CLI, PowerShell            | **Terraform**, Bicep, ARM            |
| Error Handling     | Manual                          | Tool manage karta hai                |
| Reusability        | Kam                             | Bahut high                           |
| Multi-cloud        | Difficult                       | Terraform best                       |
| Production Ready   | Limited                         | Highly Recommended                   |
| Learning Curve     | Fast start                      | Thoda initial effort, long term gain |

---

## 4. Why Terraform?

- **Multi-cloud** support (AWS + Azure + GCP + 3000+ providers)
- Human readable language → **HCL** (HashiCorp Configuration Language)
- Infrastructure as Code (IaC) ka industry standard tool
- Strong State Management
- Modules, Workspaces, CI/CD integration – sab support karta hai
- Azure ke liye official provider → **AzureRM**

---

## 5. Terraform Registry

Terraform Registry se providers aur modules milte hain.

- Azure ke liye main provider: `hashicorp/azurerm`
- Official website: [https://registry.terraform.io](https://registry.terraform.io)

---

## 6. Quick Mental Model

```
Website / Application Chalana
          │
          ├── Personal PC
          ├── Killercoda
          ├── On-Prem
          └── Cloud
                │
                ├── Manual (Portal)
                ├── Imperative (az CLI)
                └── Declarative
                      ├── Terraform (Multi-cloud) ★
                      ├── Bicep
                      └── ARM Template

```

## ☁️ Cloud क्या है?

Cloud एक ऐसा सिस्टम है जहाँ हम servers, storage, databases और networking जैसी resources internet के माध्यम से use करते हैं।

Cloud is a system where we use servers, storage, databases, and networking resources over the internet.



## 🏢 On-Premise vs Cloud

On-Premise में servers और infrastructure हमारी अपनी company के अंदर होते हैं।

In On-Premise, servers and infrastructure are hosted inside the organization.

Cloud में infrastructure किसी third-party provider (जैसे AWS, Azure) के data center में होता है।

In Cloud, infrastructure is hosted in third-party data centers like AWS or Azure.

---

## 🧩 Cloud Service Models

### IaaS (Infrastructure as a Service)

Virtual machines, storage, networking provide किया जाता है।

Provides virtual machines, storage, and networking.

---

### PaaS (Platform as a Service)

Application deploy करने के लिए ready platform दिया जाता है।

Provides a ready platform to deploy applications.

---

### SaaS (Software as a Service)

Ready-made software internet के माध्यम से use किया जाता है।

Provides ready-to-use software over the internet.

---

## 🌍 Cloud Deployment Models

Public Cloud – सबके लिए available  
Public Cloud – Available to everyone

Private Cloud – सिर्फ एक organization के लिए  
Private Cloud – Dedicated to a single organization

Hybrid Cloud – Public + Private का combination  
Hybrid Cloud – Combination of public and private cloud

---

## 🤔 Terraform की जरूरत क्यों?

Cloud resources manually create करना slow और error-prone होता है।

Creating cloud resources manually is slow and error-prone.

Terraform automation के माध्यम से infrastructure को code के रूप में manage करता है।

Terraform manages infrastructure as code using automation.
### 📌 Author  
**Pradip Gavhankar**  
*DevOps | Cloud | DevSecOps | FinOps Learning Journey*