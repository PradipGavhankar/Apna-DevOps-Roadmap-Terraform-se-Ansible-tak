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

variable "region" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "data_subnet_cidr" {
  type = string
}

variable "management_subnet_cidr" {
  type = string
}

variable "backend_tag" {
  type = string
}

variable "backend_port" {
  type    = number
  default = 8080
}
