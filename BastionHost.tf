resource "azurerm_public_ip" "bastpubip" {
  name                = var.Bastion_PubIp_name
  location            = var.Hub_Bas_location
  resource_group_name = var.Hub_Bas_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "BastionHost" {
  name                = var.Bastion_Host_name
  location            = var.Hub_Bas_location
  resource_group_name = var.Hub_Bas_resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.BasSub.id
    public_ip_address_id = azurerm_public_ip.bastpubip.id
  }
}
