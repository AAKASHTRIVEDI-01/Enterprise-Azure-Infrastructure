variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
}

variable "tags" {
  description = "Tags to apply to Log Analytics resources."
  type        = map(string)
  default     = {}
}
