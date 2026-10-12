output "vpc_id" {
  description = "Environment VPC ID."
  value       = module.landing_zone.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs grouped by tier."
  value       = module.landing_zone.subnet_ids
}

output "application_load_balancer_dns_name" {
  description = "Public ALB DNS name."
  value       = module.landing_zone.application_load_balancer_dns_name
}

output "application_autoscaling_group_name" {
  description = "Private application Auto Scaling group."
  value       = module.landing_zone.application_autoscaling_group_name
}

output "diagnostic_log_bucket_name" {
  description = "Private encrypted diagnostic foundation bucket."
  value       = module.landing_zone.diagnostic_log_bucket_name
}

output "vpc_flow_log_group_name" {
  description = "Encrypted CloudWatch log group receiving VPC Flow Logs."
  value       = module.landing_zone.vpc_flow_log_group_name
}
