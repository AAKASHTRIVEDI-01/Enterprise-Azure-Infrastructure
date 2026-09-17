# ==============================================================================
# ENTERPRISE AZURE INFRASTRUCTURE - ROOT ORCHESTRATOR
# Architecture: Hub-and-Spoke Topology with Centralized Inspection & Defense-in-Depth
# Author: Aakash Trivedi (Azure Cloud Engineer & Consultant)
# ==============================================================================

resource "random_string" "unique_suffix" {
  length  = 5
  special = false
  upper   = false
}

# 1. Resource Group
module "resource_group" {
  source   = "./modules/01-resource-group"
  name     = "rg-${var.prefix}-${var.environment}"
  location = var.location
  tags     = var.tags
}

# 2. Hub Virtual Network (Perimeter & Shared Services)
module "hub_network" {
  source                   = "./modules/02-hub-network"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  vnet_name                = "vnet-${var.prefix}-hub"
  address_space            = var.hub_vnet_address_space
  firewall_subnet_prefix   = var.firewall_subnet_prefix
  bastion_subnet_prefix    = var.bastion_subnet_prefix
  gateway_subnet_prefix    = var.gateway_subnet_prefix
  management_subnet_prefix = var.management_subnet_prefix
  tags                     = var.tags
}

# 3. Spoke Virtual Network (Workloads: Web, App, Database)
module "spoke_network" {
  source              = "./modules/03-spoke-network"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = "vnet-${var.prefix}-spoke"
  address_space       = var.spoke_vnet_address_space
  web_subnet_prefix   = var.web_subnet_prefix
  app_subnet_prefix   = var.app_subnet_prefix
  db_subnet_prefix    = var.db_subnet_prefix
  tags                = var.tags
}

# 4. Bidirectional VNet Peering
module "vnet_peering" {
  source              = "./modules/04-vnet-peering"
  resource_group_name = module.resource_group.name
  hub_vnet_name       = module.hub_network.vnet_name
  hub_vnet_id         = module.hub_network.vnet_id
  spoke_vnet_name     = module.spoke_network.vnet_name
  spoke_vnet_id       = module.spoke_network.vnet_id
}

# 5. Azure Firewall (Central Egress & Ingress Inspection)
module "firewall" {
  source              = "./modules/05-firewall"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  firewall_name       = "afw-${var.prefix}-${var.environment}"
  subnet_id           = module.hub_network.firewall_subnet_id
  tags                = var.tags
}

# 6. Route Tables (UDR) & Network Security Groups (Defense in Depth)
module "nsg_and_routing" {
  source              = "./modules/06-nsg-and-routing"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  firewall_private_ip = module.firewall.private_ip
  web_subnet_id       = module.spoke_network.web_subnet_id
  app_subnet_id       = module.spoke_network.app_subnet_id
  db_subnet_id        = module.spoke_network.db_subnet_id
  web_subnet_prefix   = var.web_subnet_prefix
  app_subnet_prefix   = var.app_subnet_prefix
  db_subnet_prefix    = var.db_subnet_prefix
  tags                = var.tags
}

# 7. Application Gateway with WAF v2 (Layer 7 Ingress Protection)
module "app_gateway" {
  source              = "./modules/07-app-gateway"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  app_gateway_name    = "agw-${var.prefix}-${var.environment}"
  subnet_id           = module.spoke_network.web_subnet_id
  tags                = var.tags
}

# 8. Azure Key Vault (Secrets Management with RBAC)
module "keyvault" {
  source              = "./modules/08-keyvault"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  key_vault_name      = "kv-${substr(var.prefix, 0, 10)}-${random_string.unique_suffix.result}"
  tags                = var.tags
}

# 9. Log Analytics Workspace (Centralized Auditing & Observability)
module "monitoring" {
  source              = "./modules/09-monitoring"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  workspace_name      = "law-${var.prefix}-${var.environment}"
  tags                = var.tags
}
