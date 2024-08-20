# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "resource" {
  description = "This is the full output for the resource."
  value = {
    resource_group     = data.azurerm_resource_group.base
    virtual_network    = module.virtual_network
    container_registry = module.avm_res_containerregistry_registry
    key_vault          = module.key_vault
    nat_gateway        = length(module.natgateway) == 0 ? null : module.natgateway[0].resource
  }
}

# Module owners should include the resource id via a 'resource_id' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "resource_id" {
  description = "The Azure resource id of the resource."
  value       = data.azurerm_resource_group.base.id
}
