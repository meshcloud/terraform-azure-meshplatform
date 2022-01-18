
output "replicator_spp" {
  description = "Password for the Service Principal."
  value = {
    output = module.replicator_spp.service_principal
  }
}

output "replicator_spp_password" {
  description = "Password for the Service Principal."
  value = {
    password = module.replicator_spp.service_principal_password
  }
  sensitive = true
}

output "kraken_spp" {
  description = "Password for the Service Principal."
  value = {
    output = module.kraken_spp.service_principal
  }
}

output "kraken_spp_password" {
  description = "Password for the Service Principal."
  value = {
    password = module.kraken_spp.service_principal_password
  }
  sensitive = true
}

output "idp_lookup_spp" {
  description = "Password for the Service Principal."
  value = {
    output = module.idp_lookup_spp.service_principal
  }
}

output "idp_lookup_spp_password" {
  description = "Password for the Service Principal."
  value = {
    password = module.idp_lookup_spp.service_principal_password
  }
  sensitive = true
}