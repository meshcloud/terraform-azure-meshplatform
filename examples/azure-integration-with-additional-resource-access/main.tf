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

  additional_required_resource_accesses = [
    # The block below configures replicator access
    # to the app with id `fe81736c-99c6-4fca-8cc2-2818a2365451` with the appRole with id `e29066a1-ecb1-4a8e-af2d-1627fae35711`
    #
    # This example configures access to an azure function
    {
      resource_app_id = "fe81736c-99c6-4fca-8cc2-2818a2365451" # https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application#resource_app_id
      resource_accesses = [
        # https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application#resource_access
        {
          id   = "e29066a1-ecb1-4a8e-af2d-1627fae35711"
          type = "Role"
        },
      ]
    },
  ]

}
