variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "key_vault_name" {
  description = "The globally unique name of the Key Vault (3-24 alphanumeric and hyphens)."
  type        = string
}

variable "tags" {
  description = "Tags to apply to Key Vault."
  type        = map(string)
  default     = {}
}
