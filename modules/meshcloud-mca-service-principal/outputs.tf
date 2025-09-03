output "billing_scopes" {
  value = [for scope in data.azurerm_billing_mca_account_scope.mca : scope.id]
}

output "credentials" {
  description = "Service Principal application id and object id"
  value = {
    for name in keys(var.service_principals) : name => {
      Enterprise_Application_Object_ID = azuread_service_principal.mca[name].object_id
      Application_Client_ID            = azuread_application.mca[name].client_id
      Client_Secret                    = var.create_password ? "Execute `terraform output mca_service_principal_password` to see the password" : "No password was created"
    }
  }
}

output "application_client_secret" {
  description = "Client Secret Of the Application."
  value       = var.create_password ? { for name in keys(var.service_principals) : name => azuread_application_password.mca[name].value } : {}
  sensitive   = true
}
