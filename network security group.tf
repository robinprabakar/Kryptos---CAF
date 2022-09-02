provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "v-netRG" {
  name     = "Shared-HUB-RG"
  location = "South India"
}

resource "azurerm_network_security_group" "NtwrkSG" {
  name                = "MyTagNSG"
  location            = azurerm_resource_group.v-netRG.location
  resource_group_name = azurerm_resource_group.v-netRG.name

  security_rule {
    name                       = "NSGRule1"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9389"
    source_address_prefix      = "10.0.0.1"
    destination_address_prefix = "172.16.36.0"
  }

  security_rule {
    name                       = "NSGRule2"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "123"
    source_address_prefix      = "10.0.0.1"
    destination_address_prefix = "172.16.36.0"
  }

  security_rule {
    name                       = "NSGRule3"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "0-65535"
    source_address_prefix      = "10.0.0.1"
    destination_address_prefix = "172.16.36.0"
  }

  tags = {
    environment = "NSGEnvironmentTag"
  }
}
