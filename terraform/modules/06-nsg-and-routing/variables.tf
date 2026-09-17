variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "firewall_private_ip" {
  description = "The Private IP of the Azure Firewall to use as next-hop for 0.0.0.0/0."
  type        = string
}

variable "web_subnet_id" {
  description = "The ID of the Spoke Web Subnet."
  type        = string
}

variable "app_subnet_id" {
  description = "The ID of the Spoke App Subnet."
  type        = string
}

variable "db_subnet_id" {
  description = "The ID of the Spoke DB Subnet."
  type        = string
}

variable "web_subnet_prefix" {
  description = "CIDR prefix of the Web Subnet."
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR prefix of the App Subnet."
  type        = string
}

variable "db_subnet_prefix" {
  description = "CIDR prefix of the DB Subnet."
  type        = string
}

variable "tags" {
  description = "Tags to apply to routing and security resources."
  type        = map(string)
  default     = {}
}
