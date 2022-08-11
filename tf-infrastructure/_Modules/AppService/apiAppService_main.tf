################
# Module Start #
################
# App Service Creation with SQLDB used #
resource "azurerm_app_service" "api1" {
  count               = var.sqldb == true ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.region
  name                = var.application_name #when calling this module, define the name of the app service in the main.tf, not directly in the module
  app_service_plan_id = var.app_service_plan_id #data.azurerm_app_service_plan.api.id

  site_config {
		always_on        = false
		linux_fx_version = "DOCKER|${var.shared_container_registry_login_server}/${var.application_name}.api:latest"
	}
	
	app_settings = {
    "MSDEPLOY_RENAME_LOCKED_FILES"            = "1"
		"WEBSITES_ENABLE_APP_SERVICE_STORAGE"     = "false"
		"DOCKER_REGISTRY_SERVER_URL"              = "https://${var.shared_container_registry_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"         = var.shared_container_registry_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"         = var.shared_container_registry_admin_password
		"DOCKER_CUSTOM_IMAGE_NAME"                = "${var.shared_container_registry_login_server}/referenceapp.api:latest"
		"ApplicationInsights__ApplicationVersion" = "${var.shared_container_registry_login_server}/referenceApp.api:latest"
		"APPINSIGHTS_INSTRUMENTATIONKEY"          = var.app_insights_key #azurerm_application_insights.insights.instrumentation_key
  }

  connection_string {
    name  = "${var.application_name}ConnectionString"
    type  = "SQLAzure"
    value = var.connection_string #"Server=tcp:${azurerm_sql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.dbserver.administrator_login};Password=${azurerm_sql_server.dbserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

	identity {
		type="SystemAssigned"
	}
  tags = {
    environment = var.environment
  }  
}

# App Service Creation with COSMOSDB used #
resource "azurerm_app_service" "api2" {
  count               = var.sqldb == true ? 0 : 1 
  resource_group_name = var.resource_group_name
  location            = var.region
  name                = var.application_name #when calling this module, define the name of the app service in the main.tf, not directly in the module
  app_service_plan_id = var.app_service_plan_id #data.azurerm_app_service_plan.api.id

  site_config {
		always_on        = false
		linux_fx_version = "DOCKER|${var.shared_container_registry_login_server}/referenceapp.api:latest"
	}
	
	app_settings = {
    "MSDEPLOY_RENAME_LOCKED_FILES"            = "1"
		"WEBSITES_ENABLE_APP_SERVICE_STORAGE"     = "false"
		"DOCKER_REGISTRY_SERVER_URL"              = "https://${var.shared_container_registry_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"         = var.shared_container_registry_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"         = var.shared_container_registry_admin_password
		"DOCKER_CUSTOM_IMAGE_NAME"                = "${var.shared_container_registry_login_server}/referenceapp.api:latest"
		"ApplicationInsights__ApplicationVersion" = "${var.shared_container_registry_login_server}/referenceApp.api:latest"
		"APPINSIGHTS_INSTRUMENTATIONKEY"          = var.app_insights_key #azurerm_application_insights.insights.instrumentation_key
		"Cosmos__Endpoint"                        = "https://${var.cosmosdb_name}.documents.azure.com:443/"
		"Cosmos__AccountKey"                      = var.cosmosdb_account_key
		"Cosmos__DatabaseName"                    = var.cosmosdb_name
  }

	identity {
		type="SystemAssigned"
	}
  tags = {
    environment = var.environment
  }  
}

# Monitor Metric Alert #
resource "azurerm_monitor_metric_alert" "api_failed_requests" {
  name                = "apiFailedRequests"
  resource_group_name = var.resource_group_name

  scopes      = var.sqldb == true ? [azurerm_app_service.api1[0].id] : [azurerm_app_service.api2[0].id]
  description = "Triggered when failed requests rise above background noise"

  criteria {
    metric_namespace = "microsoft.web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Count"
    operator         = "GreaterThanOrEqual"
    threshold        = "3"
  }

  action {
    action_group_id = var.performance_alert_id #azurerm_monitor_action_group.performance_alert.id
  }
}

resource "azurerm_monitor_metric_alert" "api_response_time" {
  name                = "apiResponseTime"
  resource_group_name = var.resource_group_name

  scopes      = var.sqldb == true ? [azurerm_app_service.api1[0].id] : [azurerm_app_service.api2[0].id]
  description = "Triggered when response time rises above SLA"

  criteria {
    metric_namespace = "microsoft.web/sites"
    metric_name      = "HttpResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = "0.5"
  }

  action {
    action_group_id = var.performance_alert_id #azurerm_monitor_action_group.performance_alert.id
  }
}

resource "azurerm_monitor_metric_alert" "api_pending_requests" {
  name = "apiPendingRequests"
  resource_group_name = var.resource_group_name

  scopes      = var.sqldb == true ? [azurerm_app_service.api1[0].id] : [azurerm_app_service.api2[0].id]
  description = "Triggered when pending request count rises above SLA"

  criteria {
    metric_namespace = "microsoft.web/sites"
    metric_name = "RequestsInApplicationQueue"
    aggregation = "Average"
    operator = "GreaterThanOrEqual"
    threshold = "10"
  }

  action {
    action_group_id = var.performance_alert_id #azurerm_monitor_action_group.performance_alert.id
  }
}
