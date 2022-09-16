resource "azurerm_virtual_network_gateway_connection" "KryptosConnections" {
  name                = var.Kryptos_connections_name
  location            = var.Hub_location
  resource_group_name = var.Hub_resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.VrtlNtwkGW.id
  local_network_gateway_id   = azurerm_local_network_gateway.KryptosLNG.id

  shared_key = "K6Ypt0$v6u0n$19)@"
}
