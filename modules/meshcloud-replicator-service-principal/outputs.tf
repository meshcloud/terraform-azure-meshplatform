output "credentials" {
  description = "Service Principal application id and object id"
  value = {
    Enterprise_Application_Object_ID = azuread_service_principal.meshcloud_replicator.object_id
    Application_Client_ID            = azuread_application.meshcloud_replicator.client_id
    Client_Secret                    = var.create_password ? "Execute `terraform output replicator_service_principal_password` to see the password" : "No password was created"
  }
}

output "application_client_secret" {
  description = "Client Secret Of the Application."
  value       = var.create_password ? azuread_application_password.application_pw[0].value : null
  sensitive   = true
}
