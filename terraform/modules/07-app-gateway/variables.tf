variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "app_gateway_name" {
  description = "The name of the Application Gateway."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for Application Gateway (Web subnet)."
  type        = string
}

variable "tags" {
  description = "Tags to apply to Application Gateway resources."
  type        = map(string)
  default     = {}
}
