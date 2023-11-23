terraform {
  required_version = "> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.46.0"
    }
  }
}

resource "azuread_application" "uami_blueprint_principal" {
  display_name = "uami-blueprint.${var.service_principal_name_suffix}"
}

resource "azuread_service_principal" "uami_blueprint_principal" {
  client_id = azuread_application.uami_blueprint_principal.client_id
}

resource "azuread_service_principal_password" "service_principal_pw" {
  service_principal_id = azuread_service_principal.uami_blueprint_principal.id
  end_date             = "2999-01-01T01:02:03Z" # no expiry
}

resource "azurerm_role_assignment" "service_principal_pw" {
  count                = length(var.subscriptions)
  principal_id         = azuread_service_principal.uami_blueprint_principal.id
  scope                = "/subscriptions/${var.subscriptions[count.index]}"
  role_definition_name = "Contributor"
  depends_on = [ azuread_application.uami_blueprint_principal ]
}

# facilitate migration from v0.1.0 of the module
moved {
  from = azuread_service_principal_password.spp_pw
  to   = azuread_service_principal_password.service_principal_pw
}

moved {
  from = azurerm_role_assignment.spp_pw
  to   = azurerm_role_assignment.service_principal_pw
}
