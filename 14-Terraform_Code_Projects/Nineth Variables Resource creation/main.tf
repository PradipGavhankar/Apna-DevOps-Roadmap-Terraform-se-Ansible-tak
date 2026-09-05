output "server_name" {
  value = var.server_configuration[0]
}

output "server_count" {
  value = var.server_configuration[1]
}

output "monitoring_enabled" {
  value = var.server_configuration[2]
}