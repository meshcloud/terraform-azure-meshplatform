<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.meshcloud_metering](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.meshcloud_metering](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_application_password.application_pw](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.meshcloud_metering](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.meshcloud_metering](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [time_rotating.replicator_secret_rotation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_owners"></a> [application\_owners](#input\_application\_owners) | List of user principals that should be added as owners to the metering service principal. | `list(string)` | `[]` | no |
| <a name="input_assignment_scopes"></a> [assignment\_scopes](#input\_assignment\_scopes) | The scopes to which Service Principal permissions should be assigned to. Usually this is the management group id of form `/providers/Microsoft.Management/managementGroups/<tenantId>` that sits atop the subscriptions. | `list(string)` | n/a | yes |
| <a name="input_create_password"></a> [create\_password](#input\_create\_password) | Create a password for the enterprise application. | `bool` | n/a | yes |
| <a name="input_service_principal_name"></a> [service\_principal\_name](#input\_service\_principal\_name) | Service principal name. Must be unique per Entra ID. | `string` | n/a | yes |
| <a name="input_workload_identity_federation"></a> [workload\_identity\_federation](#input\_workload\_identity\_federation) | Enable workload identity federation instead of using a password by providing these additional settings. Usually you should receive the required settings when attempting to configure a platform with workload identity federation in meshStack. | `object({ issuer = string, subject = string })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_client_secret"></a> [application\_client\_secret](#output\_application\_client\_secret) | Client Secret Of the Application. |
| <a name="output_credentials"></a> [credentials](#output\_credentials) | Service Principal application id and object id |
<!-- END_TF_DOCS -->