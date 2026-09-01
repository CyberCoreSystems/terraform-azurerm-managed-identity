output "ids" {
  description = "Map of identity key => user-assigned managed identity resource ID (assign to a resource's identity_ids)."
  value       = { for k, id in azurerm_user_assigned_identity.this : k => id.id }
}

output "names" {
  description = "Map of identity key => managed identity name."
  value       = { for k, id in azurerm_user_assigned_identity.this : k => id.name }
}

output "principal_ids" {
  description = "Map of identity key => principal (object) ID — use for RBAC role assignments and Key Vault access policies."
  value       = { for k, id in azurerm_user_assigned_identity.this : k => id.principal_id }
}

output "client_ids" {
  description = "Map of identity key => client ID — use in app config and workload identity federation."
  value       = { for k, id in azurerm_user_assigned_identity.this : k => id.client_id }
}

output "tenant_ids" {
  description = "Map of identity key => tenant (Entra ID directory) ID."
  value       = { for k, id in azurerm_user_assigned_identity.this : k => id.tenant_id }
}

output "federated_credential_ids" {
  description = "Map of \"<identity>/<credential>\" => federated identity credential resource ID."
  value       = { for k, fc in azurerm_federated_identity_credential.this : k => fc.id }
}

output "role_assignment_ids" {
  description = "Map of \"<identity>/<assignment>\" => role assignment resource ID."
  value       = { for k, ra in azurerm_role_assignment.this : k => ra.id }
}
