# Map-driven user-assigned managed identities. Secure by default: a managed
# identity holds NO long-lived secret of its own, and this module's optional
# federated credentials let external workloads (GitHub Actions, Kubernetes, other
# clouds) authenticate via short-lived OIDC tokens instead of a stored client
# secret. Role assignments are least-privilege — you choose the scope and role.
# Consumes an EXISTING resource group (it does not create one).

locals {
  # Flatten identities x their federated credentials into one map keyed by
  # "<identity>/<credential>" so each credential gets a stable for_each key
  # without iterating over computed values.
  federated_credentials = merge([
    for id_key, id in var.identities : {
      for fc_key, fc in id.federated_credentials :
      "${id_key}/${fc_key}" => {
        identity_key = id_key
        name         = fc_key
        issuer       = fc.issuer
        subject      = fc.subject
        audience     = fc.audience
      }
    }
  ]...)

  # Flatten identities x their role assignments the same way.
  role_assignments = merge([
    for id_key, id in var.identities : {
      for ra_key, ra in id.role_assignments :
      "${id_key}/${ra_key}" => {
        identity_key         = id_key
        scope                = ra.scope
        role_definition_name = ra.role_definition_name
        role_definition_id   = ra.role_definition_id
      }
    }
  ]...)
}

resource "azurerm_user_assigned_identity" "this" {
  for_each = var.identities

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = merge(var.tags, each.value.tags)
}

# Workload identity federation: trust an external OIDC issuer to act as this
# identity, with no client secret to store or rotate.
resource "azurerm_federated_identity_credential" "this" {
  for_each = local.federated_credentials

  name                = each.value.name
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.this[each.value.identity_key].id
  audience            = each.value.audience
  issuer              = each.value.issuer
  subject             = each.value.subject
}

# RBAC grants for the identity's principal. principal_type is pinned to
# ServicePrincipal and the AAD existence check is skipped so an assignment created
# in the same apply as the identity does not race Entra replication.
resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments

  scope                            = each.value.scope
  role_definition_name             = each.value.role_definition_name
  role_definition_id               = each.value.role_definition_id
  principal_id                     = azurerm_user_assigned_identity.this[each.value.identity_key].principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}
