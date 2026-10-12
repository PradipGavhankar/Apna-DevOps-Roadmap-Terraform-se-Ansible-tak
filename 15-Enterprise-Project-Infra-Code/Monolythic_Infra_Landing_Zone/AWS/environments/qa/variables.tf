variable "aws_region" {
  type        = string
  description = "AWS region for this environment."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Short lowercase project identifier used in resource names."
  default     = "monolith"
}

variable "owner" {
  type        = string
  description = "Owning team or contact."
  default     = "platform-team"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to managed resources."
  default     = {}
}

variable "availability_zones" {
  type        = list(string)
  description = "Optional list of AZs. The first two available AZs are selected when empty."
  default     = []
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR range for the environment VPC."
  default     = "10.30.0.0/16"
}

variable "subnet_cidrs" {
  type = object({
    ingress     = list(string)
    application = list(string)
    database    = list(string)
    management  = list(string)
  })
  description = "Two distinct subnet CIDRs for each network tier."
  default = {
    ingress     = ["10.30.0.0/24", "10.30.1.0/24"]
    application = ["10.30.10.0/24", "10.30.11.0/24"]
    database    = ["10.30.20.0/24", "10.30.21.0/24"]
    management  = ["10.30.30.0/24", "10.30.31.0/24"]
  }
}

variable "nat_gateway_mode" {
  type        = string
  description = "single minimizes cost; per_az provides zonal egress resilience."
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single or per_az."
  }
}

variable "acm_certificate_arn" {
  type        = string
  description = "Existing issued ACM certificate ARN in aws_region; required before planning."
  sensitive   = true

  validation {
    condition     = can(regex("^arn:[^:]+:acm:[^:]+:[0-9]{12}:certificate/.+$", var.acm_certificate_arn))
    error_message = "Set acm_certificate_arn to an existing ACM certificate ARN in the selected region."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for private application nodes."
  default     = "t3.small"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum application instance count."
  default     = 2

  validation {
    condition     = var.asg_min_size >= 1
    error_message = "asg_min_size must be at least 1."
  }
}

variable "asg_desired_capacity" {
  type        = number
  description = "Initial desired application instance count."
  default     = 2
}

variable "asg_max_size" {
  type        = number
  description = "Maximum application instance count."
  default     = 3
}
