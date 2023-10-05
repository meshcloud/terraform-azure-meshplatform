
output "replicator_service_principal" {
  description = "Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].service_principal : null
}

output "replicator_service_principal_password" {
  description = "Password for Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].service_principal_password : null
  sensitive   = true
}

# output "blueprint_service_principal_object_id" {
#   description = "Object ID of the BluePrint Service Principal in this AAD."
#   value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].azuread_application.blueprint_service_principal.object_id : null
# }

output "metering_service_principal" {
  description = "Metering Service Principal."
  value       = length(module.metering_service_principal) > 0 ? module.metering_service_principal[0].service_principal : null
}

output "metering_service_principal_password" {
  description = "Password for Metering Service Principal."
  value       = length(module.metering_service_principal) > 0 ? module.metering_service_principal[0].service_principal_password : null
  sensitive   = true
}

output "idp_lookup_service_principal" {
  description = "IDP Lookup Service Principal."
  value       = length(module.idp_lookup_service_principal) > 0 ? module.idp_lookup_service_principal[0].service_principal : null
}

output "idp_lookup_service_principal_password" {
  description = "Password for IDP Lookup Service Principal."
  value       = length(module.idp_lookup_service_principal) > 0 ? module.idp_lookup_service_principal[0].service_principal_password : null
  sensitive   = true
}

output "uami_blueprint_user_principal" {
  description = "UAMI Blueprint Assignment Service Principal."
  value       = length(module.uami_blueprint_user_principal) > 0 ? module.uami_blueprint_user_principal[0].service_principal : null
}

output "uami_blueprint_user_principal_password" {
  description = "Password for UAMI Blueprint Assignment Service Principal."
  value       = length(module.uami_blueprint_user_principal) > 0 ? module.uami_blueprint_user_principal[0].service_principal_password : null
  sensitive   = true
}

output "azure_ad_tenant_id" {
  description = "The Azure AD tenant id."
  value       = data.azuread_client_config.current.tenant_id
}
