variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region for the Firewall."
  type        = string
}

variable "firewall_name" {
  description = "The name of the Azure Firewall."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the AzureFirewallSubnet in the Hub VNet."
  type        = string
}

variable "tags" {
  description = "Tags to apply to firewall resources."
  type        = map(string)
  default     = {}
}
