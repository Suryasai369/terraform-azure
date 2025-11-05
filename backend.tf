terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform-State"
    storage_account_name = "terraformstate202511"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}