
output "replicator_spp" {
  description = "Replicator Service Principal."
  value       = length(module.replicator_spp) > 0 ? module.replicator_spp[0].service_principal : null
}

output "replicator_spp_password" {
  description = "Password for Replicator Service Principal."
  value       = length(module.replicator_spp) > 0 ? module.replicator_spp[0].service_principal_password : null
  sensitive   = true
}

# output "blueprint_service_principal_object_id" {
#   description = "Object ID of the BluePrint Service Principal in this AAD."
#   value       = length(module.replicator_spp) > 0 ? module.replicator_spp[0].azuread_application.blueprint_service_principal.object_id : null
# }

output "kraken_spp" {
  description = "Kraken Service Principal."
  value       = length(module.kraken_spp) > 0 ? module.kraken_spp[0].service_principal : null
}

output "kraken_spp_password" {
  description = "Password for Kraken Service Principal."
  value       = length(module.kraken_spp) > 0 ? module.kraken_spp[0].service_principal_password : null
  sensitive   = true
}

output "idp_lookup_spp" {
  description = "IDP Lookup Service Principal."
  value       = length(module.idp_lookup_spp) > 0 ? module.idp_lookup_spp[0].service_principal : null
}

output "idp_lookup_spp_password" {
  description = "Password for IDP Lookup Service Principal."
  value       = length(module.idp_lookup_spp) > 0 ? module.idp_lookup_spp[0].service_principal_password : null
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
