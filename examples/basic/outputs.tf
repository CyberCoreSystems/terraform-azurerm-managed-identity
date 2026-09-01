output "resource_group_name" {
  description = "The resource group holding the example identities."
  value       = azurerm_resource_group.example.name
}

output "identity_ids" {
  description = "Map of identity key => managed identity resource ID."
  value       = module.managed_identity.ids
}

output "identity_client_ids" {
  description = "Map of identity key => client ID."
  value       = module.managed_identity.client_ids
}

output "identity_principal_ids" {
  description = "Map of identity key => principal (object) ID."
  value       = module.managed_identity.principal_ids
}
