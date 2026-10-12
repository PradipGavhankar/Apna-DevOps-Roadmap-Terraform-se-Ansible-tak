variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID with billing enabled."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Set project_id to a valid, existing Google Cloud project ID."
  }
}

variable "region" {
  type        = string
  description = "GCP region for the VPC subnet, MIG, NAT, logs, and KMS."
  default     = "us-central1"
}

variable "certificate_domains" {
  type        = list(string)
  description = "Real public DNS names for the managed certificate; required and must point to the output IP."

  validation {
    condition     = length(var.certificate_domains) > 0 && alltrue([for domain in var.certificate_domains : length(domain) <= 253 && can(regex("^([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?\\.)+[A-Za-z]{2,63}$", domain))])
    error_message = "Provide at least one valid fully qualified DNS name. No placeholder certificate domains are configured."
  }
}

variable "artifact_bucket_name" {
  type        = string
  description = "Globally unique name for the private CMEK-encrypted artifact bucket; required."
}

variable "resource_prefix" {
  type        = string
  description = "Unique short prefix for this environment's resources."
  default     = "lz-dev"

  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,33}[a-z0-9])?$", var.resource_prefix))
    error_message = "resource_prefix must start with a lowercase letter and contain lowercase letters, digits, or hyphens."
  }
}

variable "subnet_cidr" {
  type        = string
  description = "Non-overlapping private application subnet CIDR."
  default     = "10.20.0.0/20"

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "subnet_cidr must be a valid IPv4 CIDR."
  }
}

variable "data_subnet_cidr" {
  type        = string
  description = "Non-overlapping data-service subnet CIDR."
  default     = "10.20.16.0/20"

  validation {
    condition     = can(cidrnetmask(var.data_subnet_cidr))
    error_message = "data_subnet_cidr must be a valid IPv4 CIDR."
  }
}

variable "management_subnet_cidr" {
  type        = string
  description = "Non-overlapping management subnet CIDR."
  default     = "10.20.32.0/20"

  validation {
    condition     = can(cidrnetmask(var.management_subnet_cidr))
    error_message = "management_subnet_cidr must be a valid IPv4 CIDR."
  }
}

variable "machine_type" {
  type        = string
  description = "Compute machine type used by the MIG."
  default     = "e2-small"
}

variable "boot_image" {
  type        = string
  description = "Compute image family or self-link."
  default     = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
}

variable "min_replicas" {
  type        = number
  description = "Minimum MIG size across available zones."
  default     = 2

  validation {
    condition     = var.min_replicas >= 2 && var.min_replicas <= 20
    error_message = "min_replicas must be between 2 and 20."
  }
}

variable "max_replicas" {
  type        = number
  description = "Maximum autoscaled MIG size."
  default     = 4

  validation {
    condition     = var.max_replicas >= var.min_replicas && var.max_replicas <= 100
    error_message = "max_replicas must be at least min_replicas and no more than 100."
  }
}

variable "log_retention_days" {
  type        = number
  description = "Retention of the dedicated regional operations logging bucket."
  default     = 30
}

variable "artifact_retention_seconds" {
  type        = number
  description = "Minimum object retention in the artifact bucket. Retention can delay deletion."
  default     = 2592000
}
