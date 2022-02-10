
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

resource "azurerm_role_definition" "meshcloud_replicator" {
  name        = "replicator.${var.spp_name_suffix}"
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
      "Microsoft.Resources/tags/write",

      # Permission we need to activate/register required Resource Providers
      "*/register/action"
    ], var.additional_permissions)
  }

  assignable_scopes = [
    var.scope
  ]
}

resource "azuread_application" "meshcloud_replicator" {
  name = "replicator.${var.spp_name_suffix}"

  oauth2_allow_implicit_flow = false

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All
      type = "Role"
    }

    resource_access {
      id   = "62a82d76-70ea-41e2-9197-370581804d09" # Group.ReadWrite.All
      type = "Role"
    }

    resource_access {
      id   = "09850681-111b-4a89-9bed-3f2cae46d706" # User.Invite.All
      type = "Role"
    }
  }

  # These configure additional required_resource_accesses that can be specified by the caller of the module
  # They are useful if replicator needs resource access specifically scoped to a meshstack implementation (e.g. accessing an azure function)
  # Example usage:
  #
  # additional_required_resource_accesses = [
  #   
  #   {
  #     resource_app_id = "fe81736c-99c6-4fca-8cc2-2818a2365451"
  #     resource_accesses = [
  #       {
  #         id   = "e29066a1-ecb1-4a8e-af2d-1627fae35711" # Access (SPP-Access)
  #         type = "Role"
  #       },
  #     ]
  #   },
  # ]

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
  role_definition_id = azurerm_role_definition.meshcloud_replicator.id
  principal_id       = azuread_service_principal.meshcloud_replicator.id
}

resource "random_password" "spp_pw" {
  length = 64
  # Currently there are some passwords which do not allow you to login using az cli (see https://github.com/Azure/azure-cli/issues/12332)
  # Which is the reason we have set the flag to false
  special = false
}

resource "azuread_service_principal_password" "spp_pw" {
  service_principal_id = azuread_service_principal.meshcloud_replicator.id
  value                = random_password.spp_pw.result
  end_date             = "2999-01-01T01:02:03Z" # no expiry
}
