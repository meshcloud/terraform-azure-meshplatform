## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.18.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.97.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.18.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.97.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.meshcloud_replicator-directory](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.meshcloud_replicator-group](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.meshcloud_replicator-user](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/app_role_assignment) | resource |
| [azuread_application.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application) | resource |
| [azuread_service_principal.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal) | resource |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.spp_pw](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal_password) | resource |
| [azurerm_role_assignment.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/role_definition) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/application_published_app_ids) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Additional Subscription-Level Permissions the SPP needs. | `list(string)` | `[]` | no |
| <a name="input_additional_required_resource_accesses"></a> [additional\_required\_resource\_accesses](#input\_additional\_required\_resource\_accesses) | Additional AAD-Level Resource Accesses the SPP needs. | `list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))` | `[]` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope to which SPP permissions should be assigned to. Usually this is a management group that sits atop the subscriptions. | `string` | n/a | yes |
| <a name="input_spp_name_suffix"></a> [spp\_name\_suffix](#input\_spp\_name\_suffix) | Service principal name suffix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_principal"></a> [service\_principal](#output\_service\_principal) | Service Principal application id and object id |
| <a name="output_service_principal_password"></a> [service\_principal\_password](#output\_service\_principal\_password) | Password for the Service Principal. |
