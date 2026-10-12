# AWS landing zone

Reusable Terraform configuration with three independent environment roots and a shared child module:

```text
modules/landing-zone/     Shared VPC, ALB/WAF, private ASG, IAM, KMS and logging resources
environments/dev/         Lower-cost development defaults
environments/qa/          QA defaults
environments/prod/        Production-oriented multi-AZ defaults
```

Each environment is a separate Terraform root and therefore has its own state. State is local by default; no remote backend is configured. Configure an encrypted, access-controlled remote backend and locking for team or production use before initializing shared infrastructure.

## What it provisions

- A VPC split into public ingress, private application, and isolated database/management subnets across two AZs.
- An internet-facing ALB with HTTP-to-HTTPS redirect, an existing ACM certificate, and a regional WAF using AWS managed common protections.
- A private EC2 Auto Scaling backend with no SSH/key pair or public IP, SSM access, encrypted gp3 storage, and IMDSv2 required.
- Security groups restricting public traffic to ALB 80/443 and backend ingress to ALB-originated HTTP; backend egress is HTTPS-only.
- Single-AZ or per-AZ NAT egress, encrypted/versioned private S3 diagnostic storage, KMS key rotation, encrypted CloudWatch/WAF logs, and VPC Flow Logs.

The database and management subnets are isolated foundations only. The diagnostic S3 bucket is not configured as an ALB access-log destination. The SSM-managed instance installs nginx at boot and forwards nginx logs to CloudWatch; replace this sample workload with your application and review its IAM/network needs.

## Environment defaults

| Root | VPC CIDR | Instance type | ASG min/desired/max | NAT |
| --- | --- | --- | --- | --- |
| `dev` | `10.20.0.0/16` | `t3.micro` | `1/1/2` | One shared gateway |
| `qa` | `10.30.0.0/16` | `t3.small` | `2/2/3` | One shared gateway |
| `prod` | `10.40.0.0/16` | `t3.medium` | `2/2/6` | One per AZ |

All roots span two AZs. The lower-cost shared-NAT option introduces a zonal egress dependency; the dev ASG can run one node, so it does not guarantee simultaneous backend capacity in both AZs. The production ALB has deletion protection enabled. NAT, ALB, WAF, EC2, CloudWatch, KMS, S3, data transfer, and public IPv4 have ongoing charges; estimate current regional prices before deployment.

## Prerequisites and certificate safety

- Terraform 1.9 or later and AWS provider 5.x or 6.x.
- AWS credentials with permissions for the resources in the module.
- An **existing, issued ACM certificate in the selected AWS region**, valid for the hostname clients will use. The certificate ARN is required; there is deliberately no default, fake account ID, or deployable placeholder certificate. Planning without it fails validation. Terraform does not create the certificate or DNS record.

Set `acm_certificate_arn` in an untracked `terraform.tfvars` file inside the environment root, using the real certificate ARN from your account. Do not commit account-specific values or credentials. Alternatively, set `TF_VAR_acm_certificate_arn` in your shell. Make sure the certificate is in the same region as the ALB and covers the intended hostname.

## Format, initialize, validate, plan

Run from the `AWS` directory:

```powershell
terraform fmt -recursive
terraform -chdir=environments/dev init
terraform -chdir=environments/dev validate
terraform -chdir=environments/dev plan
```

Repeat `init`, `validate`, and `plan` with `qa` or `prod` as appropriate. Each root initializes and stores state independently. Review the plan, CIDRs, AZs, certificate, capacity, and NAT choice carefully. This configuration has not been applied.

To configure a remote backend, add the backend stanza to the selected environment root and follow Terraform's state migration workflow. Do not share local state files or commit plans, state, or tfvars files.
