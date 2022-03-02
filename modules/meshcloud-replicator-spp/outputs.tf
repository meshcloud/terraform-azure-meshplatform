output "service_principal" {
  value = {
    INFO      = "On the very first time running tf apply, you have to run 'az ad app permission admin-consent --id ${azuread_service_principal.meshcloud_replicator.application_id}' or click the 'Grant Admin consent button' in the portal"
    object_id = azuread_service_principal.meshcloud_replicator.id
    app_id    = azuread_service_principal.meshcloud_replicator.application_id
    password  = "Execute `terraform output replicator_spp_password` to see the password"
  }
}

output "service_principal_password" {
  description = "Password for the Service Principal."
  value       = azuread_service_principal_password.spp_pw.value
  sensitive   = true
}

output "blueprint_service_principal_object_id" {
  description = "Object ID of the BluePrint Service Principal of this AAD."
  value       = data.azuread_application.blueprint_service_principal.object_id
}
