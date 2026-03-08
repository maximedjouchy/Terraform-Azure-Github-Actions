resource "azurerm_resource_group" "my_devops_rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "vnet_dev" {
  name                = "devnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my_devops_rg.location
  resource_group_name = azurerm_resource_group.my_devops_rg.name
}

resource "azurerm_subnet" "subnet_dev" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.my_devops_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_dev.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vm01_int" {
  name                = "vmdev-nic"
  location            = azurerm_resource_group.my_devops_rg.location
  resource_group_name = azurerm_resource_group.my_devops_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_dev.id
    private_ip_address_allocation = "Dynamic"
  }
}