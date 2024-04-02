output "billing_scope" {
  value = data.azurerm_billing_mca_account_scope.mca.id
}

output "credentials" {
  description = "Service Principal application id and object id"
  value = {
    Enterprise_Application_Object_ID = azuread_service_principal.mca.id
    Application_Client_ID            = azuread_application.mca.client_id
    Client_Secret                    = "Execute `terraform output mca_service_principal_password` to see the password"
  }
}

output "application_client_secret" {
  description = "Client Secret Of the Application."
  value       = azuread_application_password.mca.value
  sensitive   = true
}

