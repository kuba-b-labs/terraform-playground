locals {
  env         = var.env
  vnet_name   = var.vnet_name != null ? var.vnet_name : "${local.env}-vnet"
  region      = var.region != null ? var.region : "polandcentral"
  create_rg   = var.create_rg == true ? 1 : 0
  create_vnet = var.create_vnet == true ? 1 : 0
  rg_name     = coalesce(var.rg_name, "${local.env}-rg")
  kind        = var.kind == "Linux"
}

resource "azurerm_resource_group" "this" {
  count    = local.create_rg
  name     = local.rg_name
  location = local.region
  tags     = var.tags_rg
}
resource "azurerm_virtual_network" "this" {
  count               = local.create_vnet
  name                = local.vnet_name
  location            = local.region
  resource_group_name = local.rg_name
  address_space       = var.address_space
  tags                = var.tags_vnet
  depends_on = [ azurerm_resource_group.this ]
}
resource "azurerm_subnet" "this" {
  count = local.create_vnet
  name                 = var.subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = var.prefix
  depends_on = [ azurerm_resource_group.this ]
}
resource "azurerm_public_ip" "this" {
  name                = "public-ip"
  allocation_method   = "Dynamic"
  location            = local.region
  resource_group_name = local.rg_name
  sku                 = "Basic"
  depends_on = [ azurerm_resource_group.this ]
}
resource "azurerm_network_interface" "this" {
  name                = "interface1"
  location            = local.region
  resource_group_name = local.rg_name
  ip_configuration {
    name                          = "basic_config"
    subnet_id                     = var.subnet_id != "" ? var.subnet_id : azurerm_subnet.this[0].id
    private_ip_address_allocation = var.address_allocation
    private_ip_address            = var.private_ip
    public_ip_address_id          = azurerm_public_ip.this.id
  }
  depends_on = [ azurerm_resource_group.this ]
}

resource "azurerm_network_security_group" "this" {
  name                = "basic-NSG"
  location            = local.region
  resource_group_name = local.rg_name
  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
  depends_on = [ azurerm_resource_group.this ]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  network_security_group_id = azurerm_network_security_group.this.id
  subnet_id = var.subnet_id != "" ? var.subnet_id : azurerm_subnet.this[0].id
  depends_on = [ azurerm_resource_group.this ]
}

resource "azurerm_linux_virtual_machine" "this" {
  count               = local.kind ? 1 : 0
  name                = var.vm_name
  resource_group_name = local.rg_name
  location            = local.region
  size                = var.vm_size
  network_interface_ids = [
    azurerm_network_interface.this.id
  ]
  os_disk {
    caching              = var.os_caching
    storage_account_type = var.storage_account_type
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  admin_username = var.admin_username
  dynamic "admin_ssh_key" {
    for_each = var.ssh_key != "" ? [var.ssh_key] : []
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }
  depends_on = [ azurerm_resource_group.this ]
}
resource "azurerm_windows_virtual_machine" "this" {
  count               = local.kind ? 0 : 1
  name                = var.vm_name
  resource_group_name = local.rg_name
  location            = local.region
  size                = var.vm_size
  network_interface_ids = [
    azurerm_network_interface.this.id
  ]
  admin_username = var.admin_username
  admin_password = var.admin_password
  os_disk {
    caching              = var.os_caching
    storage_account_type = var.storage_account_type
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter"
    version   = "latest"
  }
  depends_on = [ azurerm_resource_group.this ]
}