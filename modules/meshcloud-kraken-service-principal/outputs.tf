output "service_principal" {
  description = "Service Principal application id and object id"
  value = {
    object_id = azuread_service_principal.meshcloud_kraken.id
    app_id    = azuread_service_principal.meshcloud_kraken.application_id
    password  = "Execute `terraform output service_principal_password` to see the password"
  }
}

output "service_principal_password" {
  description = "Password for the Service Principal."
  value       = azuread_service_principal_password.service_principal_pw.value
  sensitive   = true
}
