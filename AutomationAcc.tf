resource "azurerm_automation_account" "AutomationAcc" {
  name                = var.automation_account_name
  location            = var.HubManagement_location
  resource_group_name = var.HubManagement_resource_group_name
  sku_name            = "Basic"
  
  tags = {
    environment = "HubEnvironment"
  }
}
