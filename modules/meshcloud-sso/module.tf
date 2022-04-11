terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.97.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.18.0"
    }
  }
}

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

resource "azuread_application" "meshcloud_sso" {
  display_name = "sso.${var.service_principal_name_suffix}"

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["User.Read"]
      type = "Scope"
    }

    # As far as we know it is not possible to automate the "Grant admin consent button" for app registrations
    # You have to grant admin consent manually
    lifecycle {
      ignore_changes = [
        app_role
      ]
    }
  }

  web {
    redirect_uris = [var.meshstack_redirect_uri]
  }
}

resource "azuread_application_password" "meshcloud_sso" {
  application_object_id = azuread_application.meshcloud_sso.object_id
}
