

resource "azurerm_resource_group" "main" {
  name  = "${var.resourceGroupName}"
  location = "North Central US"
}
resource "azurerm_virtual_network" "main" {
  name                = "${var.vNetConfig["vnetName"]}"
  address_space       = ["${var.vNetConfig["addressSpace"]}"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.subnetConfig["subnetName"]}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.subnetConfig["addressSpace"]}"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.vmConfig["vmNic"]}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "NIC-Config"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
     public_ip_address_id         = "${azurerm_public_ip.main.id}"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.publicIP}"
  location            = "North Central US"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.vmConfig["vmName"]}"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "${var.vmConfig["vmSize"]}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "OS-DISK-1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "az1000302-vm"
    admin_username = "Student"
    admin_password = "Pa55w.rd1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}