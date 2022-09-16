resource "azurerm_virtual_network_peering" "hbtospk" {
  name                      = var.Hub_Spoke_Peering_name
  resource_group_name       = var.Hub_resource_group_name
  virtual_network_name      = var.Hub_virtual_network
  remote_virtual_network_id = var.Spoke_virtual_network
}

resource "azurerm_virtual_network_peering" "spktohb" {
  name                      = var.Spoke_Hub_Peering_name
  resource_group_name       = var.Spoke_resource_group_name
  virtual_network_name      = var.Spoke_virtual_network
  remote_virtual_network_id = var.Hub_virtual_network
}
