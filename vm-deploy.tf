provider "azurerm" {
  version = "=2.3.0"
  features {}
}

resource "azurerm_resource_group" "main" {
  name      = "${var.resourceGroupName}"
  location  = "${var.primaryRegion}"
}

resource "azurerm_virtual_network" "ncus" {
  name                = "${var.virtualNetworkName1}"
  address_space       = "${var.vnet1AddressSpace}"
  location            = "${var.primaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_virtual_network" "eus" {
  name                = "${var.virtualNetworkName2}"
  address_space       = "${var.vnet2AddressSpace}"
  location            = "${var.secondaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_virtual_network" "wus" {
  name                = "${var.virtualNetworkName3}"
  address_space       = "${var.vnet3AddressSpace}"
  location            = "${var.tertiaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_virtual_network" "scus" {
  name                = "${var.virtualNetworkName4}"
  address_space       = "${var.vnet4AddressSpace}"
  location            = "${var.quaternaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "ncus" {
  name                      = "${var.subnetName1}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  virtual_network_name      = "${azurerm_virtual_network.ncus.name}"
  address_prefix            = "${var.subnetAddressSpace1}"
}

resource "azurerm_subnet" "eus" {
  name                      = "${var.subnetName2}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  virtual_network_name      = "${azurerm_virtual_network.eus.name}"
  address_prefix            = "${var.subnetAddressSpace2}"
}

resource "azurerm_subnet" "wus" {
  name                      = "${var.subnetName3}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  virtual_network_name      = "${azurerm_virtual_network.wus.name}"
  address_prefix            = "${var.subnetAddressSpace3}"
}

resource "azurerm_subnet" "scus" {
  name                      = "${var.subnetName4}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  virtual_network_name      = "${azurerm_virtual_network.scus.name}"
  address_prefix            = "${var.subnetAddressSpace4}"
}

resource "azurerm_network_interface" "ncus" {
  count               = "5"
  name                = "VM-NIC-NCUS-${count.index}"
  location            = "${azurerm_virtual_network.ncus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "VM-NIC-CONFIG-${count.index}"
    subnet_id                     = "${azurerm_subnet.ncus.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.ncus.*.id, count.index)}"
  }
}


resource "azurerm_network_interface" "eus" {
  count               = "5"
  name                = "VM-NIC-EUS-${count.index}"
  location            = "${azurerm_virtual_network.eus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "VM-NIC-CONFIG-${count.index}"
    subnet_id                     = "${azurerm_subnet.eus.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.eus.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "wus" {
  count               = "5"
  name                = "VM-NIC-WUS-${count.index}"
  location            = "${azurerm_virtual_network.wus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "VM-NIC-CONFIG-${count.index}"
    subnet_id                     = "${azurerm_subnet.wus.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.wus.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "scus" {
  count               = "4"
  name                = "VM-NIC-SCUS-${count.index}"
  location            = "${azurerm_virtual_network.scus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "VM-NIC-CONFIG-${count.index}"
    subnet_id                     = "${azurerm_subnet.scus.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.scus.*.id, count.index)}"
  }
}

resource "azurerm_public_ip" "ncus" {
  count               = "5"
  name                = "VM-PIP-NCUS-${count.index}"
  location            = "${azurerm_virtual_network.ncus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "eus" {
  count               = "5"
  name                = "VM-PIP-EUS-${count.index}"
  location            = "${azurerm_virtual_network.eus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "wus" {
  count               = "5"
  name                = "VM-PIP-WUS-${count.index}"
  location            = "${azurerm_virtual_network.wus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "scus" {
  count               = "4"
  name                = "VM-PIP-SCUS-${count.index}"
  location            = "${azurerm_virtual_network.scus.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "ncus" {
  name                = "DEFUALT-NSG-NCUS"
  location            = "${var.primaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_network_security_group" "eus" {
  name                = "DEFUALT-NSG-EUS"
  location            = "${var.secondaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_network_security_group" "wus" {
  name                = "DEFUALT-NSG-WUS"
  location            = "${var.tertiaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_network_security_group" "scus" {
  name                = "DEFUALT-NSG-SCUS"
  location            = "${var.quaternaryRegion}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_network_security_rule" "NCUS_RDP" {
  name                        = "Allow RDP From Anywhere"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  network_security_group_name = "${azurerm_network_security_group.ncus.name}"
}

resource "azurerm_network_security_rule" "EUS_RDP" {
  name                        = "Allow RDP From Anywhere"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  network_security_group_name = "${azurerm_network_security_group.eus.name}"
}

resource "azurerm_network_security_rule" "WUS_RDP" {
  name                        = "Allow RDP From Anywhere"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  network_security_group_name = "${azurerm_network_security_group.wus.name}"
}

resource "azurerm_network_security_rule" "SCUS_RDP" {
  name                        = "Allow RDP From Anywhere"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  network_security_group_name = "${azurerm_network_security_group.scus.name}"
}

resource "azurerm_subnet_network_security_group_association" "ncus" {
  subnet_id                 = "${azurerm_subnet.ncus.id}"
  network_security_group_id = "${azurerm_network_security_group.ncus.id}"
}

resource "azurerm_subnet_network_security_group_association" "eus" {
  subnet_id                 = "${azurerm_subnet.eus.id}"
  network_security_group_id = "${azurerm_network_security_group.eus.id}"
}

resource "azurerm_subnet_network_security_group_association" "wus" {
  subnet_id                 = "${azurerm_subnet.wus.id}"
  network_security_group_id = "${azurerm_network_security_group.wus.id}"
}

resource "azurerm_subnet_network_security_group_association" "scus" {
  subnet_id                 = "${azurerm_subnet.scus.id}"
  network_security_group_id = "${azurerm_network_security_group.scus.id}"
}

resource "azurerm_virtual_machine" "ncus" {
  count                 = "5"
  name                  = "ACE-VM-${count.index}-NCUS"
  location              = "${azurerm_virtual_network.ncus.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.ncus.*.id, count.index)}"]
  vm_size               = "${var.virtualMachineSize}"

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "VM-OS-DISK-NCUS${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "127"
  }
  os_profile {
    computer_name        = "ACEVM${count.index}"
    admin_username       = "${var.vmUserName}"
    admin_password       = "${var.vmPassword}"
  }
}

resource "azurerm_virtual_machine" "eus" {
  count                 = "5"
  name                  = "ACE-VM-${count.index}-EUS"
  location              = "${azurerm_virtual_network.eus.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.eus.*.id, count.index)}"]
  vm_size               = "${var.virtualMachineSize}"

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "VM-OS-DISK-EUS${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "127"
  }
  os_profile {
    computer_name        = "ACEVM${count.index}"
    admin_username       = "${var.vmUserName}"
    admin_password       = "${var.vmPassword}"
  }
}

resource "azurerm_virtual_machine" "wus" {
  count                 = "5"
  name                  = "ACE-VM-${count.index}-WUS"
  location              = "${azurerm_virtual_network.wus.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.wus.*.id, count.index)}"]
  vm_size               = "${var.virtualMachineSize}"

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "VM-OS-DISK-WUS${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "127"
  }
  os_profile {
    computer_name        = "ACEVM${count.index}"
    admin_username       = "${var.vmUserName}"
    admin_password       = "${var.vmPassword}"
  }
}

resource "azurerm_virtual_machine" "scus" {
  count                 = "4"
  name                  = "ACE-VM-${count.index}-SCUS"
  location              = "${azurerm_virtual_network.scus.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.scus.*.id, count.index)}"]
  vm_size               = "${var.virtualMachineSize}"

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "VM-OS-DISK-SCUS${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "127"
  }
  os_profile {
    computer_name        = "ACEVM${count.index}"
    admin_username       = "${var.vmUserName}"
    admin_password       = "${var.vmPassword}"
  }
}

output "primary_ips" {
  value = "${azurerm_public_ip.ncus.*.ip_address}"
}

output "secondary_ips" {
  value = "${azurerm_public_ip.eus.*.ip_address}"
}

output "tertiary_ips" {
  value = "${azurerm_public_ip.wus.*.ip_address}"
}

output "quaternary_ips" {
  value = "${azurerm_public_ip.scus.*.ip_address}"
}