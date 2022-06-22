
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.18.0"
    }
  }
}

resource "azurerm_role_definition" "meshcloud_replicator" {
  name        = "replicator.${var.service_principal_name_suffix}"
  scope       = var.scope
  description = "Permissions required by meshcloud in order to configure subscriptions and manage users"

  permissions {
    actions = concat([

      # Assigning Users
      "Microsoft.Authorization/permissions/read",
      "Microsoft.Authorization/roleAssignments/*",
      "Microsoft.Authorization/roleDefinitions/read",

      # Assigning Blueprints
      "Microsoft.Resources/deployments/*",
      "Microsoft.Blueprint/blueprintAssignments/*",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/deployments/*",

      # Fetching Blueprints
      "Microsoft.Management/managementGroups/read",
      "Microsoft.Management/managementGroups/descendants/read",

      # Assigning Subscriptions to Management Groups
      "Microsoft.Management/managementGroups/subscriptions/write",
      "Microsoft.Management/managementGroups/write",

      # Permissions for reading and writing tags
      "Microsoft.Resources/tags/*",

      # Permission we need to activate/register required Resource Providers
      "*/register/action"
    ], var.additional_permissions)
  }

  assignable_scopes = [
    var.scope
  ]
}

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

resource "azuread_application" "meshcloud_replicator" {
  display_name = "replicator.${var.service_principal_name_suffix}"

  web {
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }
  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Directory.Read.All"]
      type = "Role"
    }

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
      type = "Role"
    }

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["User.Invite.All"]
      type = "Role"
    }
  }

  dynamic "required_resource_access" {
    for_each = var.additional_required_resource_accesses

    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_accesses
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }

  # NOTE: currently it is not possible to automate the "Grant admin consent button"
  # https://github.com/terraform-providers/terraform-provider-azuread/issues/33
  # As a result we have to ignore this value in terraform for now
  # In addition please keep in mind you have to grant admin consent manually
  lifecycle {
    ignore_changes = [
      app_role
    ]
  }
}

resource "azuread_service_principal" "meshcloud_replicator" {
  application_id = azuread_application.meshcloud_replicator.application_id
  # The following tags are needed to create an Enterprise Application
  # See https://github.com/hashicorp/terraform-provider-azuread/issues/7#issuecomment-529597534
  tags = [
    "WindowsAzureActiveDirectoryIntegratedApp",
  ]
}

resource "azurerm_role_assignment" "meshcloud_replicator" {
  scope              = var.scope
  role_definition_id = azurerm_role_definition.meshcloud_replicator.role_definition_resource_id
  principal_id       = azuread_service_principal.meshcloud_replicator.id
}

resource "azuread_app_role_assignment" "meshcloud_replicator-directory" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Directory.Read.All"]
  principal_object_id = azuread_service_principal.meshcloud_replicator.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "meshcloud_replicator-group" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
  principal_object_id = azuread_service_principal.meshcloud_replicator.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "meshcloud_replicator-user" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["User.Invite.All"]
  principal_object_id = azuread_service_principal.meshcloud_replicator.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_service_principal_password" "service_principal_pw" {
  service_principal_id = azuread_service_principal.meshcloud_replicator.id
  end_date             = "2999-01-01T01:02:03Z" # no expiry
}

# Terraform does not find the blueprint service principal, even though I find it with
# ` az ad sp list --filter "appId eq 'f71766dc-90d9-4b7d-bd9d-4499c4331c3f'"`
# data "azuread_application" "blueprint_service_principal" {
#   application_id = "f71766dc-90d9-4b7d-bd9d-4499c4331c3f"
# }

# facilitate migration from v0.1.0 of the module
moved {
  from = azuread_service_principal_password.spp_pw
  to   = azuread_service_principal_password.service_principal_pw
}
