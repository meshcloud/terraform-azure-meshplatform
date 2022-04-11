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
| [azuread_application.meshcloud_kraken](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application) | resource |
| [azuread_service_principal.meshcloud_kraken](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.service_principal_pw](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal_password) | resource |
| [azurerm_role_assignment.meshcloud_kraken](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.meshcloud_kraken_cloud_inventory](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.meshcloud_kraken_cloud_inventory_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/role_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_scope"></a> [scope](#input\_scope) | The scope to which Service Principal permissions should be assigned to. Usually this is a management group that sits atop the subscriptions. | `string` | n/a | yes |
| <a name="input_service_principal_name_suffix"></a> [service\_principal\_name\_suffix](#input\_service\_principal\_name\_suffix) | Service principal name suffix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_principal"></a> [service\_principal](#output\_service\_principal) | Service Principal application id and object id |
| <a name="output_service_principal_password"></a> [service\_principal\_password](#output\_service\_principal\_password) | Password for the Service Principal. |
