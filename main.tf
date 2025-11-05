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

/* Resource Group creation */

resource "azurerm_resource_group" "rg" {
  name     = "WebApp-RG"
  location = "eastus"
  tags = {
    Env  = "Testing"
    Team = "TF-team"
  }
}

/* Networking part Creation (Vnet, Subnet, NSG and its delegation) */

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  name                = "WebApp-VNET"
}

resource "azurerm_subnet" "subnet" {
  name                 = "WebApp-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "WebApp-NSG"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgattach" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id = azurerm_subnet.subnet.id
}