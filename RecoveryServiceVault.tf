resource "azurerm_recovery_services_vault" "RcvryVlt" {
  name                = var.recovery_services_vault_name
  location            = var.HubIdentity_location
  resource_group_name = var.HubIdentity_resource_group_name
  sku                 = "Standard"

  soft_delete_enabled = true
}
