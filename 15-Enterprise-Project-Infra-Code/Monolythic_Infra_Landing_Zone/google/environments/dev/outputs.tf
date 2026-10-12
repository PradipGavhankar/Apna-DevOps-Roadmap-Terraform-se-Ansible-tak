output "vpc_name" {
  description = "Custom-mode application VPC."
  value       = module.network.network_name
}

output "app_subnet_name" {
  description = "Private regional application subnet."
  value       = module.network.subnet_name
}

output "data_subnet_name" {
  description = "Data-service network segment, ready for a separately selected private data service."
  value       = module.network.data_subnet_name
}

output "management_subnet_name" {
  description = "Management network segment; no public SSH access is configured."
  value       = module.network.management_subnet_name
}

output "app_instance_group" {
  description = "Regional MIG backend group."
  value       = module.application.instance_group
}

output "load_balancer_ipv4" {
  description = "Public global IPv4 address for certificate DNS A records."
  value       = module.edge.ipv4_address
}

output "managed_certificate_resource" {
  description = "Google-managed TLS certificate resource."
  value       = module.edge.certificate_id
}

output "artifact_bucket_name" {
  value = module.foundation.artifact_bucket_name
}

output "application_secret_id" {
  description = "Secret resource only; no secret value/version is created."
  value       = module.foundation.application_secret_id
}

output "logging_bucket_id" {
  value = module.foundation.logging_bucket_id
}

output "kms_key_id" {
  value = module.foundation.kms_key_id
}
