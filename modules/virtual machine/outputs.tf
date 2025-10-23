output "resource_group_name" {
  value = azurerm_resource_group.this[0].name
}

output "resource_group_location" {
  value = azurerm_resource_group.this[0].location
}

output "resource_group_count" {
  value = length(azurerm_resource_group.this)
}

output "virtual_network_count" {
  value = length(azurerm_virtual_network.this) > 0 ? 1 : 0
}

output "subnet_count" {
  value = length(azurerm_subnet.this) > 0 ? 1 : 0
}

output "network_interface" {
  value = length(azurerm_network_interface.this) > 0 ? 1 : 0
}

output "security_group" {
  value = length(azurerm_network_security_group.this) > 0 ? 1 : 0
}

output "nsg_connected" {
  value = {
    subnet_id = azurerm_subnet_network_security_group_association.this.subnet_id != "" ? 1 : 0
    nsg_id = azurerm_subnet_network_security_group_association.this.network_security_group_id != "" ? 1 : 0
  }
}

output "linux_vm_created" {
  value = length(azurerm_linux_virtual_machine.this)
}

output "windows_vm_created" {
  value = length(azurerm_windows_virtual_machine.this)
}
