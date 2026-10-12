terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.0, < 8.0"
    }
  }
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "artifact_bucket_name" {
  type        = string
  description = "Globally unique, project-owned bucket name for encrypted artifacts."

  validation {
    condition     = length(var.artifact_bucket_name) >= 3 && length(var.artifact_bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9._-]*[a-z0-9]$", var.artifact_bucket_name))
    error_message = "Bucket name must be 3-63 characters, start and end with a lowercase letter or digit, and use only lowercase letters, digits, hyphens, underscores, or periods."
  }
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "artifact_retention_seconds" {
  type    = number
  default = 2592000
}
