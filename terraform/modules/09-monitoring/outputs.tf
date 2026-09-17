output "workspace_id" {
  description = "The Workspace ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.law.workspace_id
}

output "id" {
  description = "The Resource ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.law.id
}

output "name" {
  description = "The Name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.law.name
}
