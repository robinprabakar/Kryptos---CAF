resource "azurerm_resource_group" "v-netRG" {
  name     = var.Hub_resource_group_name
  location = var.Hub_location
}

resource "azurerm_resource_group" "bastionRG" {
  name     = var.Hub_Bas_resource_group_name
  location = var.Hub_Bas_location
}

resource "azurerm_resource_group" "AppGatewayRG" {
  name     = var.Appgw_resource_group_name
  location = var.Appgw_location
}

resource "azurerm_resource_group" "GatewayRG" {
  name     = var.Gateway_resource_group_name
  location = var.Gateway_location
}

resource "azurerm_resource_group" "HubManagementRG" {
  name     = var.HubManagement_resource_group_name
  location = var.HubManagement_location
}

resource "azurerm_resource_group" "HubIDMRG" {
  name     = var.HubIdentity_resource_group_name
  location = var.HubIdentity_location
}

resource "azurerm_resource_group" "SpokeV-NetRG" {
  name     = var.Spoke_resource_group_name
  location = var.Spoke_location
}

resource "azurerm_resource_group" "SpokeApplicationRG" {
  name     = var.Spoke_app_resource_group_name
  location = var.Spoke_app_location
}

resource "azurerm_resource_group" "SpokeDatabaseRG" {
  name     = var.Spoke_Db_resource_group_name
  location = var.Spoke_Db_location
}

resource "azurerm_resource_group" "SharedSvcsRG" {
  name     = var.Spoke_SharedSvcs_resource_group_name
  location = var.Spoke_SharedSvcs_location
}
