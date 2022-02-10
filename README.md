# Azure meshPlatform Module

Terraform module to integrate Azure as a meshPlatform into meshStack instance.

With this module, service principals used by meshStack are created with the required permissions.

## Prerequisites

Permissions on AAD level are needed to run this module.
Tenant wide admin consent must be granted for a succesful meshPlatform setup. Therefore to integrate a meshPlatform you need: 

> An Azure account with one of the following roles: Global Administrator, Privileged Role Administrator, Cloud Application Administrator, or Application Administrator. A user can also be authorized to grant tenant-wide consent if they are assigned a custom directory role that includes the permission to grant permissions to applications.[^1]

[^1]: See [Azure public documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/grant-admin-consent#prerequisites)

## How to use this module

1. Login into [Azure Portal](https://portal.azure.com/) with your Admin user.

2. Open a cloud shell.

3. Create a directory and change into it 

    ```sh
    mkdir terraform-azure-meshplatform
    cd terraform-azure-meshplatform
    ```

4. Create a `main.tf` file that references this module:

    ```sh
    cat > ~/terraform-azure-meshplatform/main.tf << EOF
    module "meshplatform" {
      source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

      spp_name_suffix = "unique-name"
      mgmt_group_name = "management-group-name"
    }
    EOF
    ```

5. Run

    ```sh
    terraform init
    terraform apply
    ```

6. Access terraform output and pass it securely to meshcloud.

    ```sh
    # The JSON output contains sensitive values that must not be transmitted to meshcloud in plain text.
    terraform output -json
    ```

## Advanced Usage

The default case creates kraken, replicator and idplookup service principals.

```hcl
module "meshplatform" {
  source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

  spp_name_suffix = "unique-name"
  mgmt_group_name = "management-group-name"
}
```

If UAMI blueprint user principal is required, you also need to pass a list of subscriptions this user will be assigned to.

```hcl
module "meshplatform" {
  source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

  spp_name_suffix = "unique-name"
  mgmt_group_name = "management-group-name"

  subscriptions = [
    "abcdefgh-abcd-efgh-abcd-abcdefgh1234"
  , "abcdefgh-abcd-efgh-abcd-abcdefgh5678"
  , ...
  ]
}
```
