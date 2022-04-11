
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
  description = "Kraken Service Principal."
  value       = module.meshplatform.kraken_service_principal
}

output "kraken_service_principal_password" {
  description = "Password for Kraken Service Principal."
  value       = module.meshplatform.kraken_service_principal_password
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
