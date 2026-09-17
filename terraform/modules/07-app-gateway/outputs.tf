output "id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.appgw.id
}

output "name" {
  description = "The Name of the Application Gateway."
  value       = azurerm_application_gateway.appgw.name
}

output "public_ip" {
  description = "The Public IP of the Application Gateway."
  value       = azurerm_public_ip.appgw_pip.ip_address
}
