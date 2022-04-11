# It is highly recommended to setup a backend to store the terraform state file
# Removing the backend will output the terraform state in the local filesystem
# See https://www.terraform.io/language/settings/backends for more details
#
# Remove/comment the backend block below if you are only testing the module.
# Please be aware that you cannot destroy the created resources via terraform if you lose the state file.
terraform {
  backend "gcs" {
    prefix = "meshplatforms/azure"
    bucket = "my-terraform-states"
  }
}

module "meshplatform" {
  source = "git::https://github.com/meshcloud/terraform-azure-meshplatform.git"

  service_principal_name_suffix = "<UNIQUE_NAME>"
  mgmt_group_name               = "<MANAGEMENT_GROUP_NAME>|<MANAGEMENT_GROUP_UUID>"

}
