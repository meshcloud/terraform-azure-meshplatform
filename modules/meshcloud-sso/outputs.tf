output "app_registration" {
  description = "Application registration application id and object id"
  value = {
    object_id = azuread_service_principal.meshcloud_sso.id
    app_id    = azuread_service_principal.meshcloud_sso.application_id
  }
}

output "app_registration_client_secret" {
  description = "Password for the application registration."
  value       = azuread_application_password.meshcloud_sso.value
  sensitive   = true
}
