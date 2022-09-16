resource "azurerm_key_vault" "KitKeyVlt" {
  name                       = var.key_vault_name
  location                   = var.HubIdentity_location
  resource_group_name        = var.HubIdentity_resource_group_name
  tenant_id                  = data.azurerm_client_config.currentconfiguration.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
}

data "azurerm_client_config" "Spokecurrentconfiguration" {}

resource "azurerm_key_vault" "SpkKeyVlt" {
  name                       = var.Spoke_key_vault_name
  location                   = var.Spoke_SharedSvcs_location
  resource_group_name        = var.Spoke_SharedSvcs_resource_group_name
  tenant_id                  = data.azurerm_client_config.currentconfiguration.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
}
