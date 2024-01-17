output "credentials" {
  description = "Service Principal application id and object id"
  value = {
    Enterprise_Application_Object_ID = azuread_application.meshcloud_sso.object_id
    Application_Client_ID            = azuread_application.meshcloud_sso.client_id
  }
}

output "application_client_secret" {
  description = "Password for the application registration."
  value       = azuread_application_password.meshcloud_sso.value
  sensitive   = true
}
