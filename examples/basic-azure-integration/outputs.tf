
output "replicator_spp" {
  description = "Replicator Service Principal."
  value = {
    output = module.meshplatform.replicator_spp
  }
}

output "replicator_spp_password" {
  description = "Password for Replicator Service Principal."
  value = {
    password = module.meshplatform.replicator_spp_password
  }
  sensitive = true
}

output "kraken_spp" {
  description = "Kraken Service Principal."
  value = {
    output = module.meshplatform.kraken_spp
  }
}

output "kraken_spp_password" {
  description = "Password for Kraken Service Principal."
  value = {
    password = module.meshplatform.kraken_spp_password
  }
  sensitive = true
}

output "uami_blueprint_user_principal" {
  description = "UAMI Blueprint Assignment Service Principal."
  value = {
    output = module.meshplatform.uami_blueprint_user_principal
  }
}

output "uami_blueprint_user_principal_password" {
  description = "Password for UAMI Blueprint Assignment Service Principal."
  value = {
    password = module.meshplatform.uami_blueprint_user_principal_password
  }
  sensitive = true
}
