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
| [azuread_administrative_unit.meshcloud_replicator_au](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/administrative_unit) | resource |
| [azuread_administrative_unit_role_member.groups_admin_assignment](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/administrative_unit_role_member) | resource |
| [azuread_administrative_unit_role_member.user_admin_assignment](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/administrative_unit_role_member) | resource |
| [azuread_app_role_assignment.meshcloud_replicator-administrativeunit](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.meshcloud_replicator-directory](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.meshcloud_replicator-group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.meshcloud_replicator-user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.meshcloud_replicator-users_read_all](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_application.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_application_password.application_pw](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_directory_role.groups_administrator](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/directory_role) | resource |
| [azuread_directory_role.user_administrator](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/directory_role) | resource |
| [azuread_service_principal.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_management_group_policy_assignment.privilege-escalation-prevention](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_policy_definition.privilege_escalation_prevention](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_role_assignment.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.meshcloud_replicator_rg_deleter](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.meshcloud_replicator_subscription_canceler](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.meshcloud_replicator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.meshcloud_replicator_rg_deleter](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.meshcloud_replicator_subscription_canceler](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [terraform_data.allowed_assignments](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [time_rotating.replicator_secret_rotation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_application_template.enterprise_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_template) | data source |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Additional Subscription-Level Permissions the Service Principal needs. | `list(string)` | `[]` | no |
| <a name="input_additional_required_resource_accesses"></a> [additional\_required\_resource\_accesses](#input\_additional\_required\_resource\_accesses) | Additional AAD-Level Resource Accesses the Service Principal needs. | `list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))` | `[]` | no |
| <a name="input_administrative_unit_name"></a> [administrative\_unit\_name](#input\_administrative\_unit\_name) | Display name of the adminstration-unit name where the user groups are managed. | `string` | `null` | no |
| <a name="input_application_owners"></a> [application\_owners](#input\_application\_owners) | List of user principals that should be added as owners to the replicator service principal. | `list(string)` | `[]` | no |
| <a name="input_assignment_scopes"></a> [assignment\_scopes](#input\_assignment\_scopes) | The scopes to which Service Principal permissions is assigned to. List of management group id of form `/providers/Microsoft.Management/managementGroups/<mgmtGroupId>/`. | `list(string)` | n/a | yes |
| <a name="input_can_cancel_subscriptions_in_scopes"></a> [can\_cancel\_subscriptions\_in\_scopes](#input\_can\_cancel\_subscriptions\_in\_scopes) | The scopes to which Service Principal cancel subscription permission is assigned to. List of management group id of form `/providers/Microsoft.Management/managementGroups/<mgmtGroupId>/`. | `list(string)` | `[]` | no |
| <a name="input_can_delete_rgs_in_scopes"></a> [can\_delete\_rgs\_in\_scopes](#input\_can\_delete\_rgs\_in\_scopes) | The scopes to which Service Principal delete resource group permission is assigned to. Only relevant when `replicator_rg_enabled`. List of subscription scopes of form `/subscriptions/<subscriptionId>`. | `list(string)` | `[]` | no |
| <a name="input_create_password"></a> [create\_password](#input\_create\_password) | Create a password for the enterprise application. | `bool` | n/a | yes |
| <a name="input_custom_role_scope"></a> [custom\_role\_scope](#input\_custom\_role\_scope) | The scope to which Service Principal permissions can be assigned to. Usually this is the management group id of form `/providers/Microsoft.Management/managementGroups/<tenantId>` that sits atop the subscriptions. | `string` | n/a | yes |
| <a name="input_replicator_rg_enabled"></a> [replicator\_rg\_enabled](#input\_replicator\_rg\_enabled) | Whether the created replicator Service Principal should be usable for Azure Resource Group based replication. | `bool` | `false` | no |
| <a name="input_service_principal_name"></a> [service\_principal\_name](#input\_service\_principal\_name) | Display name of the replicator service principal. | `string` | n/a | yes |
| <a name="input_workload_identity_federation"></a> [workload\_identity\_federation](#input\_workload\_identity\_federation) | Enable workload identity federation instead of using a password by providing these additional settings. Usually you should receive the required settings when attempting to configure a platform with workload identity federation in meshStack. | `object({ issuer = string, subject = string })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_client_secret"></a> [application\_client\_secret](#output\_application\_client\_secret) | Client Secret Of the Application. |
| <a name="output_credentials"></a> [credentials](#output\_credentials) | Service Principal application id and object id |
<!-- END_TF_DOCS -->