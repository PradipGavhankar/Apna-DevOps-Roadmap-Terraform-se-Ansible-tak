output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.main : k => s.id }
}

output "nsg_id" {
  value = azurerm_network_security_group.main.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "linux_vm_private_ip" {
  value       = azurerm_network_interface.application.private_ip_address
  description = "Private-only address for the Linux application backend."
}

output "application_gateway_public_ip" {
  value       = azurerm_public_ip.app_gateway.ip_address
  description = "Public IP address for the WAF_v2 Application Gateway."
}

output "application_gateway_fqdn" {
  value       = azurerm_public_ip.app_gateway.fqdn
  description = "DNS name for the WAF_v2 Application Gateway."
}

output "application_nat_public_ip" {
  value       = azurerm_public_ip.application_nat.ip_address
  description = "Static egress IP used by the private application subnet."
}
