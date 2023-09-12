# It is highly recommended to setup a backend to store the terraform state file
# Removing the backend will output the terraform state in the local filesystem
# See https://www.terraform.io/language/settings/backends for more details
#
# Remove/comment the backend block below if you are only testing the module.
# Please be aware that you cannot destroy the created resources via terraform if you lose the state file.
terraform {
  backend "azurerm" {
    tenant_id            = "aadTenantId"
    subscription_id      = "subscriptionId"
    resource_group_name  = "rg-cloud-foundation"
    storage_account_name = "tfstatesiqw0x"
    container_name       = "tfstates"
    key                  = "meshplatform-setup"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

provider "azuread" {
  # Configuration options
}

module "meshplatform" {
  source = "meshcloud/meshplatform/azure"

  service_principal_name_suffix = "<UNIQUE_NAME>"
  mgmt_group_name               = "<MANAGEMENT_GROUP_NAME>|<MANAGEMENT_GROUP_ID>" # Either the Management group Name or ID
}
