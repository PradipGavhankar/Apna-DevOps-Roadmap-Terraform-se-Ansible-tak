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
  }
}

