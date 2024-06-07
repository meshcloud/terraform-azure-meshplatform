output "billing_scope" {
  value = data.azurerm_billing_mca_account_scope.mca.id
}

output "credentials" {
  description = "Service Principal application id and object id"
  value = {
    for name in var.service_principal_names : name => {
      Enterprise_Application_Object_ID = azuread_service_principal.mca[name].object_id
      Application_Client_ID            = azuread_application.mca[name].client_id
      Client_Secret                    = "Execute `terraform output mca_service_principal_password` to see the password"
    }
  }
}

output "application_client_secret" {
  description = "Client Secret Of the Application."
  value       = { for name in var.service_principal_names : name => azuread_application_password.mca[name].value }
  sensitive   = true
}

