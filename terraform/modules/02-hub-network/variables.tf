variable "resource_group_name" {
  description = "The name of the resource group in which to create the Hub VNet."
  type        = string
}

variable "location" {
  description = "The Azure region for the Hub VNet."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Hub Virtual Network."
  type        = string
}

variable "address_space" {
  description = "The CIDR address space for the Hub VNet."
  type        = list(string)
}

variable "firewall_subnet_prefix" {
  description = "CIDR prefix for the AzureFirewallSubnet (min /26)."
  type        = string
}

variable "bastion_subnet_prefix" {
  description = "CIDR prefix for the AzureBastionSubnet (min /26)."
  type        = string
}

variable "gateway_subnet_prefix" {
  description = "CIDR prefix for the GatewaySubnet (min /27)."
  type        = string
}

variable "management_subnet_prefix" {
  description = "CIDR prefix for the Management subnet."
  type        = string
}

variable "tags" {
  description = "Tags to apply to hub network resources."
  type        = map(string)
  default     = {}
}
