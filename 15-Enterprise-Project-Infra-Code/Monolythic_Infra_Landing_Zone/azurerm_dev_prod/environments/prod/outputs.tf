output "resource_group_name" {
  value = module.landing_zone.resource_group_name
}

output "linux_vm_private_ip" {
  value = module.landing_zone.linux_vm_private_ip
}

output "application_gateway_fqdn" {
  value = module.landing_zone.application_gateway_fqdn
}

output "application_nat_public_ip" {
  value = module.landing_zone.application_nat_public_ip
}
