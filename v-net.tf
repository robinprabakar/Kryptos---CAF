resource "azurerm_virtual_network" "example" { 
  name                = var.Hub_virtual_network
  address_space       = ["10.0.0.0/16"]
  location            = var.Hub_location
  resource_group_name = var.Hub_resource_group_name
}

resource "azurerm_virtual_network" "SpkV-Net" { 
  name                = var.Spoke_virtual_network
  address_space       = ["10.1.0.0/16"]
  location            = var.Spoke_location
  resource_group_name = var.Spoke_resource_group_name
}
