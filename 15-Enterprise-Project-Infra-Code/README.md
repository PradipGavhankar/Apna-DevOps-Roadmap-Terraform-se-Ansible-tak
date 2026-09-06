# 15 – Enterprise Project Infra Code
**Advanced Azure Landing Zone Style Project (Production Grade)**

---

## 🎯 Goal

Is folder me aap **real enterprise-level Terraform** practice karoge.

Ye project cover karta hai:

- Remote Backend + State Locking
- Reusable Modules
- `for_each` (map based)
- `lifecycle` blocks
- `dynamic` blocks
- Consistent Naming Convention
- Centralized Tags
- Variable Validation
- Environment separation (dev / prod)
- Clean folder structure

---

## 📁 Recommended Folder Structure

```text
15-Enterprise-Project-Infra-Code/
├── README.md
├── modules/
│   ├── resource-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── virtual-network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network-security-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── storage-account/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
└── shared/
    └── naming.tf          # optional common locals
```

---

## 🏗️ Architecture Overview

```text
Subscription
│
├── Resource Group (per environment)
│
├── Virtual Network
│   ├── Frontend Subnet
│   ├── Backend Subnet
│   └── Data Subnet
│
├── Network Security Group (dynamic rules)
│
└── Storage Account (unique name + lifecycle)
```

---

## 🔑 Key Advanced Concepts Used

| Concept              | Where Used                          |
|----------------------|-------------------------------------|
| Remote Backend       | `backend.tf`                        |
| Modules              | `modules/` folder                   |
| for_each             | Subnets + multiple resources        |
| dynamic blocks       | NSG security rules                  |
| lifecycle            | Storage Account + prevent_destroy   |
| Naming Convention    | `join()`, `lower()`, locals         |
| Tags                 | `merge()`                           |
| Validation           | `variable` validation blocks        |

---

## 🚀 How to Use

### 1. Backend Setup (one-time)

Azure me Storage Account + Container banao (State ke liye).

### 2. Dev Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### 3. Prod Environment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

---

## 📌 Naming Convention Used

```text
<project>-<environment>-<resource>-<instance>
Example: payment-dev-rg
         payment-prod-vnet
         payment-dev-frontend-snet
```

---

## ✅ Production Best Practices Demonstrated

- Modules for reusability
- Remote state with locking
- Environment isolation
- Consistent tagging
- Input validation
- Lifecycle protection
- Dynamic blocks for flexible rules
- No hardcoding of sensitive values


---
Landing Zone,Kya banega (High Level),Complexity
Monolithic_Infra,1 RG + 1 VNet + App Subnet + DB Subnet + NSG + Storage,Beginner-Advanced
Microservices_Landing_Zone,Multiple RGs / App subnets + AKS ready networking + NSGs,Medium
Data_Infra_Landing_Zone,Data RG + Storage + SQL/Synapse networking + Private Endpoints,Medium-High
ML_Infra_Landing_Zone,ML RG + Compute + Storage + Key Vault + Networking,High
Agentic_AI_Landing_Zone,AI RG + OpenAI / AI Services ready + Networking + Security,High

## 📌 Author

**Pradip Gavhankar**  
*DevOps | Cloud | DevSecOps | FinOps | AIOps | MLOps Learning Journey*
```
