output "replicator_service_principal" {
  description = "Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].credentials : null
}

output "replicator_service_principal_password" {
  description = "Password for Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].application_client_secret : null
  sensitive   = true
}

output "mca_service_principal" {
  description = "MCA Service Principal."
  value       = length(module.mca_service_principal) > 0 ? module.mca_service_principal[0].credentials : null
}

output "mca_service_principal_password" {
  description = "Password for MCA Service Principal."
  value       = length(module.mca_service_principal) > 0 ? module.mca_service_principal[0].application_client_secret : null
  sensitive   = true
}

output "metering_service_principal" {
  description = "Metering Service Principal."
  value       = length(module.metering_service_principal) > 0 ? module.metering_service_principal[0].credentials : null
}

output "metering_service_principal_password" {
  description = "Password for Metering Service Principal."
  value       = length(module.metering_service_principal) > 0 ? module.metering_service_principal[0].application_client_secret : null
  sensitive   = true
}

output "sso_service_principal" {
  description = "SSO Service Principal."
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].credentials : null
}

output "sso_service_principal_password" {
  description = "Password for SSO Service Principal."
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].application_client_secret : null
  sensitive   = true
}

output "azure_ad_tenant_id" {
  description = "The Azure AD tenant id."
  value       = data.azuread_client_config.current.tenant_id
}
