output "vnet_id" {
  description = "The ID of the Spoke Virtual Network."
  value       = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  description = "The Name of the Spoke Virtual Network."
  value       = azurerm_virtual_network.spoke.name
}

output "web_subnet_id" {
  description = "The ID of the Web tier subnet."
  value       = azurerm_subnet.web.id
}

output "app_subnet_id" {
  description = "The ID of the App tier subnet."
  value       = azurerm_subnet.app.id
}

output "db_subnet_id" {
  description = "The ID of the Database tier subnet."
  value       = azurerm_subnet.db.id
}
