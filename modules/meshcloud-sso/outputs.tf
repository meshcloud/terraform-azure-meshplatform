output "application_client_id" {
  value = azuread_application.meshcloud_sso.client_id
}

output "application_password" {
  description = "Password for the SSO application."
  sensitive   = true
  value       = azuread_application_password.meshcloud_sso.value
}

data "azuread_client_config" "current" {}

output "discovery_url" {
  description = "SSO applications's discovery url (OpenID Connect metadata document)"
  value       = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/v2.0/.well-known/openid-configuration"
}
