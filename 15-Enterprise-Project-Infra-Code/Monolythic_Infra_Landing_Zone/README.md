# Monolithic Landing Zone | AWS, Azure and Google Cloud

**Purpose:** production-minded infrastructure foundation for a centralized
monolithic application, implemented with Terraform for three cloud providers.
The resource comparison lives in
[Complete Resource List (Jo Terraform banayega).csv](./Complete%20Resource%20List%20(Jo%20Terraform%20banayega).csv).

> **Production-readiness statement:** This repository is a strong starting
> foundation, not a claim that a workload is approved or ready for production.
> The Terraform creates real cloud resources, but it does not create the
> application, database, full operations process, or every organization-specific
> control. Close the production gates in this document, review the exact plan,
> and get the relevant platform/security approvals before applying it.
> Terraform code has not been applied or validated against your cloud accounts
> as part of writing this document.

## 1. Simple overview

Monolithic ka matlab hai application ke main business features ek coordinated
application/release ke roop mein run hote hain. Iska matlab yeh **nahi** hai
ki network flat hona chahiye. Is design mein public traffic ek controlled edge
par aata hai, phir private application compute tak jaata hai. Data aur
management ke liye alag network segments rakhe gaye hain.

Typical request flow:

```text
Customer/browser
      |
      | HTTPS
      v
Cloud load balancer + WAF
      |
      | private backend traffic
      v
Private application compute
      |
      +----> Database/cache (not provisioned in these Terraform stacks)
      +----> Secret, logging and other cloud services
```

Current VM/instance startup scripts install a small Nginx health/demo page.
Yeh production business application nahi hai. A real deployment should use a
reviewed application image and a controlled release/rollback pipeline.

## 2. Repository map

| Path | Role |
| --- | --- |
| `AWS/` | Shared landing-zone module plus independent `dev`, `qa`, and `prod` roots. See [AWS README](./AWS/README.md). |
| `azurerm_dev_prod/` | Shared Azure root module plus independent `dev`, `qa`, and `prod` roots. See [Azure README](./azurerm_dev_prod/README.md). |
| `google/` | Shared network, application, edge, and foundation modules plus independent `dev`, `qa`, and `prod` roots. See [Google Cloud README](./google/README.md). |
| `Complete Resource List (Jo Terraform banayega).csv` | Provider-by-provider resource comparison, Hinglish purpose, current implementation status, and production gaps. |

Each environment directory is a separate Terraform root. Initialize and plan
from that environment root, not from the shared parent directory. Each root
normally manages a separate state.

## 3. What is actually implemented

The exact, row-by-row provider comparison is in the CSV. These are the main
capabilities and important differences:

| Capability | AWS | Microsoft Azure | Google Cloud |
| --- | --- | --- | --- |
| Network | VPC with ingress, application, data, and management subnets across two AZs; NAT egress for app subnets. | Resource Group, VNet, frontend, application, data, management, and dedicated Application Gateway subnets; NAT Gateway for app egress. | Custom VPC with regional application, data, and management subnets; Cloud Router/NAT. Global load balancer is outside the subnet. |
| Public edge | Internet-facing Application Load Balancer, AWS WAF, HTTP-to-HTTPS redirect. | WAF_v2 Application Gateway, OWASP managed rules, HTTP-to-HTTPS redirect. | Global external managed HTTPS load balancer, Cloud Armor, HTTP-to-HTTPS redirect. |
| TLS | Must provide an existing, issued ACM certificate in the ALB region. | Must provide an existing PFX certificate as a Key Vault secret. | Terraform creates a Google-managed certificate; public DNS must point each certificate name to the output IP before it becomes active. |
| App compute | Private EC2 Auto Scaling Group across two AZs; sample Nginx/CloudWatch agent bootstrap. | One private Linux VM per environment; sample Nginx cloud-init. Application Gateway autoscaling does not scale this VM. | Private regional Managed Instance Group across up to two zones, CPU autoscaler and health-based autohealing; sample Nginx/Ops agent bootstrap. |
| Identity | EC2 instance profile for SSM and application log delivery; no public IP or SSH key. | User-assigned identity is used by Application Gateway to read its certificate. VM login requires an SSH public key, but no public VM IP or admin jump path is provisioned. | Dedicated runtime service account with log/metric writer roles; OS Login and IAP settings are enabled. Human access grants must be arranged separately. |
| Logs and storage | Encrypted CloudWatch log groups and VPC Flow Logs; private, versioned, KMS-encrypted S3 bucket. The S3 bucket is not connected as the ALB access-log destination. | Log Analytics Workspace, VM boot diagnostics, and a Storage Account. Resource diagnostic routing is not configured. | Project log sink and regional Logging bucket, VM Cloud Ops agent, and private CMEK-encrypted artifact bucket with retention. |
| Data services | No database or cache; data subnets only. | No database or cache; data subnet only. | No database or cache; data subnet only. |

**Important:** “subnet created” or “secret container created” does not mean a
database, application secret value, or management service has been deployed.
Check the CSV status column before treating any component as available.

## 4. Environment defaults

