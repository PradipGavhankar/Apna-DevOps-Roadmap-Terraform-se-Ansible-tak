############################
# Resource Group
############################
resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.location
  tags     = local.common_tags

  lifecycle {
    prevent_destroy = false # prod me true kar dena
  }
}

############################
# Virtual Network
############################
resource "azurerm_virtual_network" "main" {
  name                = "${local.name_prefix}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}

############################
# Subnets (for_each)
############################
resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                 = "${local.name_prefix}-${each.key}-snet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.address_prefix]
}

############################
# Network Security Group
############################
resource "azurerm_network_security_group" "main" {
  name                = "${local.name_prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# Example dynamic security rules
resource "azurerm_network_security_rule" "app_gateway_https" {
  name                        = "Allow-HTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "app_gateway_http" {
  name                        = "Allow-HTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "app_gateway_manager" {
  name                        = "Allow-GatewayManager"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "app_gateway_load_balancer" {
  name                        = "Allow-AzureLoadBalancer"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "deny_other_app_gateway_inbound" {
  name                        = "Deny-Other-Application-Gateway-Inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

############################
# Application Gateway and backend network security
############################
resource "azurerm_subnet_network_security_group_association" "app_gateway" {
  subnet_id                 = azurerm_subnet.main["app_gateway"].id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_network_security_group" "application" {
  name                = "${local.name_prefix}-application-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_network_security_rule" "application_from_gateway" {
  name                        = "Allow-HTTP-From-Application-Gateway"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.subnets["app_gateway"].address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_deny_other_inbound" {
  name                        = "Deny-Other-Application-Inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_dns_udp" {
  name                        = "Allow-Azure-DNS-UDP"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzurePlatformDNS"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_dns_tcp" {
  name                        = "Allow-Azure-DNS-TCP"
  priority                    = 105
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzurePlatformDNS"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_http_egress" {
  name                        = "Allow-Internet-HTTP-Updates"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_https_egress" {
  name                        = "Allow-Internet-HTTPS"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_platform_http" {
  name                        = "Allow-Azure-Platform-Agent-HTTP"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "168.63.129.16/32"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_platform_agent" {
  name                        = "Allow-Azure-Platform-Agent"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "32526"
  source_address_prefix       = "*"
  destination_address_prefix  = "168.63.129.16/32"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_network_security_rule" "application_deny_egress" {
  name                        = "Deny-Other-Application-Egress"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.application.name
}

resource "azurerm_subnet_network_security_group_association" "application" {
  subnet_id                 = azurerm_subnet.main["application"].id
  network_security_group_id = azurerm_network_security_group.application.id
}

resource "azurerm_public_ip" "application_nat" {
  name                = "${local.name_prefix}-app-nat-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_nat_gateway" "application" {
  name                    = "${local.name_prefix}-app-nat"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags                    = local.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "application" {
  nat_gateway_id       = azurerm_nat_gateway.application.id
  public_ip_address_id = azurerm_public_ip.application_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "application" {
  subnet_id      = azurerm_subnet.main["application"].id
  nat_gateway_id = azurerm_nat_gateway.application.id
}

resource "azurerm_user_assigned_identity" "app_gateway" {
  name                = "${local.name_prefix}-appgw-identity"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_key_vault_access_policy" "app_gateway" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.app_gateway.principal_id

  secret_permissions = ["Get", "List"]
}

resource "azurerm_public_ip" "app_gateway" {
  name                = "${local.name_prefix}-appgw-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${local.name_prefix}-appgw"
  tags                = local.common_tags
}

resource "azurerm_web_application_firewall_policy" "app_gateway" {
  name                = "${local.name_prefix}-appgw-waf-policy"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.common_tags

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "main" {
  name                = "${local.name_prefix}-appgw"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  firewall_policy_id  = azurerm_web_application_firewall_policy.app_gateway.id
  tags                = local.common_tags

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = var.app_gateway_min_capacity
    max_capacity = var.app_gateway_max_capacity
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app_gateway.id]
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = azurerm_subnet.main["app_gateway"].id
  }

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_port {
    name = "https"
    port = 443
  }

  ssl_certificate {
    name                = "tls-certificate"
    key_vault_secret_id = var.app_gateway_certificate_secret_id
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "https"
    protocol                       = "Https"
    ssl_certificate_name           = "tls-certificate"
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  backend_address_pool {
    name         = "linux-vm-backend"
    ip_addresses = [azurerm_network_interface.application.private_ip_address]
  }

  backend_http_settings {
    name                  = "http-backend"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "backend-health"
  }

  probe {
    name                = "backend-health"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = "127.0.0.1"

    match {
      status_code = ["200-399"]
    }
  }

  redirect_configuration {
    name                 = "redirect-http-to-https"
    redirect_type        = "Permanent"
    target_listener_name = "https-listener"
    include_path         = true
    include_query_string = true
  }

  request_routing_rule {
    name                       = "https-to-linux-vm"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "linux-vm-backend"
    backend_http_settings_name = "http-backend"
  }

  request_routing_rule {
    name                        = "http-redirect"
    priority                    = 110
    rule_type                   = "Basic"
    http_listener_name          = "http-listener"
    redirect_configuration_name = "redirect-http-to-https"
  }

  depends_on = [azurerm_key_vault_access_policy.app_gateway]
}

############################
# Log Analytics (Monitoring)
############################
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.name_prefix}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

############################
# Key Vault (Encryption / Secrets)
############################
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                       = "${local.name_prefix}-kv"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = false
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  tags                       = local.common_tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions      = ["Get", "List", "Set", "Delete"]
    key_permissions         = ["Get", "List", "Create", "Delete"]
    certificate_permissions = ["Create", "Get", "Import", "List", "Update"]
  }
}

############################
# Storage Account (Diagnostics / General)
############################
resource "azurerm_storage_account" "main" {
  name                     = replace("${local.name_prefix}sa${substr(md5(local.name_prefix), 0, 4)}", "-", "")
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  min_tls_version          = "TLS1_2"

  tags = local.common_tags

  lifecycle {
    prevent_destroy = false
  }
}

############################
# Private Linux VM (Application Backend)
############################
resource "azurerm_network_interface" "application" {
  name                = "${local.name_prefix}-linux-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.main["application"].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "application" {
  name                            = "${local.name_prefix}-linux-vm"
  computer_name                   = "${var.project_name}-${var.environment}-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.linux_vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.application.id]
  encryption_at_host_enabled      = true
  secure_boot_enabled             = true
  vtpm_enabled                    = true
  patch_mode                      = "AutomaticByPlatform"
  patch_assessment_mode           = "AutomaticByPlatform"
  provision_vm_agent              = true
  custom_data = base64encode(<<-CLOUD_INIT
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - nginx
    write_files:
      - path: /etc/nginx/conf.d/security.conf
        permissions: '0644'
        content: |
          server_tokens off;
      - path: /var/www/html/index.html
        permissions: '0644'
        content: |
          Application backend is healthy.
    runcmd:
      - [systemctl, enable, --now, nginx]
  CLOUD_INIT
  )

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "${local.name_prefix}-linux-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {}

  tags = local.common_tags
}
