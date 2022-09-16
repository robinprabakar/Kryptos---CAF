resource "azurerm_network_security_group" "NtwrkSG" {
  name                = var.NtwrkSG_name
  location            = var.Hub_location
  resource_group_name = var.Hub_resource_group_name

  security_rule {
    name                       = var.rule1_name
    priority                   = var.rule1_priority
    direction                  = var.rule1_direction
    access                     = var.rule1_access
    protocol                   = var.rule1_protocol
    source_port_range          = var.rule1_source_port_range
    destination_port_range     = var.rule1_destination_port_range
    source_address_prefix      = var.rule1_source_address_prefix
    destination_address_prefix = var.rule1_destination_address_prefix
  }

  security_rule {
    name                       = var.rule2_name
    priority                   = var.rule2_priority
    direction                  = var.rule2_direction
    access                     = var.rule2_access
    protocol                   = var.rule2_protocol
    source_port_range          = var.rule2_source_port_range
    destination_port_range     = var.rule2_destination_port_range
    source_address_prefix      = var.rule2_source_address_prefix
    destination_address_prefix = var.rule2_destination_address_prefix
  }

  security_rule {
    name                       = var.rule3_name
    priority                   = var.rule3_priority
    direction                  = var.rule3_direction
    access                     = var.rule3_access
    protocol                   = var.rule3_protocol
    source_port_range          = var.rule3_source_port_range
    destination_port_range     = var.rule3_destination_port_range
    source_address_prefix      = var.rule3_source_address_prefix
    destination_address_prefix = var.rule3_destination_address_prefix
  }

  tags = {
    environment = var.NtwrkSG_tag
  }
}
