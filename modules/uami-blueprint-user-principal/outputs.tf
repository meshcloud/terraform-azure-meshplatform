output "service_principal" {
  value = {
    object_id = azuread_service_principal.uami_blueprint_principal.id
    app_id    = azuread_service_principal.uami_blueprint_principal.application_id
    password  = "Execute `terraform output replicator_spp_password` to see the password"
  }
}

output "service_principal_password" {
  value = {
    password = random_password.spp_pw.result
  }
  sensitive = true
}
