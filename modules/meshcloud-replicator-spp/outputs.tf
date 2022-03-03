output "service_principal" {
  description = "Service Principal application id and object id"
  value = {
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

# Terraform does not find the blueprint service principal, even though I find it with
# ` az ad sp list --filter "appId eq 'f71766dc-90d9-4b7d-bd9d-4499c4331c3f'"`
# output "blueprint_service_principal_object_id" {
#   description = "Object ID of the BluePrint Service Principal of this AAD."
#   value       = data.azuread_application.blueprint_service_principal.object_id
# }
