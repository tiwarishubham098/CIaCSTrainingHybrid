
provider "azurerm" {
  features {}

  subscription_id   ="85cd2292-82e3-4c72-a2d7-1ba724a25176"
  tenant_id         ="120709b9-1cde-4a68-944a-f6fb5b566111"
  client_id         ="cfdd0e4a-063c-483b-914a-462ffc43a451"
  client_secret     ="YNY8Q~6tgGMJ_tvheVvFyXG78SsUbL66-mS.rb45"
}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "ciacsrg-${random_integer.ri.result}"
  location = "eastus"
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "webapp-${random_integer.ri.result}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  
  site_config {
    application_stack { 
      php_version = "7.4"
    }
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/SmithaVerity/IMS"
  branch             = "main"
  use_manual_integration = true
  use_mercurial      = false
}

