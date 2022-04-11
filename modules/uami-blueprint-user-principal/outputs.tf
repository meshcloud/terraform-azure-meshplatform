output "service_principal" {
  value = {
    object_id = azuread_service_principal.uami_blueprint_principal.id
    app_id    = azuread_service_principal.uami_blueprint_principal.application_id
    password  = "Execute `terraform output uami_blueprint_user_principal_password` to see the password"
  }
}

output "service_principal_password" {
  value     = azuread_service_principal_password.service_principal_pw.value
  sensitive = true
}
