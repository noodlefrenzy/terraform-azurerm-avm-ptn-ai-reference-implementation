<!-- BEGIN_TF_DOCS -->
# Default example

Deploys the environment with a jumpbox to enable access to environment. The username is `azureuser` and the password is generated and can be found in the tfstate file or it can be reset from the portal.

An easy way to get a list of available VM sizes in a specific region and availability zone:

```sh
# The following is a simple command will list Standard_D VM sizes and have no restrictions in southcentralus region
az vm list-skus -l southcentralus --size Standard_D -o table | grep None
```

```hcl
terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.114.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

}

resource "random_string" "name" {
  length  = 5
  numeric = false
  special = false
  upper   = false
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = var.location
  name     = module.naming.resource_group.name_unique
}

data "azurerm_client_config" "current" {}

module "test" {
  source              = "../../"
  location            = azurerm_resource_group.this.location
  name                = random_string.name.id
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = var.enable_telemetry
  jumpbox = {
    create                         = true
    size                           = var.jumpbox.size
    zone                           = var.jumpbox.zone
    accelerated_networking_enabled = var.jumpbox.accelerated_networking_enabled
  }
  tags = {
    environment = "test"
    cicd        = "terraform"
  }
  # The current user will be added as an admin user to the AKV
  akv_secret_admin_users = [data.azurerm_client_config.current.object_id]
  depends_on             = [azurerm_resource_group.this]
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.114.0, < 4.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [random_string.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_jumpbox"></a> [jumpbox](#input\_jumpbox)

Description: This variable configures the jumpbox for this example

Type:

```hcl
object({
    size                           = string,
    zone                           = number,
    accelerated_networking_enabled = bool
  })
```

Default:

```json
{
  "accelerated_networking_enabled": true,
  "size": "Standard_D4as_v4",
  "zone": 3
}
```

### <a name="input_location"></a> [location](#input\_location)

Description: The location for the resources.

Type: `string`

Default: `"uksouth"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: ~> 0.3

### <a name="module_test"></a> [test](#module\_test)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->