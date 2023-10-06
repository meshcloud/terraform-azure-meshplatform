output "service_principal" {
  description = "Service Principal application id and object id"
  value = {
    Enterprise_Application_Object_ID = azuread_service_principal.meshcloud_metering.id
    Application_Client_ID            = azuread_application.meshcloud_metering.application_id
    Client_Secret                    = "Execute `terraform output service_principal_password` to see the password"
  }
}

output "service_principal_password" {
  description = "Password for the Service Principal."
  value       = azuread_application_password.service_principal_pw.value
  sensitive   = true
}
