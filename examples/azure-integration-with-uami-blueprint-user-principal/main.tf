# It is recommended to setup a backend to store the terraform state file
# Removing the backend leads to terraform state output stored in the local filesystem.
# See https://www.terraform.io/language/settings/backends for more details
terraform {
  backend "gcs" {
    prefix = "meshplatforms/azure"
    bucket = "my-terraform-states"
  }
}

module "meshplatform" {
  source = "meshcloud/meshplatform/azure"

  service_principal_name_suffix = "<UNIQUE_NAME>"
  mgmt_group_name               = "<MANAGEMENT_GROUP_NAME>|<MANAGEMENT_GROUP_UUID>"

  subscriptions = ["<SUBSCRIPTION_ID>"]
}
