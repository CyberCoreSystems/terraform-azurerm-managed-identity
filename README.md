# User-Assigned Managed Identities

A map-driven module creating one or many user-assigned managed identities, each with optional workload identity federation (OIDC) and least-privilege RBAC role assignments - no secrets to rotate.

This module was **applied to a real Azure account, verified, and destroyed** on 2026-06-30 - not just `terraform validate`d.

Check it yourself, no account needed:

```
curl -s https://www.iac-bazaar.com/api/artifacts/azure-managed-identity/verification
```

The receipt names every check that ran, when it ran, and the SHA-256 of the
archive it describes. Full detail: [www.iac-bazaar.com/catalog/azure-managed-identity](https://www.iac-bazaar.com/catalog/azure-managed-identity)

## Usage

```hcl
module "managed_identity" {
  source  = "registry.terraform.io/CyberCoreSystems/managed-identity/azurerm"
  version = "~> 1.0"

  # See variables.tf for the full input contract.
}
```

## Why this module

Every module we publish goes through the same checks before release:

| check | what it means |
|---|---|
| `tofu validate` + `tflint` | it parses and lints clean |
| `checkov` | scanned for insecure defaults |
| **live test** | **really applied to a cloud account, outputs verified, then destroyed** |

That last row is the one most module catalogues skip. A module that has never
been applied has never been proven.

## Provider compatibility

```
azurerm >= 4.0, < 5.0
```

## More modules

This is one of **179 verified Terraform modules across 19 cloud platforms** -
AWS, Azure, GCP, Oracle OCI, Cloudflare, Akamai, DigitalOcean, Linode, Hetzner,
Vultr, Scaleway, Alibaba, IBM, UpCloud, Civo, Exoscale, OVH, Tencent and Huawei.

Browse the full catalogue at **[www.iac-bazaar.com](https://www.iac-bazaar.com)**, including
production landing zones for AWS, Azure and GCP that have each been live-tested
as a single composed apply.

- Module page: [https://www.iac-bazaar.com/catalog/azure-managed-identity](https://www.iac-bazaar.com/catalog/azure-managed-identity)
- How verification works: [https://www.iac-bazaar.com/verified](https://www.iac-bazaar.com/verified)

## Licence

See [LICENSE](./LICENSE).
