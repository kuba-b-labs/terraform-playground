output "resource_group_name" {
  value = azurerm_resource_group.this[0].name
}

output "resource_group_location" {
  value = azurerm_resource_group.this[0].location
}

output "resource_group_count" {
  value = length(azurerm_resource_group.this)
}

output "container_group_count" {
  value = length(azurerm_container_group.this)
}

output "container_group_name" {
  value = azurerm_container_group.this[0].name
}

output "container_group_network_type" {
  value = azurerm_container_group.this[0].ip_address_type
}

output "container_group_ip" {
  value = azurerm_container_group.this[0].ip_address
}

output "container_group_containers" {
  value = azurerm_container_group.this[0].container
}
