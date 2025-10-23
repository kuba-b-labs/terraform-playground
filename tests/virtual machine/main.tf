module "virtual_machine" {
  source         = "../../modules/virtual machine"
  create_rg      = true
  create_vnet    = true
  vm_name        = "test-vm"
  admin_username = "kuba"
  kind           = "Linux"
  ssh_key        = file("C:\\Users\\lwite\\.ssh\\id_ed25519.pub")
  security_rules = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
