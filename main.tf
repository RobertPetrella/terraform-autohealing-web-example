#Configure Azure provider for Terraform
terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
      }
    }

    required_version = "value"
}

provider "azurerm" {
    features {}
  
}

resource "azurerm_resource_group" "rg" {
    name = "azure-resource"
    location = "Australia East"
}

#setup Virtual Networks for Azure load balanced VMs
resource "azurevm_virtual_network" "vnet" {
  name = "azurevm-vnet"
  address_space = ["10.0.0.0/16"]
  location = var.location
}