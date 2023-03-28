output "default_site_hostname" {
  description = "The Hostname associated with the App Service"
  value       = format("https://%s/", azurerm_linux_web_app.webapp.default_site_hostname)
}

output "address" {
  value       = aws_db_instance.example.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "The port the database is listening on"
}
