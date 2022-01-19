
output "replicator_spp" {
  description = "Replicator Service Principal."
  value = {
    output = length(module.replicator_spp) > 0 ? module.replicator_spp[0].service_principal : null
  }
}

output "replicator_spp_password" {
  description = "Password for Replicator Service Principal."
  value = {
    password = length(module.replicator_spp) > 0 ? module.replicator_spp[0].service_principal_password : null
  }
  sensitive = true
}

output "kraken_spp" {
  description = "Kraken Service Principal."
  value = {
    output = length(module.kraken_spp) > 0 ? module.kraken_spp[0].service_principal : null
  }
}

output "kraken_spp_password" {
  description = "Password for Kraken Service Principal."
  value = {
    password = length(module.kraken_spp) > 0 ? module.kraken_spp[0].service_principal_password : null
  }
  sensitive = true
}

output "idp_lookup_spp" {
  description = "IDP Lookup Service Principal."
  value = {
    output = length(module.idp_lookup_spp) > 0 ? module.idp_lookup_spp[0].service_principal : null
  }
}

output "idp_lookup_spp_password" {
  description = "Password for IDP Lookup Service Principal."
  value = {
    password = length(module.idp_lookup_spp) > 0 ? module.idp_lookup_spp[0].service_principal_password : null
  }
  sensitive = true
}

output "uami_blueprint_user_principal" {
  description = "UAMI Blueprint Assignment Service Principal."
  value = {
    output = length(module.uami_blueprint_user_principal) > 0 ? module.uami_blueprint_user_principal[0].service_principal : null
  }
}

output "uami_blueprint_user_principal_password" {
  description = "Password for UAMI Blueprint Assignment Service Principal."
  value = {
    password = length(module.uami_blueprint_user_principal) > 0 ? module.uami_blueprint_user_principal[0].service_principal_password : null
  }
  sensitive = true
}
