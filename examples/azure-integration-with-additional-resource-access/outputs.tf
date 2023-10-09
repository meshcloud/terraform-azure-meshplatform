
output "replicator_credentials" {
  description = "Replicator Service Principal."
  value       = module.meshplatform.replicator_service_principal
}

output "replicator_client_secret" {
  description = "Password for Replicator Service Principal."
  value       = module.meshplatform.replicator_service_principal_password
  sensitive   = true
}

output "metering_credentials" {
  description = "Metering Service Principal."
  value       = module.meshplatform.metering_service_principal
}

output "metering_client_secret" {
  description = "Password for Metering Service Principal."
  value       = module.meshplatform.metering_service_principal_password
  sensitive   = true
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
