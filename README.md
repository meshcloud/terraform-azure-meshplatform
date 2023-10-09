# Azure meshPlatform Module

Terraform module to integrate Azure as a meshPlatform into meshStack instance. With this module, service principals used by meshStack are created with the required permissions. The output of this module is a set of credentials that need to be configured in meshStack as described in [meshcloud public docs](https://docs.meshcloud.io/docs/meshstack.how-to.integrate-meshplatform.html).

We currently support [Microsoft Enterprise Agreements](https://www.microsoft.com/en-us/licensing/licensing-programs/enterprise?activetab=enterprise-tab%3aprimaryr2) and [Microsoft Customer Agreements](https://www.microsoft.com/en-us/licensing/how-to-buy/microsoft-customer-agreement) when integrating Azure as a meshPlatform.

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

### If using an Enterprise Agreement
- Permissions on [Enterprise Agreement level](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/understand-ea-roles): Account Owner for the enrollment account that should be used for creating subscriptions

### If using a Microsoft Customer Agreement
- Permissions in Source Tenant for granting access to the billing account used for subscription creation: Account Administrator

## How to Use This Module

### Using Azure Portal

> If using a **Microsoft Customer Agreement**, go through these steps in the **Destination Tenant**

1. Login into [Azure Portal](https://portal.azure.com/) with your Admin user.

2. Open a cloud shell.

3. Download the example `main.tf` and `outputs.tf` files.

    ```powershell
    # Downloads main.tf and outputs.tf files into ~/terraform-azure-meshplatform
    wget https://raw.githubusercontent.com/meshcloud/terraform-azure-meshplatform/main/examples/basic-azure-integration/main.tf -P ~/terraform-azure-meshplatform
    wget https://raw.githubusercontent.com/meshcloud/terraform-azure-meshplatform/main/examples/basic-azure-integration/outputs.tf -P ~/terraform-azure-meshplatform
    ```

4. Open `~/terraform-azure-meshplatform/main.tf` with a text editor. Modify the module variables and Terraform state backend settings in the file.

5. Execute the module.

    ```powershell
    # Changes into ~/terraform-azure-meshplatform and applies terraform
    cd ~/terraform-azure-meshplatform
    terraform init
    terraform apply
    ```

6. Use the information from terraform output to configure the platform in meshStack.

    ```sh
    # The JSON output contains sensitive values that must not be transmitted anywhere other then the platform config screen in meshStack.
    terraform output -json
    ```

#### If Using an Enterprise Agreement
1. Grant access on the enrollment account as described in the section [Use an Enteprise Enrollment](https://docs.meshcloud.io/docs/meshstack.how-to.integrate-meshplatform-azure-manually.html#use-an-enterprise-enrollment).

#### If Using Microsoft Customer Agreement
1. Switch to the Tenant Directory that contains your Billing Account and follow the steps to [Register an Application](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#register-an-application) and [Add Credentials](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#add-credentials). Make sure to copy down the **Directory (tenant) ID**, **Application (client) ID**, **Object ID** and the **App Secret** value that was generated. The App Secret is only visible during the creation process.
2. You must grant the Enterprise Application permissions on the Billing Account, Billing Profile, or Invoice Section so that it can generate new subscriptions. Follow the steps in [this guide](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/understand-mca-roles#manage-billing-roles-in-the-azure-portal) to grant the necessary permissions. You must grant one of the following permissions
  - Billing Account or Billing Profile: Owner, Contributor
  - Invoice Section: Owner, Contributor, Azure Subscription Creator
3. Write down the Billing Scope ID that looks something like this <samp>/providers/Microsoft.Billing/billingAccounts/5e98e158-xxxx-xxxx-xxxx-xxxxxxxxxxxx:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx_xxxx-xx-xx/billingProfiles/AW4F-xxxx-xxx-xxx/invoiceSections/SH3V-xxxx-xxx-xxx</samp>
4. Use the following information to configure the platform in meshStack
  - Billing Scope
  - Destination Tenant ID
  - Source Tenant ID
  - Billing Account Principal Client ID (Application Client ID that will be used to create new subscriptions)
  - Principal Client Secret (Application Secret created in the Source Tenant)

### Using CLI

1. Login with az CLI

    ```sh
   az login --tenant TENANT_ID
   ```

2. Follow the instructions for Azure Portal

## Example Usages

Check [examples](./examples/) for different use cases. As a quick start we recommend using [basic-azure-integration](./examples/basic-azure-integration) example.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.18.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.18.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_idp_lookup_service_principal"></a> [idp\_lookup\_service\_principal](#module\_idp\_lookup\_service\_principal) | ./modules/meshcloud-idp-lookup-service-principal/ | n/a |
| <a name="module_metering_service_principal"></a> [metering\_service\_principal](#module\_metering\_service\_principal) | ./modules/meshcloud-metering-service-principal/ | n/a |
| <a name="module_replicator_service_principal"></a> [replicator\_service\_principal](#module\_replicator\_service\_principal) | ./modules/meshcloud-replicator-service-principal/ | n/a |
| <a name="module_uami_blueprint_user_principal"></a> [uami\_blueprint\_user\_principal](#module\_uami\_blueprint\_user\_principal) | ./modules/uami-blueprint-user-principal/ | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/client_config) | data source |
| [azurerm_management_group.root](https://registry.terraform.io/providers/hashicorp/azurerm/3.3.0/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Additional Subscription-Level Permissions the Service Principal needs. | `list(string)` | `[]` | no |
| <a name="input_additional_required_resource_accesses"></a> [additional\_required\_resource\_accesses](#input\_additional\_required\_resource\_accesses) | Additional AAD-Level Resource Accesses the replicator Service Principal needs. | `list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))` | `[]` | no |
| <a name="input_idplookup_enabled"></a> [idplookup\_enabled](#input\_idplookup\_enabled) | Whether to create idplookup Service Principal or not. | `bool` | `true` | no |
| <a name="input_metering_enabled"></a> [metering\_enabled](#input\_metering\_enabled) | Whether to create Metering Service Principal or not. | `bool` | `true` | no |
| <a name="input_mgmt_group_name"></a> [mgmt\_group\_name](#input\_mgmt\_group\_name) | The name or UUID of the Management Group. | `string` | n/a | yes |
| <a name="input_replicator_enabled"></a> [replicator\_enabled](#input\_replicator\_enabled) | Whether to create replicator Service Principal or not. | `bool` | `true` | no |
| <a name="input_replicator_rg_enabled"></a> [replicator\_rg\_enabled](#input\_replicator\_rg\_enabled) | Enables the replicator service principal to be used for Azure Resource Group replication. Implicitly enables the `replicator_enabled` flag. | `bool` | `true` | no |
| <a name="input_service_principal_name_suffix"></a> [service\_principal\_name\_suffix](#input\_service\_principal\_name\_suffix) | Service principal name suffix. Make sure this is unique. | `string` | n/a | yes |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | The scope to which UAMI blueprint service principal role assignment is applied. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_ad_tenant_id"></a> [azure\_ad\_tenant\_id](#output\_azure\_ad\_tenant\_id) | The Azure AD tenant id. |
| <a name="output_idp_lookup_service_principal"></a> [idp\_lookup\_service\_principal](#output\_idp\_lookup\_service\_principal) | IDP Lookup Service Principal. |
| <a name="output_idp_lookup_service_principal_password"></a> [idp\_lookup\_service\_principal\_password](#output\_idp\_lookup\_service\_principal\_password) | Password for IDP Lookup Service Principal. |
| <a name="output_metering_service_principal"></a> [metering\_service\_principal](#output\_metering\_service\_principal) | Metering Service Principal. |
| <a name="output_metering_service_principal_password"></a> [metering\_service\_principal\_password](#output\_metering\_service\_principal\_password) | Password for Metering Service Principal. |
| <a name="output_replicator_service_principal"></a> [replicator\_service\_principal](#output\_replicator\_service\_principal) | Replicator Service Principal. |
| <a name="output_replicator_service_principal_password"></a> [replicator\_service\_principal\_password](#output\_replicator\_service\_principal\_password) | Password for Replicator Service Principal. |
| <a name="output_uami_blueprint_user_principal"></a> [uami\_blueprint\_user\_principal](#output\_uami\_blueprint\_user\_principal) | UAMI Blueprint Assignment Service Principal. |
| <a name="output_uami_blueprint_user_principal_password"></a> [uami\_blueprint\_user\_principal\_password](#output\_uami\_blueprint\_user\_principal\_password) | Password for UAMI Blueprint Assignment Service Principal. |
<!-- END_TF_DOCS -->
