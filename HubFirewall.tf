resource "azurerm_public_ip" "FirePubIp" {
  name                = var.Firewall_PubIp_name
  location            = var.Appgw_location
  resource_group_name = var.Appgw_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "MyHubFirewall" {
  name                = var.Hub_Firewall_name
  location            = var.Hub_location
  resource_group_name = var.Hub_resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  
  ip_configuration {
    name                 = "FirewallConfiguration"
    subnet_id            = azurerm_subnet.AzFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.FirePubIp.id
  }
}
