output "service_principal" {
  value = {
    INFO      = "On the very first time running tf apply, you have to run 'az ad app permission admin-consent --id ${azuread_service_principal.meshcloud_kraken.application_id}' or click the 'Grant Admin consent button' in the portal"
    object_id = azuread_service_principal.meshcloud_kraken.id
    app_id    = azuread_service_principal.meshcloud_kraken.application_id
    password  = "Execute `terraform output kraken_spp_password` to see the password"
  }
}

output "service_principal_password" {
  description = "Password for the Service Principal."
  value = {
    password = random_password.spp_pw.result
  }
  sensitive = true
}
