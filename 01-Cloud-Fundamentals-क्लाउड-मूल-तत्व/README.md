# Cloud Fundamentals – क्लाउड मूल तत्व
## Imperative vs Declarative & Terraform Introduction
## इम्पेरेटिव vs डिक्लेरेटिव और टेरेफॉर्म परिचय

---

### 1. Site / Application Chalane ke Different Tarike

Koi bhi website ya application chalane ke liye mainly 4 options hote hain:

1. **Personal PC / Laptop**
2. **Killercoda** (Browser based free lab environment)
3. **On-Premises Server**
4. **Cloud** (AWS / Azure / Google Cloud)

Cloud sabse powerful, scalable aur industry standard option hai.

---

### 2. Cloud pe Resources Banane ke 3 Approaches

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

### 3. Imperative vs Declarative – Clear Difference

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

### 4. Why Terraform?

- **Multi-cloud** support (AWS + Azure + GCP + 3000+ providers)
- Human readable language → **HCL** (HashiCorp Configuration Language)
- Infrastructure as Code (IaC) ka industry standard tool
- Strong State Management
- Modules, Workspaces, CI/CD integration – sab support karta hai
- Azure ke liye official provider → **AzureRM**

---

### 5. Terraform Registry

Terraform Registry se providers aur modules milte hain.

