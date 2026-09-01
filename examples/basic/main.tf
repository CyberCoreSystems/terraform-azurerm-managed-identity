provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "managed_identity" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  identities = {
    # A runtime identity with a least-privilege RBAC grant on the resource group.
    "id-app-runtime" = {
      role_assignments = {
        "reader-on-rg" = {
          scope                = azurerm_resource_group.example.id
          role_definition_name = "Reader"
        }
      }
    }

    # A deployer identity that GitHub Actions can assume via OIDC — no secret.
    "id-github-deployer" = {
      federated_credentials = {
        "github-main" = {
          issuer  = "https://token.actions.githubusercontent.com"
          subject = "repo:${var.github_repository}:ref:refs/heads/main"
          # audience defaults to ["api://AzureADTokenExchange"]
        }
      }
    }
  }

  tags = {
    environment = "example"
    managed_by  = "iac-bazaar"
  }
}
