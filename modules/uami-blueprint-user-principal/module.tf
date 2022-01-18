terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "2.2.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "0.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azuread_application" "uami_blueprint_principal" {
  name = "uami-blueprint.${var.spp_name_suffix}"
}

resource "azuread_service_principal" "uami_blueprint_principal" {
  application_id = azuread_application.uami_blueprint_principal.application_id
}

resource "random_password" "spp_pw" {
  length = 64
  # Currently there are some passwords which do not allow you to login using az cli (see https://github.com/Azure/azure-cli/issues/12332)
  # Which is the reason we have set the flag to false
  special = false
}

resource "azuread_service_principal_password" "spp_pw" {
  service_principal_id = azuread_service_principal.uami_blueprint_principal.id
  value                = random_password.spp_pw.result
  end_date             = "2999-01-01T01:02:03Z" # no expiry
}

resource "azurerm_role_assignment" "spp_pw" {
  count                = length(var.subscriptions)
  principal_id         = azuread_service_principal.uami_blueprint_principal.id
  scope                = "/subscriptions/${var.subscriptions[count.index]}"
  role_definition_name = "Contributor"
}
