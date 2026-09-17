variable "prefix" {
  description = "A naming prefix used for all resources to maintain consistent naming conventions."
  type        = string
  default     = "ent"
}

variable "environment" {
  description = "Deployment environment name (e.g., prod, dev, staging)."
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region where all infrastructure resources will be deployed."
  type        = string
  default     = "eastus"
}

variable "hub_vnet_address_space" {
  description = "The CIDR address space for the Hub Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "firewall_subnet_prefix" {
  description = "Subnet CIDR for Azure Firewall (Must be named AzureFirewallSubnet and >= /26)."
  type        = string
  default     = "10.0.1.0/26"
}

variable "bastion_subnet_prefix" {
  description = "Subnet CIDR for Azure Bastion (Must be named AzureBastionSubnet and >= /26)."
  type        = string
  default     = "10.0.2.0/26"
}

variable "gateway_subnet_prefix" {
  description = "Subnet CIDR for VPN/ExpressRoute Gateway (Must be named GatewaySubnet and >= /27)."
  type        = string
  default     = "10.0.3.0/27"
}

variable "management_subnet_prefix" {
  description = "Subnet CIDR for Hub Shared Management / Jumpbox services."
  type        = string
  default     = "10.0.4.0/24"
}

variable "spoke_vnet_address_space" {
  description = "The CIDR address space for the Workload Spoke Virtual Network."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "web_subnet_prefix" {
  description = "Subnet CIDR for the Web / Ingress tier in the Spoke VNet."
  type        = string
  default     = "10.1.1.0/24"
}

variable "app_subnet_prefix" {
  description = "Subnet CIDR for the Application / Backend tier in the Spoke VNet."
  type        = string
  default     = "10.1.2.0/24"
}

variable "db_subnet_prefix" {
  description = "Subnet CIDR for the Database / Data tier in the Spoke VNet."
  type        = string
  default     = "10.1.3.0/24"
}

variable "tags" {
  description = "A map of resource tags applied across all deployed Azure resources for cost allocation and governance."
  type        = map(string)
  default = {
    Project     = "Enterprise-Azure-Infrastructure"
    Environment = "Production"
    ManagedBy   = "Terraform"
    Owner       = "Aakash Trivedi"
  }
}
