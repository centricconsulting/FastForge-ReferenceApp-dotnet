################
# Data Imports #
################
data "azurerm_resource_group" "app" { #Insinuating that this already exists or is created elsewhere to be imported/called upon in this module 
  name = var.resource_group_name #Defined when calling the Module 
}

resource "azurerm_application_insights" "insights" {
  name                = var.app_insights_name
  location            = data.azurerm_resource_group.app.location
  resource_group_name = data.azurerm_resource_group.app.name
  application_type    = "web"

  depends_on = [data.azurerm_resource_group.app]
}

output "app_insights_name" { 
  value = azurerm_application_insights.insights.name
}
output "instrumentation_key" {
  value = azurerm_application_insights.insights.instrumentation_key
}
output "app_id" {
  value = azurerm_application_insights.insights.app_id
}


resource "azurerm_monitor_action_group" "performance_alert" {
  name = "PerformanceAlert"
  resource_group_name = data.azurerm_resource_group.app.name
  short_name = "perfAlert"

  depends_on = [data.azurerm_resource_group.app]
}

output "monitor_action_group_performance_alert_id" {
  value = azurerm_monitor_action_group.performance_alert.id
}
