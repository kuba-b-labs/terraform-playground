variable "region" {
  description = "Region for RG and all of resources"
  default     = null
  type        = string
}
variable "create_rg" {
  description = "create dev rg group"
  default     = false
  type        = bool
}
variable "rg_name" {
  description = "RG name to use if exists"
  default     = "rg1"
  type        = string
}
variable "env" {
  description = "environemnt stage: dev,prod,staging"
  type        = string
  default = "dev"
}
variable "kind" {
  description = "Os type of a container group"
  default     = "Linux"
  type        = string
  validation {
    condition = contains(["Linux","Windows"],var.kind)
    error_message = "Os type can only be either Linux or Windows"
  }
}
variable "container_group_name" {
  description = "Name of a container group"
  type        = string
}
variable "public_type" {
  description = "Should container group have public ip"
  type        = bool
  default     = false
}
variable "container_name" {
  description = "Main container's name"
  type        = string
  default     = "main-container"
}
variable "cpu" {
  description = "Main container's CPU value"
  type        = number
  default     = null
}
variable "memory" {
  description = "Main container's memory value"
  type        = number
  default     = null
}
variable "image" {
  description = "Image for main container to use"
  type        = string
}
variable "port" {
  description = "port of the main container"
  type        = number
  default     = null
}
variable "sidecar" {
  description = "create sidecar container"
  type        = bool
  default     = false
}
variable "dns_label" {
  description = "container's dns label"
  type        = string
  default     = ""
}
variable "env_variables" {
  description = "map of environmental variables for the main container in a key=value pair"
  type        = map(string)
  default     = {}
}
variable "volume" {
  description = "main container's volume to be mounted"
  type = list(object({
    name                 = string
    mount_path           = string
    read_only            = optional(bool)
    empty_dir            = optional(bool)
    storage_account_name = optional(string)
    share_name           = optional(string)
    secret               = optional(map(string))
  }))
  default = []
}
variable "tags_rg" {
  description = "tags to add to a resource"
  type        = map(string)
  default     = {}
}
variable "tags_container_group" {
  description = "tags to add to a container group"
  type        = map(string)
  default     = {}
}