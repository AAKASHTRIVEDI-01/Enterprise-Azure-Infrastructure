variable "resource_group_name" {
  description = "The name of the resource group in which to create the Spoke VNet."
  type        = string
}

variable "location" {
  description = "The Azure region for the Spoke VNet."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Spoke Virtual Network."
  type        = string
}

variable "address_space" {
  description = "The CIDR address space for the Spoke VNet."
  type        = list(string)
}

variable "web_subnet_prefix" {
  description = "CIDR prefix for the Web tier subnet."
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR prefix for the Application tier subnet."
  type        = string
}

variable "db_subnet_prefix" {
  description = "CIDR prefix for the Database tier subnet."
  type        = string
}

variable "tags" {
  description = "Tags to apply to spoke network resources."
  type        = map(string)
  default     = {}
}
