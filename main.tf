# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "commit-storage-rg"
    storage_account_name = "sakfirterraformstatefile"
    container_name       = "tfstate"
    key                  = "aks-prod.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
    prevent_deletion_if_contains_resources = false
  } #We can keep it empty if we dont need it, but we must declare it

}
}