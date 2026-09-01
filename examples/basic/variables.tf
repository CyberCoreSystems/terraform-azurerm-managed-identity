variable "location" {
  description = "Azure region for the example resources."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the resource group created by this example."
  type        = string
  default     = "rg-managed-identity-example"
}

variable "github_repository" {
  description = "GitHub org/repo allowed to federate into the deployer identity (used to build the OIDC subject)."
  type        = string
  default     = "octo-org/octo-repo"
}