These are code defaults, not a recommendation to use the same sizing in every
real workload. Confirm region availability, quotas, workload sizing, resilience
objectives, and cost before changing or applying them.

| Cloud / environment | Region | App compute defaults | Scaling / resilience defaults | Network / storage notes |
| --- | --- | --- | --- | --- |
| AWS dev | `us-east-1` | `t3.micro`, ASG min/desired/max `1/1/2` | Two AZ subnets; a single shared NAT Gateway | VPC `10.20.0.0/16` |
| AWS qa | `us-east-1` | `t3.small`, `2/2/3` | Two AZ subnets; a single shared NAT Gateway | VPC `10.30.0.0/16` |
| AWS prod | `us-east-1` | `t3.medium`, `2/2/6` | Two AZ subnets; one NAT Gateway per AZ; ALB deletion protection | VPC `10.40.0.0/16` |
| Azure dev | `eastus` | One `Standard_B2s` Linux VM | WAF_v2 Application Gateway autoscale `1–2`; backend remains one VM | Storage replication LRS |
| Azure qa | `eastus` | One `Standard_D2s_v5` Linux VM | WAF_v2 Application Gateway autoscale `1–3`; backend remains one VM | Storage replication LRS |
| Azure prod | `eastus` | One `Standard_D2s_v5` Linux VM | WAF_v2 Application Gateway autoscale `2–10`; backend remains one VM | Storage replication GRS |
| Google dev | `us-central1` | `e2-small`; minimum/maximum MIG `2/4` | Regional MIG across up to two zones; CPU autoscaler | App subnet `10.20.0.0/20`; data `10.20.16.0/20`; management `10.20.32.0/20` |
| Google qa | `us-central1` | `e2-medium`; `2/6` | Regional MIG across up to two zones; CPU autoscaler | App subnet `10.30.0.0/20`; data `10.30.16.0/20`; management `10.30.32.0/20` |
| Google prod | `us-central1` | `e2-standard-2`; `3/12` | Regional MIG across up to two zones; CPU autoscaler | App subnet `10.40.0.0/20`; data `10.40.16.0/20`; management `10.40.32.0/20`; 90-day log retention |

AWS `single` NAT saves cost but creates a zonal egress dependency. Azure currently
has a single backend VM in every environment, so the application tier is not
highly available even when its Application Gateway scales out. Review these
trade-offs against the service's availability target.

## 5. Production gates before the first real deployment

Treat these as go-live requirements, not optional polish. Record the decision,
owner, and evidence in your normal change process.

| Gate | Current code status | Production action |
| --- | --- | --- |
| Terraform state | All provider environment roots use local state by default. Azure's sample backend block is commented out. | Configure a secure remote backend per environment with encryption, locking, restricted access, versioning/backup, recovery procedure, and audit logs. Do not commit state or plan files. |
| Environment/account isolation | Separate Terraform roots exist, but the code does not create cloud accounts, subscriptions, or projects. | Confirm which cloud account/subscription/project each root targets; use separate production identity and approval boundaries. |
| Application deployment | Bootstrap installs demo Nginx; there is no business application release pipeline. | Build/scanning/signing process for immutable images, secret injection, staged rollout, rollback, and ownership. |
| Application availability | AWS has an ASG but no scaling policy and dev permits one node. Azure has one VM. Google has a regional MIG/autoscaler. | Meet the workload's availability/SLO target; add or tune scale-out, health checks, capacity reservation, and failure testing where needed. |
| Database and cache | No provider deploys a database or cache. Data subnets are network segments only. | Select managed services; design private access/DNS, HA, encryption, backup, restore, patching, failover, and RPO/RTO. |
| Network and admin access | No end-to-end enterprise connectivity or admin jump service is provisioned. | Validate CIDRs, private DNS, VPN/interconnect, egress allowlists, subnet NSGs/firewalls, privileged access, and break-glass procedures. Test that required admin access works without opening public SSH. |
| Identity and secrets | Empty secret containers exist in AWS/GCP; Azure expects an existing Key Vault PFX. | Review least-privilege deployer/runtime roles, certificate and secret rotation, access reviews, audit logs, and delivery to the application. Never commit credentials or secret values. |
| Logging and alerting | Some log collection exists, but alerts are not configured; Azure resource diagnostic routing is not configured. | Define SLO dashboards, actionable alerts, notification ownership, audit/security log retention, redaction, and incident runbooks. Test a notification end-to-end. |
| Backup and disaster recovery | No complete application/data backup or tested regional recovery plan is included. | Agree RPO/RTO, implement backups/replication, and regularly test restore and failover—including key and DNS dependencies. |
| Security controls | WAF, network rules, encryption, and some identity controls exist; organization-wide policy/compliance is outside these stacks. | Tune WAF using representative traffic; run code/IaC/image scans; apply cloud guardrails; review exposure, patching, vulnerability response, and compliance evidence. |
| Lifecycle protection | AWS production ALB deletion protection is enabled; Azure Resource Group/storage `prevent_destroy` is false; Google artifact bucket is non-force-destroy. | Add appropriate deletion/retention protection, controlled break-glass changes, and a tested decommission procedure. Verify provider-specific deletion and recovery behavior. |
| Cost and quota | Cloud resources incur ongoing charges; no budget/alert policy is created here. | Estimate regional compute, gateway/WAF, NAT, public IP, storage, logging, and egress costs; set budgets/alerts and check quotas before approval. |
| Change governance | Terraform plan is the review artifact; no CI/CD approval workflow is included. | Require peer-reviewed plan, automated policy/security checks, environment-specific approval, protected state, and an auditable apply identity. |

