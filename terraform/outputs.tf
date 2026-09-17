output "resource_group_name" {
  description = "The name of the main resource group."
  value       = module.resource_group.name
}

output "hub_vnet_id" {
  description = "The resource ID of the Hub Virtual Network."
  value       = module.hub_network.vnet_id
}

output "hub_vnet_name" {
  description = "The name of the Hub Virtual Network."
  value       = module.hub_network.vnet_name
}

output "spoke_vnet_id" {
  description = "The resource ID of the Spoke Virtual Network."
  value       = module.spoke_network.vnet_id
}

output "spoke_vnet_name" {
  description = "The name of the Spoke Virtual Network."
  value       = module.spoke_network.vnet_name
}

output "firewall_private_ip" {
  description = "The private IP address of Azure Firewall inside the Hub VNet (used as the next-hop IP in Route Tables)."
  value       = module.firewall.private_ip
}

output "firewall_public_ip" {
  description = "The public IP address assigned to the Azure Firewall."
  value       = module.firewall.public_ip
}

output "app_gateway_public_ip" {
  description = "The public IP address of the Application Gateway (WAF)."
  value       = module.app_gateway.public_ip
}

output "key_vault_uri" {
  description = "The URI of the Azure Key Vault for application secrets retrieval."
  value       = module.keyvault.vault_uri
}

output "log_analytics_workspace_id" {
  description = "The Workspace ID of the central Log Analytics Workspace."
  value       = module.monitoring.workspace_id
}
