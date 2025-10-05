locals {
    vnet_name = var.vnet_name != null ? var.vnet_name : "${local.env}-vnet"
}

# resource "azurerm_virtual_network" "this" {
#   name = local.vnet_name
#   location = local.region
#   resource_group_name = local.rg_name
#   address_space = var.address_space
#  subnet{
#     name = var.subnet_name
#     address_prefixes = var.prefix
#  }
# }
