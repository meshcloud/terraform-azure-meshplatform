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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application) | resource |
| [azuread_application_password.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application_password) | resource |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/application_published_app_ids) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_meshstack_redirect_uri"></a> [meshstack\_redirect\_uri](#input\_meshstack\_redirect\_uri) | Redirect URI that will be provided by meshcloud. It is individual per meshStack. | `string` | n/a | yes |
| <a name="input_spp_name_suffix"></a> [spp\_name\_suffix](#input\_spp\_name\_suffix) | Service principal name suffix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_registration"></a> [app\_registration](#output\_app\_registration) | Application registration application id and object id |
| <a name="output_app_registration_client_secret"></a> [app\_registration\_client\_secret](#output\_app\_registration\_client\_secret) | Password for the application registration. |