- Azure ke liye main provider: `hashicorp/azurerm`
- Official website: [https://registry.terraform.io](https://registry.terraform.io)

---

### 6. Quick Mental Model

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
                      ├── ★★★ Terraform (Multi-cloud) ★★★
                      ├── Bicep
                      └── ARM Template

```

### ☁️ Cloud क्या है?

Cloud एक ऐसा सिस्टम है जहाँ हम servers, storage, databases और networking जैसी resources internet के माध्यम से use करते हैं।

Cloud is a system where we use servers, storage, databases, and networking resources over the internet.



### 🏢 On-Premise vs Cloud

On-Premise में servers और infrastructure हमारी अपनी company के अंदर होते हैं।

In On-Premise, servers and infrastructure are hosted inside the organization.

Cloud में infrastructure किसी third-party provider (जैसे AWS, Azure) के data center में होता है।

In Cloud, infrastructure is hosted in third-party data centers like AWS or Azure.

---
# Cloud Service Models – विस्तृत व्याख्या (IaaS | PaaS | SaaS)

> Cloud Computing के तीन मुख्य Service Models  
> AWS, Azure और Google Cloud के Examples के साथ

---

## 1. Cloud Service Models क्या हैं?

Cloud Service Models यह बताते हैं कि **cloud provider** कितना control और management आपके हाथ में छोड़ता है और कितना खुद संभालता है।

तीन मुख्य Models हैं:

1. **IaaS** – Infrastructure as a Service
2. **PaaS** – Platform as a Service
3. **SaaS** – Software as a Service

---

## 2. IaaS (Infrastructure as a Service)

### क्या है?
IaaS में cloud provider आपको **basic infrastructure** देता है जैसे:
- Virtual Machines (Compute)
- Storage
- Networking
- Load Balancers
- Firewalls

आप **Operating System** से ऊपर की सारी चीज़ें खुद manage करते हैं (OS, Runtime, Application, Data)।

### Characteristics
- सबसे ज्यादा control आपको मिलता है
- Flexibility बहुत high होती है
- Maintenance का काम भी ज्यादा करना पड़ता है
- Pay-as-you-go model

### Real-life Example
जैसे आपने जमीन ली (infrastructure), अब घर खुद बनाओगे।

### Major Cloud Examples

| Service Type          | AWS                          | Azure                              | Google Cloud                     |
|-----------------------|------------------------------|------------------------------------|----------------------------------|
| Virtual Machines      | **EC2**                      | **Virtual Machines**               | **Compute Engine**               |
| Storage               | S3, EBS                      | Blob Storage, Managed Disks        | Cloud Storage, Persistent Disk   |
| Networking            | VPC, Route 53                | Virtual Network, Azure DNS         | VPC, Cloud DNS                   |
| Load Balancer         | Elastic Load Balancing       | Azure Load Balancer                | Cloud Load Balancing             |
| Firewall / Security   | Security Groups, WAF         | Network Security Groups, Azure Firewall | Cloud Firewall, Cloud Armor   |

**Best Use Cases:**
- Custom applications जहाँ full control चाहिए
- Legacy applications migrate करना
- High performance computing
- Development और testing environments

---

## 3. PaaS (Platform as a Service)

### क्या है?
PaaS में cloud provider **platform** ready करके देता है।  
आपको सिर्फ **application code** लिखना और deploy करना होता है।

Provider manage करता है:
- Operating System
- Runtime (Java, .NET, Node.js, Python आदि)
- Middleware
- Scaling
- Patching और updates

### Characteristics
- Development बहुत fast हो जाता है
- Infrastructure manage करने की जरूरत नहीं
- Auto-scaling support
- Focus सिर्फ business logic पर रहता है

### Real-life Example
जैसे आपने ready-made घर ले लिया, अब सिर्फ interiors (application) लगाना है।

### Major Cloud Examples

| Service Type              | AWS                              | Azure                              | Google Cloud                     |
|---------------------------|----------------------------------|------------------------------------|----------------------------------|
| Application Platform      | **Elastic Beanstalk**            | **App Service**                    | **App Engine**                   |
| Container Platform        | ECS, EKS                         | Azure Kubernetes Service (AKS)     | Google Kubernetes Engine (GKE)   |
| Serverless Containers     | AWS Fargate                      | Azure Container Apps               | Cloud Run                        |
| Database Platform         | RDS, DynamoDB                    | Azure SQL, Cosmos DB               | Cloud SQL, Firestore             |
| Messaging / Queue         | SQS, SNS                         | Service Bus, Event Grid            | Pub/Sub                          |
| AI / ML Platform          | SageMaker                        | Azure Machine Learning             | Vertex AI                        |

**Best Use Cases:**
- Web applications और APIs
- Microservices
- Rapid development
- Teams जो infrastructure manage नहीं करना चाहते

---

## 4. SaaS (Software as a Service)

### क्या है?
SaaS में पूरा **software** ready-made मिलता है।  
आप बस internet से login करके use करते हो।

Provider सब कुछ manage करता है:
- Infrastructure
- Platform
- Application
- Data (ज्यादातर cases में)
- Security और updates

### Characteristics
- सबसे आसान model
- कोई installation या maintenance नहीं
- Subscription based (monthly/yearly)
- Multi-tenant architecture

### Real-life Example
जैसे आपने hotel में room book किया – सब कुछ ready है, सिर्फ use करो।

### Major Cloud Examples

| Category                | AWS Example              | Azure Example                  | Google Cloud Example           | Other Popular Examples      |
|-------------------------|--------------------------|--------------------------------|--------------------------------|-----------------------------|
| Email & Productivity    | Amazon WorkMail          | **Microsoft 365**              | Google Workspace               | Gmail, Outlook              |
| CRM                     | Amazon Connect           | Dynamics 365                   | -                              | **Salesforce**              |
| Collaboration           | Chime                    | Microsoft Teams                | Google Meet                    | Slack, Zoom                 |
| Storage & File Sharing  | -                        | OneDrive                       | Google Drive                   | Dropbox                     |
| HR / ERP                | -                        | Dynamics 365                   | -                              | Workday, SAP SuccessFactors |
| Security                | -                        | Microsoft Defender             | Chronicle                      | Okta                        |

**Best Use Cases:**
- Email, Office tools
- CRM, HR, Accounting software
- Collaboration tools
- जब आपको software instantly use करना हो

---

## 5. Comparison Table – IaaS vs PaaS vs SaaS

| Feature                    | IaaS                          | PaaS                              | SaaS                              |
|----------------------------|-------------------------------|-----------------------------------|-----------------------------------|
| Control Level              | बहुत ज्यादा                   | Medium                            | बहुत कम                           |
| Management Responsibility  | आप ज्यादा manage करते हो      | Provider ज्यादा manage करता है    | Provider लगभग सब manage करता है   |
| Flexibility                | Highest                       | Medium                            | Lowest                            |
| Development Speed          | Slow                          | Fast                              | Instant                           |
| Technical Knowledge        | High चाहिए                    | Medium                            | बहुत कम                           |
| Cost Model                 | Pay for resources used        | Pay for platform usage            | Subscription / per user           |
| Best For                   | Custom infra & full control   | Application development           | Ready-made software use           |
| Example                    | EC2, Azure VM, Compute Engine | App Service, Elastic Beanstalk, App Engine | Microsoft 365, Salesforce, Gmail |

---

## 6. Responsibility Matrix (कौन क्या manage करता है)

| Layer                      | IaaS     | PaaS     | SaaS     |
|----------------------------|----------|----------|----------|
| Applications               | आप       | आप       | Provider |
| Data                       | आप       | आप       | Provider |
| Runtime                    | आप       | Provider | Provider |
| Middleware                 | आप       | Provider | Provider |
| Operating System           | आप       | Provider | Provider |
| Virtualization             | Provider | Provider | Provider |
| Servers                    | Provider | Provider | Provider |
| Storage                    | Provider | Provider | Provider |
| Networking                 | Provider | Provider | Provider |

---

## 7. अन्य महत्वपूर्ण Cloud Models (Extra)

| Model          | Full Form                        | Description                                      | Example                          |
|----------------|----------------------------------|--------------------------------------------------|----------------------------------|
| **FaaS**       | Function as a Service            | Serverless functions – code run करो, server की चिंता मत करो | AWS Lambda, Azure Functions, Google Cloud Functions |
| **CaaS**       | Container as a Service           | Containers manage करने का platform               | AWS ECS/EKS, AKS, GKE            |
| **DBaaS**      | Database as a Service            | Managed databases                                | Amazon RDS, Azure SQL, Cloud SQL |
| **STaaS**      | Storage as a Service             | Cloud storage services                           | Amazon S3, Azure Blob, GCS       |
| **MaaS**       | Monitoring as a Service          | Monitoring और logging tools                      | CloudWatch, Azure Monitor, Cloud Monitoring |

---

## 8. Summary – आसानी से याद रखने वाला

- **IaaS** → "मुझे जमीन दो, घर मैं बनाऊंगा" (Full control)
- **PaaS** → "मुझे ready platform दो, मैं सिर्फ application लगाऊंगा"
- **SaaS** → "मुझे ready software दो, मैं सिर्फ use करूंगा"

**Expert Tip:**  
आजकल ज्यादातर modern applications **PaaS + FaaS** combination use करते हैं क्योंकि development तेज होता है और infrastructure का overhead कम रहता है।

---

**Next Recommendation:**  
अब Terraform से IaaS resources (Resource Group + Virtual Machine) और PaaS resources (App Service) दोनों create करके difference practically देखो।
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