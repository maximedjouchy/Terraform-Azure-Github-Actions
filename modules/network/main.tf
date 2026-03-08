resource "azurerm_virtual_network" "vnet_dev" {
  name                = "devnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "subnet_dev" {
  name                 = "internal"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_dev.name
  address_prefixes     = ["10.0.2.0/24"]
}
