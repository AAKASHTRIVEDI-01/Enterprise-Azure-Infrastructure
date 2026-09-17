# Public IP for Azure Firewall (Standard SKU, Static allocation is required)
resource "azurerm_public_ip" "fw_pip" {
  name                = "pip-${var.firewall_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Modern Azure Firewall Policy
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "fwp-${var.firewall_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  tags                = var.tags

  dns {
    proxy_enabled = true
  }
}

# Rule Collection Group: Centralized Egress & Inspection Rules
resource "azurerm_firewall_policy_rule_collection_group" "rules" {
  name               = "fw-rules-enterprise"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 500

  network_rule_collection {
    name     = "CoreInfrastructureRules"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "Allow-DNS"
      protocols             = ["UDP", "TCP"]
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "Allow-NTP"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }

    rule {
      name                  = "Allow-Internal-Spoke-To-Spoke"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["10.1.0.0/16"]
      destination_ports     = ["80", "443", "8080", "1433", "5432"]
    }
  }

  application_rule_collection {
    name     = "SecureOutboundWebRules"
    priority = 200
    action   = "Allow"

    rule {
      name             = "Allow-OS-Updates-And-Package-Managers"
      source_addresses = ["10.1.0.0/16"]
      destination_fqdns = [
        "*.microsoft.com",
        "*.azure.com",
        "*.ubuntu.com",
        "*.github.com",
        "*.docker.com"
      ]

      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
    }
  }
}

# Azure Firewall Instance
resource "azurerm_firewall" "fw" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }

  depends_on = [azurerm_firewall_policy_rule_collection_group.rules]
}
