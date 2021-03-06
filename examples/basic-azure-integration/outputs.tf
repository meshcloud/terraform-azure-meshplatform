output "replicator_service_principal" {
  description = "Replicator Service Principal."
  value       = module.meshplatform.replicator_service_principal
}

output "replicator_service_principal_password" {
  description = "Password for Replicator Service Principal."
  value       = module.meshplatform.replicator_service_principal_password
  sensitive   = true
}

output "kraken_service_principal" {
  description = "Metering Service Principal."
  value       = module.meshplatform.kraken_service_principal
}

output "kraken_service_principal_password" {
  description = "Password for Metering Service Principal."
  value       = module.meshplatform.kraken_service_principal_password
  sensitive   = true
}

output "idp_lookup_service_principal" {
  description = "IDP Lookup Service Principal."
  value       = module.meshplatform.idp_lookup_service_principal
}

output "idp_lookup_service_principal_password" {
  description = "Password for IDP Lookup Service Principal."
  value       = module.meshplatform.idp_lookup_service_principal_password
}

output "uami_blueprint_user_principal" {
  description = "UAMI Blueprint Assignment Service Principal."
  value       = module.meshplatform.uami_blueprint_user_principal
}

output "uami_blueprint_user_principal_password" {
  description = "Password for UAMI Blueprint Assignment Service Principal."
  value       = module.meshplatform.uami_blueprint_user_principal_password
  sensitive   = true
}

output "azure_ad_tenant_id" {
  description = "The Azure AD tenant id."
  value       = module.meshplatform.azure_ad_tenant_id
}

