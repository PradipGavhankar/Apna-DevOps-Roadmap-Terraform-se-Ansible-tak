terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }
}

variable "project_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "certificate_domains" {
  type        = list(string)
  description = "Real public DNS names covered by the Google-managed certificate."

  validation {
    condition     = length(var.certificate_domains) > 0 && alltrue([for domain in var.certificate_domains : length(domain) <= 253 && can(regex("^([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?\\.)+[A-Za-z]{2,63}$", domain))])
    error_message = "Provide at least one valid fully qualified domain name."
  }
}

variable "backend_group" {
  type = string
}

variable "health_check_id" {
  type = string
}

variable "backend_port_name" {
  type    = string
  default = "http"
}

variable "enable_waf_logging" {
  type    = bool
  default = true
}
