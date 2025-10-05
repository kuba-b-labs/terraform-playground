variable "vnet_name" {
  description = "Virtual Network's name"
  default = null
  type = string
}
variable "address_space" {
  description = "Virtual Network's ipv4 address space"
  default = ["10.0.0.0/16"]
  type = list(string)
}
variable "subnet_name" {
  description = "Subnet's Name"
  default = "Subnet"
  type = string
}
variable "prefix" {
  description = "Subnet prefix"
  default = ["10.0.0.0/24"]
  type = list(string)
}