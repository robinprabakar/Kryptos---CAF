resource "azurerm_public_ip" "VpnPubip" {
    name                = var.Vpn_pubIp_name
    location            = var.Hub_location
    resource_group_name = var.Hub_resource_group_name
  
    allocation_method = "Dynamic"
  }

resource "azurerm_virtual_network_gateway" "VrtlNtwkGW" {
    name                = var.Virtual_Network_Gw_name
    location            = var.Hub_location
    resource_group_name = var.Hub_resource_group_name
  
    type     = "Vpn"
    vpn_type = "RouteBased"
  
    active_active = false
    enable_bgp    = false
    sku           = "VpnGw2"
  
    ip_configuration {
      name                          = "VnetGatewayConfig"
      public_ip_address_id          = azurerm_public_ip.VpnPubip.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.Gateway.id
    }
  }
