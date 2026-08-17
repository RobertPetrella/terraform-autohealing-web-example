#Create output file to output following parameters:
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

#Output the public IP of the generated load balanced NGINX sites
output "public_ip_address" {
  value = "http://{azurerm_public_ip.public_ip.ip_address}"
}