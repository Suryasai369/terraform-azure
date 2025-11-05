# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  /*
  #This Block is for storing remote state in HCL cloud

  cloud {
    organization = "Surya_Org"
    workspaces {
      name = "Terraform-Azure"
    }
  }
  */
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

resource "azurerm_resource_group" "rg" {
  name     = "WebApp-RG"
  location = "eastus"
  tags = {
    Env  = "Testing"
    Team = "TF-team"
  }
}

