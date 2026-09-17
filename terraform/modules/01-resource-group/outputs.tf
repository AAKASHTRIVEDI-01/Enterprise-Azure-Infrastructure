output "id" {
  description = "The ID of the Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "name" {
  description = "The Name of the Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "The Location of the Resource Group."
  value       = azurerm_resource_group.rg.location
}
