output "hub_to_spoke_peering_id" {
  description = "The ID of the Hub-to-Spoke peering."
  value       = azurerm_virtual_network_peering.hub_to_spoke.id
}

output "spoke_to_hub_peering_id" {
  description = "The ID of the Spoke-to-Hub peering."
  value       = azurerm_virtual_network_peering.spoke_to_hub.id
}
