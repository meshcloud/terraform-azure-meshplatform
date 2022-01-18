output "service_principal" {
  value = {
    object_id = azuread_service_principal.uami_blueprint_principal.id
    app_id    = azuread_service_principal.uami_blueprint_principal.application_id
    password  = random_password.spp_pw.result
  }
}
