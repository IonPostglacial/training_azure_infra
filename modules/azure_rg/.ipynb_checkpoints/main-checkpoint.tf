resource "azurerm_virtual_network" "ngalipot_vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags = {
    environment = "preprod"
  }
}

resource "azurerm_subnet" "ngalipot_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.ngalipot_vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

resource "azurerm_network_security_group" "ngalipot_nsg" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_subnet_network_security_group_association" "ngalipot_subnet_nsg" {
  subnet_id                 = azurerm_subnet.ngalipot_subnet.id
  network_security_group_id = azurerm_network_security_group.ngalipot_nsg.id
}

resource "azurerm_network_security_rule" "this" {
  count = length(var.open_ports)

  name                        = "port-${var.open_ports[count.index]}"
  priority                    = 100 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = var.open_ports[count.index]
  destination_port_range      = var.open_ports[count.index]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.ngalipot_nsg.name
}