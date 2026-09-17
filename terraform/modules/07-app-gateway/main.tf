# Public IP for Application Gateway (Standard SKU, Static allocation)
resource "azurerm_public_ip" "appgw_pip" {
  name                = "pip-${var.app_gateway_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

locals {
  gateway_ip_config_name = "appgw-ip-configuration"
  frontend_port_name     = "appgw-frontend-port-http"
  frontend_ip_config_name = "appgw-frontend-ip-public"
  backend_pool_name      = "appgw-backend-pool-default"
  http_setting_name      = "appgw-http-settings-default"
  listener_name          = "appgw-listener-http"
  request_routing_rule   = "appgw-routing-rule-default"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_config_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = local.backend_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  # OWASP Core Rule Set Web Application Firewall (WAF)
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}
