module "landing_zone" {
  source = "../.."

  project_name                      = "monolith"
  environment                       = "qa"
  location                          = "eastus"
  owner                             = "cloud-platform"
  linux_vm_size                     = "Standard_D2s_v5"
  app_gateway_min_capacity          = 1
  app_gateway_max_capacity          = 3
  admin_ssh_public_key              = var.admin_ssh_public_key
  app_gateway_certificate_secret_id = var.app_gateway_certificate_secret_id
}
