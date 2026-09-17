# ==========================================================
# 1. USER DEFINED ROUTE TABLE (UDR) - HUB FIREWALL NEXT HOP
# ==========================================================
resource "azurerm_route_table" "spoke_udr" {
  name                          = "rt-spoke-egress-firewall"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = false
  tags                          = var.tags

  route {
    name                   = "DefaultEgressToAzureFirewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

# Associate Route Table with App and DB subnets (forces all egress through Azure Firewall)
resource "azurerm_subnet_route_table_association" "app_udr" {
  subnet_id      = var.app_subnet_id
  route_table_id = azurerm_route_table.spoke_udr.id
}

resource "azurerm_subnet_route_table_association" "db_udr" {
  subnet_id      = var.db_subnet_id
  route_table_id = azurerm_route_table.spoke_udr.id
}

# ==========================================================
# 2. NETWORK SECURITY GROUP: WEB TIER
# ==========================================================
resource "azurerm_network_security_group" "nsg_web" {
  name                = "nsg-spoke-web"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-HTTP-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = var.web_subnet_prefix
  }

  security_rule {
    name                       = "Allow-AppGateway-HealthProbes"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "web_nsg" {
  subnet_id                 = var.web_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg_web.id
}

# ==========================================================
# 3. NETWORK SECURITY GROUP: APPLICATION TIER
# ==========================================================
resource "azurerm_network_security_group" "nsg_app" {
  name                = "nsg-spoke-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-Traffic-From-WebTier-Only"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443", "8080"]
    source_address_prefix      = var.web_subnet_prefix
    destination_address_prefix = var.app_subnet_prefix
  }

  security_rule {
    name                       = "Deny-Direct-Internet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_nsg" {
  subnet_id                 = var.app_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg_app.id
}

# ==========================================================
# 4. NETWORK SECURITY GROUP: DATABASE TIER (ZERO TRUST)
# ==========================================================
resource "azurerm_network_security_group" "nsg_db" {
  name                = "nsg-spoke-data"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-Database-From-AppTier-Only"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["1433", "5432", "3306"]
    source_address_prefix      = var.app_subnet_prefix
    destination_address_prefix = var.db_subnet_prefix
  }

  security_rule {
    name                       = "Deny-All-Other-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "db_nsg" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
}
