output "firewall_id" {
  description = "The ID of the Azure Firewall."
  value       = azurerm_firewall.fw.id
}

output "private_ip" {
  description = "The Private IP address of the Azure Firewall inside the Hub VNet."
  value       = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

output "public_ip" {
  description = "The Public IP address of the Azure Firewall."
  value       = azurerm_public_ip.fw_pip.ip_address
}

output "policy_id" {
  description = "The ID of the Azure Firewall Policy."
  value       = azurerm_firewall_policy.fw_policy.id
}
