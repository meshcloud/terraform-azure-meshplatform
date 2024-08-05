# Azure meshPlatform Module

Terraform module to integrate Azure as a meshPlatform into meshStack instance. With this module, service principals used by meshStack are created with the required permissions. The output of this module is a set of credentials that need to be configured in meshStack as described in [meshcloud public docs](https://docs.meshcloud.io/docs/meshstack.how-to.integrate-meshplatform.html).

We currently support [Microsoft Enterprise Agreements](https://www.microsoft.com/en-us/licensing/licensing-programs/enterprise?activetab=enterprise-tab%3aprimaryr2) and [Microsoft Customer Agreements](https://www.microsoft.com/en-us/licensing/how-to-buy/microsoft-customer-agreement) as well as pre-provisioned subscriptions when integrating Azure as a meshPlatform.

<p align="center">
  <img src="https://github.com/meshcloud/terraform-azure-meshplatform/assets/96071919/b18a128b-8a43-44ea-80da-bf42e58fd61a" width="250">
</p>

## Prerequisites

To run this module, you need the following:

- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli) (already installed in Azure Portal)
- [Azure CLI installed](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (already installed in Azure Portal)
- Permissions on AAD level. If using Microsoft Customer Agreement, AAD level permissions must be set in the Tenant Directory that will create the subscriptions (*Source Tenant*) as well as the Tenant Directory that will receive the subscriptions (*Destination Tenant*). An Azure account with one of the following roles:
  1. Global Administrator
  2. Privileged Role Administrator AND (Cloud) Application Administrator
- Permissions on Azure Resource Level: User Access Administrator on the Management Group that should be managed by meshStack

## How to Use This Module

### Using Azure Portal

> If using a **Microsoft Customer Agreement**, go through these steps in the **Destination Tenant**

1. Login into [Azure Portal](https://portal.azure.com/) with your Admin user.

2. Open a cloud shell.

3. Create a terraform file that calls this module and produces outputs. Similar to:

    ```hcl
    module "meshplatform" {
      source = "git::https://github.com/meshcloud/terraform-azure-meshplatform.git"
      # FILL INPUTS
    }
    output "meshplatform" {
      sensitive = true
      value     = module.meshplatform
    }
    ```

    > It is highly recommended to configure a [terraform backend](https://developer.hashicorp.com/terraform/language/settings/backends/configuration), otherwise you risk losing track of your applied resources.

4. Execute the module.

    ```powershell
    # Changes into ~/terraform-azure-meshplatform and applies terraform
    cd ~/terraform-azure-meshplatform
    terraform init
    terraform apply
    ```

5. Use the information from terraform output to configure the platform in meshStack.

    ```sh
    # The JSON output contains sensitive values that must not be transmitted anywhere other then the platform config screen in meshStack.
    terraform output -json
    ```

### Using CLI

1. Login with az CLI

    ```sh
   az login --tenant TENANT_ID
   ```

2. Follow the instructions for Azure Portal

## Configuring the Azure meshPlatform module

### Using an Enterprise Agreement

> Using an Enterprise Agreement enrollment account requires manual steps outside of terraform.

1. Ensure you have permissions on [Enterprise Agreement level](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/understand-ea-roles): `Account Owner` for the enrollment account that should be used for creating subscriptions
2. Grant access on the enrollment account as described in the section [Use an Enteprise Enrollment](https://docs.meshcloud.io/docs/meshstack.how-to.integrate-meshplatform-azure-manually.html#use-an-enterprise-enrollment).

### Using Microsoft Customer Agreement

**Prerequisites**:

- Ensure you have permissions in the source AAD Tenant for granting access to the billing account used for subscription creation using the `Account Administrator` role

**Create MCA service principals**:

> With this module, you can create multiple MCA service principals by passing a list of `mca.service_principal_names`. This is useful for environments with restricted acceses to the AAD tenant holding the MCA license.

Add an `mca` block when calling this module.

e.g.:

```hcl
module "meshplatform" {
  source  = "meshcloud/meshplatform/azure"
  # required inputs

  mca = {
      service_principal_names = ["your-mca-sp-name-1", "your-mca-sp-name-2", "..."]
      billing_account_name    = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx_xxxx-xx-xx"
      billing_profile_name    = "xxxx-xxxx-xxx-xxx"
      invoice_section_name    = "xxxx-xxxx-xxx-xxx"
  }
}
```

### Using Pre-provisioned Subscriptions

meshStack will need to be able to read subscriptions at the source location
(typically the root of your management group hierarchy) and then have permission to rename them.
Please include the following `additional_permission` when configuring this terraform module.

```hcl
  additional_permissions = ["Microsoft.Subscription/rename/action"]
```

### Enabling Azure Functions for Landing Zones

In order to enable meshStack to call Azure Functions as part of tenant replication for your landing zones, you must
provide the SPN with access to the function.

```hcl

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
```

## Single Sign On (SSO) Integration

>While this does not belong to a meshplatform, you can enable sso using this module. This is subject to change and sso can be moved out in the future.

To login to meshStack with Microsoft Entra ID, you can create an SSO service principal by adding the following inputs when calling this module:

```hcl
sso_enabled = true

# This is required as it will construct the redirect uri. A default has been added only so that it's not mandatory to setup sso (i.e. when sso_enabled = false)
sso_meshstack_idp_domain = "sso.<domain>"
```

## Contributing Guide

Before opening a Pull Request, please do the following:

1. Install [pre-commit](https://pre-commit.com/#install)

   We use pre-commit to perform several terraform related tasks such as `terraform validate`, `terraform fmt`, and generating terraform docs with `terraform_docs`

2. Execute `pre-commit install`: Hooks configured in `.pre-commit-config.yaml` will be executed automatically on commit. For manual execution, you can use `pre-commit run -a`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.1 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >=1.13.1 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.46.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.114.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mca_service_principal"></a> [mca\_service\_principal](#module\_mca\_service\_principal) | ./modules/meshcloud-mca-service-principal | n/a |
| <a name="module_metering_service_principal"></a> [metering\_service\_principal](#module\_metering\_service\_principal) | ./modules/meshcloud-metering-service-principal/ | n/a |
| <a name="module_replicator_service_principal"></a> [replicator\_service\_principal](#module\_replicator\_service\_principal) | ./modules/meshcloud-replicator-service-principal/ | n/a |
| <a name="module_sso_service_principal"></a> [sso\_service\_principal](#module\_sso\_service\_principal) | ./modules/meshcloud-sso/ | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_management_group.metering_assignment_scopes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_management_group.replicator_assignment_scopes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_management_group.replicator_custom_role_scope](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Additional Subscription-Level Permissions the Service Principal needs. | `list(string)` | `[]` | no |
| <a name="input_additional_required_resource_accesses"></a> [additional\_required\_resource\_accesses](#input\_additional\_required\_resource\_accesses) | Additional AAD-Level Resource Accesses the replicator Service Principal needs. | `list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))` | `[]` | no |
| <a name="input_application_owners"></a> [application\_owners](#input\_application\_owners) | List of user principals that should be added as owners to the created service principals. | `list(string)` | `[]` | no |
| <a name="input_can_cancel_subscriptions_in_scopes"></a> [can\_cancel\_subscriptions\_in\_scopes](#input\_can\_cancel\_subscriptions\_in\_scopes) | The scopes to which Service Principal cancel subscription permission is assigned to. List of management group id of form `/providers/Microsoft.Management/managementGroups/<mgmtGroupId>/`. | `list(string)` | `[]` | no |
| <a name="input_can_delete_rgs_in_scopes"></a> [can\_delete\_rgs\_in\_scopes](#input\_can\_delete\_rgs\_in\_scopes) | The scopes to which Service Principal delete resource group permission is assigned to. Only relevant when `replicator_rg_enabled`. List of subscription scopes of form `/subscriptions/<subscriptionId>`. | `list(string)` | `[]` | no |
| <a name="input_create_passwords"></a> [create\_passwords](#input\_create\_passwords) | Create passwords for service principals. | `bool` | `true` | no |
| <a name="input_mca"></a> [mca](#input\_mca) | n/a | <pre>object({<br>    service_principal_names = list(string)<br>    billing_account_name    = string<br>    billing_profile_name    = string<br>    invoice_section_name    = string<br>  })</pre> | `null` | no |
| <a name="input_metering_assignment_scopes"></a> [metering\_assignment\_scopes](#input\_metering\_assignment\_scopes) | Names or UUIDs of the Management Groups that kraken should collect costs for. | `list(string)` | n/a | yes |
| <a name="input_metering_enabled"></a> [metering\_enabled](#input\_metering\_enabled) | Whether to create Metering Service Principal or not. | `bool` | `true` | no |
| <a name="input_metering_service_principal_name"></a> [metering\_service\_principal\_name](#input\_metering\_service\_principal\_name) | Service principal for collecting cost data. Kraken ist the name of the meshStack component. Name must be unique per Entra ID. | `string` | `"kraken"` | no |
| <a name="input_replicator_assignment_scopes"></a> [replicator\_assignment\_scopes](#input\_replicator\_assignment\_scopes) | Names or UUIDs of the Management Groups which replicator should manage. | `list(string)` | n/a | yes |
| <a name="input_replicator_custom_role_scope"></a> [replicator\_custom\_role\_scope](#input\_replicator\_custom\_role\_scope) | Name or UUID of the Management Group of the replicator custom role definition. The custom role definition must be available for all assignment scopes. | `string` | n/a | yes |
| <a name="input_replicator_enabled"></a> [replicator\_enabled](#input\_replicator\_enabled) | Whether to create replicator Service Principal or not. | `bool` | `true` | no |
| <a name="input_replicator_rg_enabled"></a> [replicator\_rg\_enabled](#input\_replicator\_rg\_enabled) | Whether the created replicator Service Principal should be usable for Azure Resource Group based replication. Implicitly enables replicator\_enabled if set to true. | `bool` | `false` | no |
| <a name="input_replicator_service_principal_name"></a> [replicator\_service\_principal\_name](#input\_replicator\_service\_principal\_name) | Service principal for managing subscriptions. Replicator is the name of the meshStack component. Name must be unique per Entra ID. | `string` | `"replicator"` | no |
| <a name="input_sso_app_role_assignment_required"></a> [sso\_app\_role\_assignment\_required](#input\_sso\_app\_role\_assignment\_required) | Whether all users can login using the created application (false), or only assigned users (true) | `bool` | `false` | no |
| <a name="input_sso_enabled"></a> [sso\_enabled](#input\_sso\_enabled) | Whether to create SSO Service Principal. This service principal is used to integrate meshStack identity provider with your own identity provider. | `bool` | `false` | no |
| <a name="input_sso_identity_provider_alias"></a> [sso\_identity\_provider\_alias](#input\_sso\_identity\_provider\_alias) | Identity provider alias. This value needs to be passed to meshcloud to configure the identity provider. | `string` | `"oidc"` | no |
| <a name="input_sso_meshstack_idp_domain"></a> [sso\_meshstack\_idp\_domain](#input\_sso\_meshstack\_idp\_domain) | meshStack identity provider domain that was provided by meshcloud. It is individual per meshStack. In most cases it is sso.<portal-domain> | `string` | `"replaceme"` | no |
| <a name="input_sso_service_principal_name"></a> [sso\_service\_principal\_name](#input\_sso\_service\_principal\_name) | Service principal for Entra ID SSO. Name must be unique per Entra ID. | `string` | `"meshcloud SSO"` | no |
| <a name="input_workload_identity_federation"></a> [workload\_identity\_federation](#input\_workload\_identity\_federation) | Enable workload identity federation by creating federated credentials for enterprise applications. Usually you'd receive the required settings when attempting to configure a platform with workload identity federation in meshStack. | `object({ issuer = string, replicator_subject = string, kraken_subject = string })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_ad_tenant_id"></a> [azure\_ad\_tenant\_id](#output\_azure\_ad\_tenant\_id) | The Azure AD tenant id. |
| <a name="output_mca_service_principal"></a> [mca\_service\_principal](#output\_mca\_service\_principal) | MCA Service Principal. |
| <a name="output_mca_service_principal_password"></a> [mca\_service\_principal\_password](#output\_mca\_service\_principal\_password) | Password for MCA Service Principal. |
| <a name="output_metering_service_principal"></a> [metering\_service\_principal](#output\_metering\_service\_principal) | Metering Service Principal. |
| <a name="output_metering_service_principal_password"></a> [metering\_service\_principal\_password](#output\_metering\_service\_principal\_password) | Password for Metering Service Principal. |
| <a name="output_replicator_service_principal"></a> [replicator\_service\_principal](#output\_replicator\_service\_principal) | Replicator Service Principal. |
| <a name="output_replicator_service_principal_password"></a> [replicator\_service\_principal\_password](#output\_replicator\_service\_principal\_password) | Password for Replicator Service Principal. |
| <a name="output_sso_discovery_url"></a> [sso\_discovery\_url](#output\_sso\_discovery\_url) | SSO applications's discovery url (OpenID Connect metadata document) |
| <a name="output_sso_service_principal_client_id"></a> [sso\_service\_principal\_client\_id](#output\_sso\_service\_principal\_client\_id) | SSO Service Principal. |
| <a name="output_sso_service_principal_password"></a> [sso\_service\_principal\_password](#output\_sso\_service\_principal\_password) | Password for SSO Service Principal. |
<!-- END_TF_DOCS -->
