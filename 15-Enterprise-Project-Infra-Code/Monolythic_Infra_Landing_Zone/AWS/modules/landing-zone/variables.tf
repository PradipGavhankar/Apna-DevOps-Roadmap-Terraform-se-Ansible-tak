variable "aws_region" {
  type        = string
  description = "AWS region for the landing zone."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Short lowercase project identifier used in resource names."
  default     = "monolith"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,19}$", var.project_name))
    error_message = "project_name must be 1-20 lowercase letters, digits, or hyphens, and start with a letter."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,9}$", var.environment))
    error_message = "environment must be 1-10 lowercase letters, digits, or hyphens, and start with a letter."
  }
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
  description = "Optional AZ names. When empty, the first two available AZs in the region are selected."
  default     = []

  validation {
    condition     = length(var.availability_zones) == 0 || length(var.availability_zones) >= 2
    error_message = "Specify either no availability zones or at least two."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR range for the VPC."
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR range."
  }
}

variable "subnet_cidrs" {
  type = object({
    ingress     = list(string)
    application = list(string)
    database    = list(string)
    management  = list(string)
  })
  description = "One distinct subnet CIDR per selected AZ for each network tier."
  default = {
    ingress     = ["10.20.0.0/24", "10.20.1.0/24"]
    application = ["10.20.10.0/24", "10.20.11.0/24"]
    database    = ["10.20.20.0/24", "10.20.21.0/24"]
    management  = ["10.20.30.0/24", "10.20.31.0/24"]
  }

  validation {
    condition = (
      length(var.subnet_cidrs.ingress) == 2 &&
      length(var.subnet_cidrs.application) == 2 &&
      length(var.subnet_cidrs.database) == 2 &&
      length(var.subnet_cidrs.management) == 2 &&
      length(flatten([
        var.subnet_cidrs.ingress,
        var.subnet_cidrs.application,
        var.subnet_cidrs.database,
        var.subnet_cidrs.management
        ])) == length(toset(flatten([
          var.subnet_cidrs.ingress,
          var.subnet_cidrs.application,
          var.subnet_cidrs.database,
          var.subnet_cidrs.management
      ]))) &&
      alltrue([for cidr in flatten([
        var.subnet_cidrs.ingress,
        var.subnet_cidrs.application,
        var.subnet_cidrs.database,
        var.subnet_cidrs.management
      ]) : can(cidrhost(cidr, 0))])
    )
    error_message = "Each network tier must have exactly two valid, distinct subnet CIDRs."
  }
}

variable "nat_gateway_mode" {
  type        = string
  description = "Use one NAT gateway per AZ for resilient egress, or one shared NAT gateway to reduce cost."
  default     = "per_az"

  validation {
    condition     = contains(["per_az", "single"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be either per_az or single."
  }
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of an existing, issued ACM certificate in this region, covering the application hostname."
  sensitive   = true

  validation {
    condition     = can(regex("^arn:[^:]+:acm:[^:]+:[0-9]{12}:certificate/.+$", var.acm_certificate_arn))
    error_message = "acm_certificate_arn must be an ACM certificate ARN in the selected AWS region."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for each private application node."
  default     = "t3.micro"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of application instances."
  default     = 2

  validation {
    condition     = var.asg_min_size >= 1
    error_message = "asg_min_size must be at least 1."
  }
}

variable "asg_desired_capacity" {
  type        = number
  description = "Initial desired number of application instances."
  default     = 2

  validation {
    condition     = var.asg_desired_capacity >= var.asg_min_size && var.asg_desired_capacity <= var.asg_max_size
    error_message = "asg_desired_capacity must be between asg_min_size and asg_max_size."
  }
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of application instances."
  default     = 4

  validation {
    condition     = var.asg_max_size >= var.asg_min_size
    error_message = "asg_max_size must be at least as large as asg_min_size."
  }
}
