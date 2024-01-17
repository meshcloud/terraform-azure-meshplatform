output "credentials" {
  description = "Service Principal application id and object id"
  value = {
    Enterprise_Application_Object_ID = azuread_service_principal.meshcloud_replicator.id
    Application_Client_ID            = azuread_application.meshcloud_replicator.client_id
    Client_Secret                    = "Execute `terraform output replicator_client_secret` to see the password"
  }
}

output "application_client_secret" {
  description = "Client Secret Of the Application."
  value       = azuread_application_password.application_pw.value
  sensitive   = true
}
