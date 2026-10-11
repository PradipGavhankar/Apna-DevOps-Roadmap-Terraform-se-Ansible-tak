locals {
  name_prefix = lower("${var.project_name}-${var.environment}")

  common_tags = {
    project      = var.project_name
    environment  = var.environment
    managed_by   = "terraform"
    owner        = var.owner
    architecture = "monolithic"
  }
}

