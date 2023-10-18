resource "azurerm_application_insights" "insights" {
  name                = var.app_insights_name
  location            = var.region
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags = {
    environment = var.environment
  }
}

output "app_insights_name" { 
  value = azurerm_application_insights.insights.name
}
output "instrumentation_key" {
  value = azurerm_application_insights.insights.instrumentation_key
  sensitive   = true
}
output "app_id" {
  value = azurerm_application_insights.insights.app_id
}


resource "azurerm_monitor_action_group" "performance_alert" {
  name = "PerformanceAlert"
  resource_group_name = var.resource_group_name
  short_name = "perfAlert"
}

output "monitor_action_group_performance_alert_id" {
  value = azurerm_monitor_action_group.performance_alert.id
}
