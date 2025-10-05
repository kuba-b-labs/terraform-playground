output "container_ip" {
    description = "main container's address"
    value = azurerm_container_group.this[0].ip_address
}