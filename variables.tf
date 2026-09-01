variable "resource_group_name" {
  description = "Name of an existing resource group that will hold the user-assigned managed identities."
  type        = string
}

variable "location" {
  description = "Azure region for the managed identities."
  type        = string
}

variable "identities" {
  description = <<-EOT
    User-assigned managed identities to create, keyed by the identity name
    (3-128 chars: must start with a letter or digit, then letters, digits,
    hyphens or underscores). Each identity may optionally declare:
      - federated_credentials: workload-identity-federation trust (OIDC) keyed by
        credential name. Lets an external workload (GitHub Actions, a Kubernetes
        service account, another cloud) obtain Entra tokens for this identity with
        NO stored client secret. audience defaults to the standard Entra exchange
        audience.
      - role_assignments: Azure RBAC grants for the identity's principal, keyed by
        a logical name. Set exactly one of role_definition_name OR
        role_definition_id, plus the scope to grant at (least-privilege: pick the
        narrowest scope that works).
      - tags: per-identity tags, merged over the module-wide tags.
  EOT
  type = map(object({
    federated_credentials = optional(map(object({
      issuer   = string
      subject  = string
      audience = optional(list(string), ["api://AzureADTokenExchange"])
    })), {})
    role_assignments = optional(map(object({
      scope                = string
      role_definition_name = optional(string)
      role_definition_id   = optional(string)
    })), {})
    tags = optional(map(string), {})
  }))

  validation {
    condition     = length(var.identities) > 0
    error_message = "Provide at least one identity in the identities map."
  }

  validation {
    condition     = alltrue([for name in keys(var.identities) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,127}$", name))])
    error_message = "identity names must be 3-128 chars: start with a letter or digit, then letters, digits, hyphens or underscores."
  }

  validation {
    condition = alltrue([
      for id in values(var.identities) : alltrue([
        for ra in values(id.role_assignments) :
        (ra.role_definition_name != null) != (ra.role_definition_id != null)
      ])
    ])
    error_message = "each role_assignment must set exactly one of role_definition_name or role_definition_id."
  }

  validation {
    condition = alltrue(flatten([
      for id in values(var.identities) : [
        for fc_name, fc in id.federated_credentials :
        can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,119}$", fc_name)) && length(fc.audience) > 0 && length(fc.issuer) > 0 && length(fc.subject) > 0
      ]
    ]))
    error_message = "each federated credential needs a 3-120 char name (start with a letter or digit; then letters, digits, hyphens or underscores), a non-empty issuer and subject, and at least one audience."
  }
}

variable "tags" {
  description = "Tags applied to every identity (per-identity tags override these on key conflicts)."
  type        = map(string)
  default     = {}
}
