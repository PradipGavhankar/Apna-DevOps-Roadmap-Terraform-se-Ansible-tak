variable "admin_ssh_public_key" {
  type        = string
  description = "Full OpenSSH public key line for the private Linux VM."
}

variable "app_gateway_certificate_secret_id" {
  type        = string
  description = "Versionless Key Vault secret URI for an already-imported PFX certificate."
}
