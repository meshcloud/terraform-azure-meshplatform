//---------------------------------------------------------------------------
// Create new client secret and associate it with the application
//---------------------------------------------------------------------------
resource "time_rotating" "replicator_secret_rotation" {
  count = var.create_password ? 1 : 0

  rotation_days = 365
}

resource "azuread_application_password" "application_pw" {
  count = var.create_password ? 1 : 0

  application_id = azuread_application.meshcloud_replicator.id
  rotate_when_changed = {
    rotation = time_rotating.replicator_secret_rotation[0].id
  }
}

moved {
  from = time_rotating.replicator_secret_rotation
  to   = time_rotating.replicator_secret_rotation[0]
}

moved {
  from = azuread_application_password.application_pw
  to   = azuread_application_password.application_pw[0]
}

//---------------------------------------------------------------------------
// Create federated identity credentials
//---------------------------------------------------------------------------
resource "azuread_application_federated_identity_credential" "meshcloud_replicator" {
  count = var.workload_identity_federation == null ? 0 : 1

  application_id = azuread_application.meshcloud_replicator.id
  display_name   = var.service_principal_name
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = var.workload_identity_federation.issuer
  subject        = var.workload_identity_federation.subject
}
