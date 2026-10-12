variable "project_name" {
  type        = string
  description = "Project name"
  default     = "monolith"
}

variable "environment" {
  type        = string
  description = "Environment (dev/qa/prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa or prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "West Europe"
}

variable "owner" {
  type    = string
  default = "platform-team"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}

variable "subnets" {
  type = map(object({
    address_prefix = string
  }))
  default = {
    frontend    = { address_prefix = "10.10.1.0/24" }
    application = { address_prefix = "10.10.2.0/24" }
    data        = { address_prefix = "10.10.3.0/24" }
    management  = { address_prefix = "10.10.4.0/24" }
    app_gateway = { address_prefix = "10.10.5.0/24" }
  }
}

variable "admin_username" {
  type        = string
  description = "Linux VM administrator account name."
  default     = "azureadmin"
}

variable "linux_vm_size" {
  type        = string
  description = "Azure VM size for the private application backend."
  default     = "Standard_B2s"
}

variable "app_gateway_min_capacity" {
  type        = number
  description = "Minimum autoscale instance count for Application Gateway WAF_v2."
  default     = 1

  validation {
    condition     = var.app_gateway_min_capacity >= 1 && var.app_gateway_min_capacity <= 125
    error_message = "app_gateway_min_capacity must be between 1 and 125."
  }
}

variable "app_gateway_max_capacity" {
  type        = number
  description = "Maximum autoscale instance count for Application Gateway WAF_v2."
  default     = 2

  validation {
    condition     = var.app_gateway_max_capacity >= var.app_gateway_min_capacity && var.app_gateway_max_capacity <= 125
    error_message = "app_gateway_max_capacity must be at least the minimum and no more than 125."
  }
}

variable "admin_ssh_public_key" {
  type        = string
  description = "Public SSH key for the Linux VM administrator. Password authentication is disabled."

  validation {
    condition     = can(regex("^(ssh-rsa|ssh-ed25519|ecdsa-sha2-nistp256) ", var.admin_ssh_public_key))
    error_message = "Provide a valid OpenSSH RSA, Ed25519, or ECDSA public key."
  }
}

variable "app_gateway_certificate_secret_id" {
  type        = string
  description = "Versionless Key Vault secret URI for the PFX certificate used by Application Gateway. The certificate secret must exist before applying the full configuration."

  validation {
    condition     = can(regex("^https://[^/]+\\.vault\\.azure\\.net/secrets/[^/]+/?$", var.app_gateway_certificate_secret_id))
    error_message = "Provide a versionless HTTPS Key Vault secret URI, such as https://<vault>.vault.azure.net/secrets/<certificate-name>/."
  }
}
