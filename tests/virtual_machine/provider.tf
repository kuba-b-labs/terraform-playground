terraform {
  backend "azurerm" {
    resource_group_name  = "homelab-k8s"
    storage_account_name = "terraformplaygroundjb104"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true 
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true 
}
