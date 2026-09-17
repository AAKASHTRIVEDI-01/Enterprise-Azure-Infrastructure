output "vnet_id" {
  description = "The ID of the Hub Virtual Network."
  value       = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  description = "The Name of the Hub Virtual Network."
  value       = azurerm_virtual_network.hub.name
}

output "firewall_subnet_id" {
  description = "The ID of the AzureFirewallSubnet."
  value       = azurerm_subnet.firewall.id
}

output "bastion_subnet_id" {
  description = "The ID of the AzureBastionSubnet."
  value       = azurerm_subnet.bastion.id
}

output "gateway_subnet_id" {
  description = "The ID of the GatewaySubnet."
  value       = azurerm_subnet.gateway.id
}

output "management_subnet_id" {
  description = "The ID of the Management Subnet."
  value       = azurerm_subnet.management.id
}
