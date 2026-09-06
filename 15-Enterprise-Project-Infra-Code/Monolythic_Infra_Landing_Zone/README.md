# Monolithic Infra Landing Zone
**Centralized Monolithic Application Platform – Azure**

Ye code High-Level Design (HLD) ke hisaab se banaya gaya hai jo tune share kiya tha.

### Architecture Mapping (Diagram → Azure)

| Diagram Component              | Azure Resource                          |
|--------------------------------|-----------------------------------------|
| Virtual Private Cloud (VPC)    | Virtual Network + Subnets               |
| Front-end Access / WAF         | Network Security Group + App Gateway (optional) |
| API Gateway                    | Application Gateway / API Management    |
| Application Logic              | Subnet (App tier)                       |
| Shared Database                | Subnet (Data tier) + Private DNS        |
| Cache (Redis)                  | Subnet (Cache tier)                     |
| Security & Management          | NSG + Key Vault + Log Analytics         |
| Monitoring & Logging           | Log Analytics Workspace                 |

---

## How to Use

```bash
cd Monolithic_Infra_Landing_Zone

# 1. Backend configure karo (backend.tf me values change karo)
terraform init

# 2. Plan
terraform plan

# 3. Apply
terraform apply
```

---

## What will be created

- Resource Group
- Virtual Network (10.10.0.0/16)
- 4 Subnets:
  - frontend
  - application
  - data
  - management
- Network Security Groups
- Key Vault
- Log Analytics Workspace
- Storage Account (diagnostics)


### Simple HLD – Monolithic Application Platform (Azure)
```
                          USERS
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
     Web Users        Mobile Users      3rd Party
          │                 │                 │
          └─────────────────┼─────────────────┘
                            │
                            ▼
               ┌─────────────────────────┐
               │     FRONT-END TIER      │
               │  (WAF + API Gateway)    │
               │                         │
               │  - Public Subnet        │
               │  - Network Security     │
               │  - Application Gateway  │
               └────────────┬────────────┘
                            │
                            ▼
               ┌─────────────────────────┐
               │   APPLICATION TIER      │
               │  (Monolithic App)       │
               │                         │
               │  - App Subnet           │
               │  - BFF + Business Logic │
               │  - Cache Layer          │
               └────────────┬────────────┘
                            │
                            ▼
               ┌─────────────────────────┐
               │      DATA TIER          │
               │                         │
               │  - Data Subnet          │
               │  - SQL / PostgreSQL     │
               │  - NoSQL (optional)     │
               │  - Redis Cache          │
               └─────────────────────────┘
```
### Complete Resource List (Jo Terraform banayega)
```
Layer,Azure Resource,Purpose,Terraform me Status
Foundation,Resource Group,Sab resources ka container,✅ Banega
Networking,Virtual Network (10.10.0.0/16),Private network (VPC jaisa),✅ Banega
,Subnet - frontend,WAF / API Gateway / Public access,✅ Banega
,Subnet - application,Monolithic App + BFF + Logic,✅ Banega
,Subnet - data,Database + Cache,✅ Banega
,Subnet - management,Jump box / Monitoring / Management,✅ Banega
Security,Network Security Group (NSG),Firewall rules,✅ Banega
,Key Vault,Secrets + Encryption keys,✅ Banega
Monitoring,Log Analytics Workspace,Logs + Monitoring,✅ Banega
Storage,Storage Account,Diagnostics / Logs / General storage,✅ Banega
Optional (Next),Application Gateway + WAF,Front-end entry point,Baad me add kar sakte ho
,Azure SQL / PostgreSQL,Transactional Database,Baad me add kar sakte ho
,Azure Cache for Redis,In-memory cache,Baad me add kar sakte ho
,App Service / VM / Container,Actual application deploy,Baad me add kar sakte ho
```
### Simple LLD (Low Level Design) – Actual Resources

```
Resource Group: monolith-dev-rg
│
├── Virtual Network: monolith-dev-vnet (10.10.0.0/16)
│   ├── frontend-snet     (10.10.1.0/24)  ← WAF / API Gateway
│   ├── application-snet  (10.10.2.0/24)  ← App + BFF + Logic
│   ├── data-snet         (10.10.3.0/24)  ← DB + Redis
│   └── management-snet   (10.10.4.0/24)  ← Monitoring / Admin
│
├── Network Security Group: monolith-dev-nsg
│   ├── Allow HTTPS (443)
│   └── Allow HTTP  (80)
│
├── Key Vault: monolith-dev-kv
│
├── Log Analytics: monolith-dev-law
│
└── Storage Account: monolithdevsaXXXX
```
Powershell commands1
```
# Resource Group for State
az group create --name tfstate-rg --location eastus

# Storage Account (naam globally unique hona chahiye)
az storage account create `
  --name tfstatepradip001 `
  --resource-group tfstate-rg `
  --location eastus `
  --sku Standard_LRS `
  --encryption-services blob

# Container banao
az storage container create `
  --name tfstate `
  --account-name tfstatepradip001
```
Powershell commands 2
```
# Clean start (optional but recommended)
Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue
Remove-Item -Force .terraform.lock.hcl -ErrorAction SilentlyContinue

# Init with backend
terraform init

# Agar pehle local state tha to ye poochhega → "yes" bolna
# Plan
terraform plan

# Apply
terraform apply
```
---

## Author
**Pradip Gavhankar**
```
