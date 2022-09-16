resource "azurerm_local_network_gateway" "KryptosLNG" {
  name                = var.Local_Ntwrk_Gw_name
  location            = var.Hub_location
  resource_group_name = var.Hub_resource_group_name
  gateway_address     = "14.141.19.38"
  address_space       = ["172.16.36.0/24"]
}
