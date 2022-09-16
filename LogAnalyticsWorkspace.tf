resource "azurerm_log_analytics_workspace" "LogAnalyticsWrkspce" {
  name                = var.Log_Analytics_Workspace_name
  location            = var.HubManagement_location
  resource_group_name = var.HubManagement_resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
