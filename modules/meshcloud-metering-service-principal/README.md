<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.18.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.18.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.meshcloud_metering](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application) | resource |
| [azuread_service_principal.meshcloud_metering](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal) | resource |
| [azuread_application_password.application_pw](https://registry.terraform.io/providers/hashicorp/azuread/2.43.0/docs/resources/application_password) | resource |
| [time_rotating.replicator_secret_rotation](https://registry.terraform.io/providers/hashicorp/time/0.9.1/docs/resources/rotating) | resource |
| [azurerm_role_assignment.meshcloud_metering](https://registry.terraform.io/providers/hashicorp/azurerm/3.3.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.meshcloud_metering_cloud_inventory](https://registry.terraform.io/providers/hashicorp/azurerm/3.3.0/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.meshcloud_metering_cloud_inventory_role](https://registry.terraform.io/providers/hashicorp/azurerm/3.3.0/docs/resources/role_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_scope"></a> [scope](#input\_scope) | The scope to which Service Principal permissions should be assigned to. Usually this is the management group id of form `/providers/Microsoft.Management/managementGroups/<tenantId>` that sits atop the subscriptions. | `string` | n/a | yes |
| <a name="input_service_principal_name_suffix"></a> [service\_principal\_name\_suffix](#input\_service\_principal\_name\_suffix) | Service principal name suffix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_credentials"></a> [credentials](#output\_credentials) | Service Principal application id and object id |
| <a name="output_application_client_secret"></a> [application\_client\_secret](#output\_application\_client\_secret) | Password for the Service Principal. |
<!-- END_TF_DOCS -->