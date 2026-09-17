variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "hub_vnet_name" {
  description = "The name of the Hub Virtual Network."
  type        = string
}

variable "hub_vnet_id" {
  description = "The ID of the Hub Virtual Network."
  type        = string
}

variable "spoke_vnet_name" {
  description = "The name of the Spoke Virtual Network."
  type        = string
}

variable "spoke_vnet_id" {
  description = "The ID of the Spoke Virtual Network."
  type        = string
}
