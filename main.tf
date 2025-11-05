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
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "eastus"
  tags = {
    Env  = "Testing"
    Team = "TF-team"
  }
}

resource "azurerm_resource_group" "rg1" {
  name     = "Testing-Remote-State"
  location = "eastus"
  tags = {
    Env  = "Testing"
    Team = "TF-team"
  }
}
