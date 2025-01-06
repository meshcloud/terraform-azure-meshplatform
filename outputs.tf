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

output "mca_service_billing_scope" {
  value = length(module.mca_service_principal) > 0 ? module.mca_service_principal[0].billing_scope : null
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

output "sso_service_principal_client_id" {
  description = "SSO Service Principal."
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].application_client_id : null
}

output "sso_service_principal_password" {
  description = "Password for SSO Service Principal."
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].application_password : null
  sensitive   = true
}

output "sso_discovery_url" {
  description = "SSO applications's discovery url (OpenID Connect metadata document)"
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].discovery_url : null
  sensitive   = true
}

output "azure_ad_tenant_id" {
  description = "The Azure AD tenant id."
  value       = data.azuread_client_config.current.tenant_id
}
