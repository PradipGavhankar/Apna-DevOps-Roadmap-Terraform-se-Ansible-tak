# Reusable Google Cloud landing zone

This directory contains shared child modules and three independent Terraform
roots:

```text
google/
├── modules/
│   ├── application/   # Private regional MIG, health check, runtime identity
│   ├── edge/          # Global external HTTPS load balancer, managed TLS, WAF
│   ├── foundation/    # KMS, private artifact bucket, secret, centralized logs
│   └── network/       # Custom VPC, segmented private subnets, NAT, firewall
└── environments/
    ├── dev/
    ├── qa/
    └── prod/
```

Each environment is a separate root with its own **local Terraform state** by
default. Run Terraform from that environment's directory; do not run it from
this parent directory. No remote backend is configured and no resources are
applied by this repository. For team or production use, configure a separately
reviewed encrypted remote backend in each root before its first apply, and
migrate existing local state rather than starting a second state for deployed
resources.

## Prerequisites

- Terraform `>= 1.9.0`, `gcloud`, and an existing Google Cloud project with
  billing enabled.
- Application Default Credentials, e.g. `gcloud auth application-default
  login`, using a deployer identity permitted to enable listed APIs and create
  the network, Compute Engine, load-balancing, Cloud Armor, IAM, KMS, Storage,
  Secret Manager, and Logging resources.
- A real, publicly controlled fully qualified domain name for every requested
  certificate name, plus a globally unique bucket name. The project must have
  quota/capacity for at least two MIG VMs in two zones.

Set the required `project_id`, `certificate_domains`, and
`artifact_bucket_name` values in a local, untracked `terraform.tfvars` for the
chosen environment or pass them on the command line. No fake project ID or
placeholder certificate domain is set as a default. The certificate-domain
variable is required, rejects an empty list, and is validated for DNS-name
syntax, so an unset value cannot silently plan a dummy certificate.

## Initialize, format, validate, and plan

PowerShell example for **dev** (repeat from `environments\qa` or
`environments\prod` to work with those independent states):

```powershell
Set-Location .\environments\dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan `
  -var="project_id=YOUR_EXISTING_PROJECT_ID" `
  -var='certificate_domains=["app.your-real-domain.tld"]' `
  -var="artifact_bucket_name=YOUR_GLOBALLY_UNIQUE_BUCKET_NAME"
```

Replace every uppercase placeholder with values that you control. Supply all
real domains in the list, e.g.
`-var='certificate_domains=["app.your-domain.tld","api.your-domain.tld"]'`.
Do not put production values or secrets in version-controlled tfvars. A
`terraform.tfvars` file in each environment root is ignored by the global
`.gitignore` only if your project has configured it; otherwise add it to your
local excludes before writing credentials or sensitive values.

Run formatting from this parent folder across the module and environment
sources with:

```powershell
terraform fmt -recursive
```

Initialize and validate **each root independently**:

```powershell
foreach ($envName in @("dev", "qa", "prod")) {
  Push-Location ".\environments\$envName"
  terraform init
  terraform validate
  Pop-Location
}
```

Review plans for all expected charges and resource replacement before any
separate `terraform apply`. This README intentionally does not include apply
instructions.

## Environment defaults

| Root | Region | Private subnet | Machine type | Minimum / maximum instances | Log retention |
| --- | --- | --- | --- | --- | --- |
| `dev` | `us-central1` | app `10.20.0.0/20`, data `10.20.16.0/20`, management `10.20.32.0/20` | `e2-small` | 2 / 4 | 30 days |
| `qa` | `us-central1` | app `10.30.0.0/20`, data `10.30.16.0/20`, management `10.30.32.0/20` | `e2-medium` | 2 / 6 | 30 days |
| `prod` | `us-central1` | app `10.40.0.0/20`, data `10.40.16.0/20`, management `10.40.32.0/20` | `e2-standard-2` | 3 / 12 | 90 days |

Override defaults through input variables as needed. Keep subnet ranges
non-overlapping with connected networks and other environments when they share
a VPC network topology; this configuration creates a separate VPC per root.
Use a distinct resource prefix and unique bucket for each environment, even
when roots target the same Google Cloud project.

## DNS and certificate readiness

After a separately reviewed deployment, get the public address using
`terraform output load_balancer_ipv4` from the selected environment root. Add
an A record for **each** name in `certificate_domains` pointing at this IPv4
address. Remove conflicting A/AAAA records or intermediary proxies that
prevent Google's certificate validation. Google-managed certificate
provisioning remains pending until public DNS resolves correctly and issuance
completes; HTTPS is not ready until the certificate is active. The HTTP
frontend redirects to HTTPS; it does not expose the application over cleartext.

## Architecture and security

- A custom-mode VPC has separate regional application, data, and management
  subnets with Private Google Access and sampled VPC Flow Logs. The global
  external load balancer is Google-managed and does not occupy a frontend
  subnet. Cloud NAT allows private VMs outbound connectivity without assigning
  external IP addresses. Egress firewall rules allow DNS and TCP 80/443, then
  deny other tagged-instance egress.
- The regional MIG is distributed across up to two available zones, starts
  with at least two instances, and autos-scales by CPU. Instances have no
  public IP, SSH is permitted only through Identity-Aware Proxy (IAP), OS Login enabled, project SSH keys blocked,
  serial ports disabled, and Shielded VM Secure Boot, vTPM, and integrity
  monitoring enabled.
- A dedicated runtime service account has only log- and metric-writer roles.
  Grant human OS Login and IAP tunnel permissions separately; this module does
  not grant interactive access. The startup script installs a simple nginx health
  endpoint and the Cloud Ops agent as a demonstration backend, not as a
  production application release process. Replace it with a reviewed image
  pipeline before production deployment.
- The public frontend is a global external managed Application Load Balancer
  with a Google-managed TLS certificate, HTTP-to-HTTPS redirect, and Cloud
  Armor SQLi/XSS/LFI preconfigured WAF rules. Backend access is limited to
  Google's load-balancer/health-check source ranges. Exercise WAF rules in a
  representative environment and tune before production.
- A project-level sink routes GCE instance and subnet flow logs into a regional
  Logging bucket. The VM Ops agent also writes logs and metrics. Add alert
  policies, notification channels, audit-log routing, and organization-level
  controls to meet operational/compliance requirements.
- A regional Cloud KMS key (90-day rotation) encrypts a versioned, private,
  uniform-access artifact bucket and an empty Secret Manager secret. The
  secret resource contains no secret value/version. Bucket object retention is
  30 days by default and is not locked; retained objects and CMEK dependencies
  can affect deletion order. Restrict KMS access and define key recovery and
  retirement procedures.

## Cost and lifecycle

These roots are not low-cost sandboxes: each maintains at least two VMs
(production defaults to three), plus balanced boot disks, a global external
load balancer and reserved IPv4 address, Cloud Armor, Cloud NAT and processed
egress, Cloud Logging ingestion/storage, KMS operations, Cloud Storage, and
Secret Manager. Costs vary with region, VM uptime/size, traffic, autoscaling,
log volume, and retention. Check current Google Cloud pricing and quotas before
planning. The artifact bucket uses `force_destroy = false`; never remove the
KMS key while encrypted objects or secrets still depend on it.
