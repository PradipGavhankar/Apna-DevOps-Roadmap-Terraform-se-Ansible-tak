output "vpc_id" {
  description = "VPC ID for the landing zone."
  value       = aws_vpc.main.id
}

output "availability_zones" {
  description = "Two AZs hosting the ingress and application tiers."
  value       = local.azs
}

output "subnet_ids" {
  description = "Subnet IDs grouped by network tier."
  value = {
    for tier in keys(local.subnet_tiers) : tier => [
      for index in range(2) : aws_subnet.tier["${tier}-${index + 1}"].id
    ]
  }
}

output "application_security_group_id" {
  description = "Security group used by private application instances."
  value       = aws_security_group.application.id
}

output "application_load_balancer_dns_name" {
  description = "Public ALB DNS name; configure the application DNS hostname as an alias to it."
  value       = aws_lb.application.dns_name
}

output "application_load_balancer_zone_id" {
  description = "ALB hosted zone ID, useful for creating a Route 53 alias."
  value       = aws_lb.application.zone_id
}

output "application_target_group_arn" {
  description = "Target group receiving HTTPS listener traffic."
  value       = aws_lb_target_group.application.arn
}

output "application_autoscaling_group_name" {
  description = "Name of the private EC2 application Auto Scaling group."
  value       = aws_autoscaling_group.application.name
}

output "diagnostic_log_bucket_name" {
  description = "Private, versioned, KMS-encrypted S3 diagnostic foundation bucket."
  value       = aws_s3_bucket.logs.bucket
}

output "waf_web_acl_arn" {
  description = "Regional WAF web ACL associated with the public ALB."
  value       = aws_wafv2_web_acl.application.arn
}

output "application_log_group_name" {
  description = "CloudWatch log group receiving nginx logs from private EC2 instances."
  value       = aws_cloudwatch_log_group.application.name
}

output "vpc_flow_log_group_name" {
  description = "Encrypted CloudWatch log group receiving VPC Flow Logs."
  value       = aws_cloudwatch_log_group.vpc_flow.name
}

output "application_secret_arn" {
  description = "ARN of the empty KMS-encrypted Secrets Manager container; no secret value is created."
  value       = aws_secretsmanager_secret.application.arn
}
