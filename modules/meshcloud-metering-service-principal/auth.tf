//---------------------------------------------------------------------------
// Create a password for the Enterprise application
//---------------------------------------------------------------------------
resource "time_rotating" "replicator_secret_rotation" {
  count = var.create_password ? 1 : 0

  rotation_days = 365
}

resource "azuread_application_password" "application_pw" {
  count = var.create_password ? 1 : 0

  application_id = azuread_application.meshcloud_metering.id
  rotate_when_changed = {
    rotation = time_rotating.replicator_secret_rotation[0].id
  }
}

moved {
  from = azurerm_role_assignment.meshcloud_kraken
  to   = azurerm_role_assignment.meshcloud_metering
}

moved {
  from = azuread_application.meshcloud_kraken
  to   = azuread_application.meshcloud_metering
}

moved {
  from = azuread_service_principal.meshcloud_kraken
  to   = azuread_service_principal.meshcloud_metering
}

//---------------------------------------------------------------------------
// Create federated identity credentials
//---------------------------------------------------------------------------
resource "azuread_application_federated_identity_credential" "meshcloud_metering" {
  count = var.workload_identity_federation == null ? 0 : 1

  application_id = azuread_application.meshcloud_metering.id
  display_name   = var.service_principal_name
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = var.workload_identity_federation.issuer
  subject        = var.workload_identity_federation.subject
}
