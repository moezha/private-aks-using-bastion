resource "azurerm_resource_group" "rg" {
  name     = "private-aks-using-bastion-${var.prefix}"
  location = var.location
}