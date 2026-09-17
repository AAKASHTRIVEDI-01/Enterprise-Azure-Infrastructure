output "route_table_id" {
  description = "The ID of the User Defined Route Table."
  value       = azurerm_route_table.spoke_udr.id
}

output "nsg_web_id" {
  description = "The ID of the Web Tier NSG."
  value       = azurerm_network_security_group.nsg_web.id
}

output "nsg_app_id" {
  description = "The ID of the App Tier NSG."
  value       = azurerm_network_security_group.nsg_app.id
}

output "nsg_db_id" {
  description = "The ID of the Database Tier NSG."
  value       = azurerm_network_security_group.nsg_db.id
}