## 6. Prerequisites and safe Terraform workflow

Install a Terraform version that satisfies the selected root's `required_version`,
the matching cloud CLI, and approved cloud credentials. Confirm that your
identity has only the permissions required for the planned resources. Keep
provider lock files under source control and review provider upgrades.

For each command below, replace placeholders with values belonging to your
organization. Store environment inputs in an untracked, access-controlled
`terraform.tfvars` in that environment root, or use your approved secrets
injection method. Do not put private keys, credentials, or production secrets
in this README or a committed tfvars file.

### AWS

```powershell
Set-Location .\AWS
terraform fmt -recursive
terraform -chdir=environments\dev init
terraform -chdir=environments\dev validate
terraform -chdir=environments\dev plan
```

Repeat `init`, `validate`, and `plan` from `environments\qa` and
`environments\prod` using the corresponding `-chdir` path. Provide a real,
issued ACM certificate ARN in the same region as the ALB; the required
`acm_certificate_arn` input has no deployable placeholder. Review the plan for
NAT cost, AZs, instance capacity, CIDRs, and certificate before approval.

### Microsoft Azure

```powershell
Set-Location .\azurerm_dev_prod
terraform fmt -recursive
terraform -chdir=environments\dev init
terraform -chdir=environments\dev validate
terraform -chdir=environments\dev plan
```

Repeat for `qa` and `prod`. Each environment root requires an OpenSSH public key
and a versionless Key Vault secret URI for an already imported PFX certificate.
Supply these through that environment's untracked tfvars or an approved
environment-variable/secret mechanism. The `terraform.tfvars` at
`azurerm_dev_prod\` is not automatically loaded when Terraform runs from a
nested environment root. Confirm that the selected Azure region supports the
requested VM and Application Gateway SKUs.

### Google Cloud

```powershell
Set-Location .\google
terraform fmt -recursive
terraform -chdir=environments\dev init
terraform -chdir=environments\dev validate
terraform -chdir=environments\dev plan `
  -var="project_id=YOUR_EXISTING_BILLING_ENABLED_PROJECT" `
  -var='certificate_domains=["app.your-real-domain.example"]' `
  -var="artifact_bucket_name=YOUR_GLOBALLY_UNIQUE_BUCKET_NAME"
```

Repeat for `qa` and `prod`, using an environment-specific project/prefix and a
globally unique bucket name. Use a public DNS domain you control. After the
approved deployment, point every certificate domain's A record to
`terraform output load_balancer_ipv4`; managed TLS remains pending until
Google can validate the DNS. Confirm API enablement permission, quotas, billing,
regional capacity, and the cost of the global load balancer, NAT, WAF, VMs, and
logging.

### Apply and change controls

`terraform plan` is a preview, not a deployment. Have an authorized reviewer
inspect the saved plan or the exact CI plan output, including replacements and
deletions, cost impact, IAM/network changes, and provider-specific warnings.
Apply only through the organization's approved change pipeline/identity after
the production gates are met. Do not apply all three clouds or environments
from one shared state. A failed or interrupted apply should be diagnosed from
the Terraform output and cloud activity logs before retrying.

## 7. Operational notes

- Terraform files in one directory form one root module even when split across
  multiple `.tf` files. The shared modules are called from independent
  environment roots.
- The AWS S3 bucket is a private diagnostic-storage foundation; ALB access
  logging is not configured to deliver to it.
- Azure's Log Analytics Workspace does not by itself route every resource's
  logs. Add and test the needed Azure Monitor diagnostic settings and alerts.
- AWS and Google Cloud secret resources are empty containers: no secret value
  is created. Azure's Application Gateway certificate secret must exist before
  its plan/apply can complete.
- Google Cloud log and artifact retention, Key Management Service dependencies,
  and Azure Key Vault soft-delete/purge protection can affect cleanup. Never
  remove encryption keys or retained data without checking dependencies and
  recovery requirements.
- Keep state, plan files, private keys, credentials, and production tfvars out
  of source control. Restrict access to CI logs and Terraform state as well.
- Provider READMEs contain provider-specific setup details and should be read
  alongside this overview.

## 8. Meaning of “production-ready”

Production-ready ka matlab sirf Terraform `apply` successful hona nahi hai.
Iska matlab hai ki design approved SLO/security/compliance requirements meet
karta hai, owners and responders assigned hain, recovery tested hai, cost
accepted hai, aur changes safely repeat/rollback kiye ja sakte hain. Is
repository ke code se ek production-oriented base milta hai; final readiness
workload, account configuration, operational controls, and evidence par depend
karti hai.
