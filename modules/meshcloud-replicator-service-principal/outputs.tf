output "service_principal" {
  description = "Service Principal application id and object id"
  value = {
    Enterprise_Application_Object_ID = azuread_service_principal.meshcloud_replicator.id
    Application_Client_ID            = azuread_application.meshcloud_replicator.application_id
    Client_Secret                    = "Execute `terraform output service_principal_password` to see the password"
  }
}

output "service_principal_password" {
  description = "Password for the Service Principal."
  value       = azuread_application_password.service_principal_pw.value
  sensitive   = true
}

# Terraform does not find the blueprint service principal, even though I find it with
# ` az ad sp list --filter "appId eq 'f71766dc-90d9-4b7d-bd9d-4499c4331c3f'"`
# output "blueprint_service_principal_object_id" {
#   description = "Object ID of the BluePrint Service Principal of this AAD."
#   value       = data.azuread_application.blueprint_service_principal.object_id
# }
