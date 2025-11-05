# terraform-azure

A small Terraform workspace for provisioning Azure resources and demonstrating remote state using an Azure Storage Account.

## Repository layout

- `main.tf` — primary Terraform configuration (root module).
- `backend.tf` — (optional) Terraform backend configuration for remote state.
- `variables.tf` — input variables used by the root module.
- `bootstrap/` — helper/bootstrap module (contains its own `main.tf`, `output.tf`, and local state files).
- `terraform.tfstate.backup`, `tfc.tfstate` — automatically created state backup files (should be ignored by git).

## Purpose

This repo contains example Terraform code to manage Azure resources (resource group, storage account, container, etc.) and demonstrates best practices for remote state and basic workflows.

## Prerequisites

- Terraform (recommended: pin a version in your workflow; e.g., 1.X.Y)
- Azure CLI (for authentication) or a Service Principal for CI
- An Azure subscription where you have permission to create resources

## Quick start (local, using Azure CLI auth)

1. Login to Azure:

```bash
az login
# If you need to set a subscription
az account set --subscription "<subscription-id-or-name>"
```

2. (Optional) Create an Azure Storage account + container for remote state, or use the `bootstrap/` folder if it contains bootstrap resources.

3. Initialize Terraform in the root folder:

```bash
cd /Users/suryasai/terraform-azure
terraform init
```

If the backend is configured to use Azure Blob storage, `terraform init` will attempt to configure and connect to the remote backend.

4. Validate and format:

```bash
terraform fmt -check
terraform validate
```

5. Plan and apply:

```bash
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

6. Destroy (when you want to tear down):

```bash
terraform destroy
```

## Backend (remote state) example for Azure

If you want to use remote state in Azure Storage, a typical `backend "azurerm"` block (in `backend.tf` or passed during init) looks like this:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<rg-for-backend>"
    storage_account_name = "<storageaccountname>" # must be lowercase, 3-24 chars, numbers and letters only
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

Notes:
- Storage account names must be lowercase and cannot contain underscores or hyphens.
- You can create the storage account and container manually or via the `bootstrap/` module.
- Don’t commit secrets or local `*.tfstate` files; `.gitignore` is present to help with that.

## Recommendations & best practices

- Pin Terraform and provider versions using `required_version` and `required_providers` in `terraform {}`.
- Use a remote backend for team collaboration and enable blob versioning / soft delete for state containers in production.
- Use service principals or managed identities for CI pipelines and give least privilege needed for the backend.
- Add automated checks to CI: `terraform fmt -check`, `terraform validate`, `tflint`, `tfsec`/`checkov`.
- Keep secrets out of the repo — use a secret manager (Azure Key Vault) or CI secrets.

## Useful commands

- `terraform init` — initialize working directory
- `terraform fmt` — format files
- `terraform validate` — validate config
- `terraform plan -out=plan.tfplan` — create plan file
- `terraform apply "plan.tfplan"` — apply existing plan file
- `terraform destroy` — destroy resources created by this config
- `terraform state list` — list resources in state

## CI suggestion (GitHub Actions example)

Add a workflow that runs on pull requests which performs `terraform fmt -check`, `terraform init -backend=false`, `terraform validate`, `tflint`, and `terraform plan` with `-out` and uploads the plan as an artifact.

## Notes about this repo

- A `.gitignore` exists and ignores `.terraform`, `*.tfstate`, `*.tfvars`, and IDE files.
- If you add other files containing secrets or credentials, add them to `.gitignore` immediately.

## Where to go next

Follow the project TODO list in the repository (Learning plan) to:
- learn CLI & state management
- refactor code into modules
- add CI and static checks
- implement Azure-specific best practices (Key Vault, RBAC)

If you want, I can:
- Add a GitHub Actions workflow scaffold,
- Create a sample `backend.tf` and `bootstrap` script to create the storage account/container,
- Or draft a `modules/` layout for a reusable VNet module.

---

Created by your Terraform study workflow — tell me which of the next actions above you want me to do and I'll implement it.