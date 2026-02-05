
variable "rg_name" {
  description = "RG name to use if exists"
  default     = "rg1"
  type        = string
}
variable "env" {
  description = "environemnt stage: dev,prod,staging"
  type        = string
  default     = "dev"
}
variable "region" {
  description = "Region for RG and all of resources"
  default     = null
  type        = string
}
variable "vnet_name" {
  description = "Virtual Network's name"
  default     = null
  type        = string
}
variable "address_space" {
  description = "Virtual Network's ipv4 address space"
  default     = ["10.0.0.0/16"]
  type        = list(string)
}
variable "subnet_name" {
  description = "Subnet's Name"
  default     = "Subnet"
  type        = string
}
variable "prefix" {
  description = "Subnet prefix"
  default     = ["10.0.0.0/24"]
  type        = list(string)
}
variable "tags_rg" {
  description = "tags to add to a resource"
  type        = map(string)
  default     = {}
}
variable "tags_vnet" {
  description = "tags to add to a virtual network"
  type        = map(string)
  default     = {}
}
variable "tags_vm" {
  description = "tags to add to a virtual machine"
  type        = map(string)
  default     = {}
}
variable "kind" {
  description = "kind of virtual machine - either linux or windows"
  type        = string
  default     = "Windows"

  validation {
    condition     = contains(["Linux", "Windows"], var.kind)
    error_message = "Kind must be \"Linux\" or \"Windows\"."
  }
}
variable "create_vnet" {
  description = "should a new virtual network be created?"
  type        = bool
  default     = true
}
variable "create_rg" {
  description = "create dev rg group"
  type        = bool
  default     = false
}
variable "vm_name" {
  description = "name of the virtual machine"
  type        = string
}
variable "vm_size" {
  description = "size of the vm"
  default     = "Standard_F2"
  type        = string
}
variable "os_caching" {
  description = "caching in os disk of a vm - possible values: None, ReadOnly, ReadWrite "
  type        = string
  default     = "ReadWrite"
  validation {
    condition     = contains(["None", "ReadWrite", "ReadOnly"], var.os_caching)
    error_message = "Os caching must be either None, ReadOnly or ReadWrite"
  }
}
variable "storage_account_type" {
  description = "Typ storage'u dla VM dysków"
  type        = string
  default     = "Standard_LRS"
  validation {
    condition = contains(
      ["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"],
      var.storage_account_type
    )
    error_message = "Dozwolone wartości to: Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS, Premium_ZRS."
  }
}
variable "subnet_id" {
  description = "already existing subnet's id for virtual machine to be connected to"
  type        = string
  default     = ""
}
variable "address_allocation" {
  description = "private ip address allocation for a virtual machine NIC"
  type        = string
  default     = "Dynamic"
  validation {
    condition     = contains(["Dynamic", "Static"], var.address_allocation)
    error_message = "Allowed values are Dynami or Static"
  }
}
variable "private_ip" {
  description = "Virtual machine's private static ip address inside of subnet"
  type        = string
  default     = ""
}
variable "admin_username" {
  description = "Virtual Machine's admin username for login"
  sensitive   = true
  type        = string
}
variable "admin_password" {
  description = "Virtual Machine's admin password for login"
  sensitive   = true
  type        = string
  default     = ""
}
variable "ssh_key" {
  description = "Public ssh key for connecting to linux Vm as admin"
  sensitive   = true
  type        = string
  default     = ""
}
variable "security_rules" {
  description = "Network Security Rules for the subnet of the virtual machine"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}