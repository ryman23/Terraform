provider "azurerm" {
  version = "=2.3.0"
  features {}
}

resource "azurerm_resource_group" "main" {
    name     = "${var.resourceGroupName}"
    location = "${var.resourceGroupLocation}"
}

resource "azurerm_virtual_network" "main" {
    name                = "${var.vNetName}"
    address_space       = ["${var.vNetAddressSpace}"]
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
    name                 = "${var.subnet_1_name}"
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefix       = "${var.subnet_1_addressPrefix}"
}

resource "azurerm_public_ip" "main" {
    name                         = "${var.publicIPaddressName}"
    location                     = azurerm_resource_group.main.location
    resource_group_name          = azurerm_resource_group.main.name
    allocation_method            = "${var.publicIPallocation}"
}

resource "azurerm_lb" "main" {
    name                = "${var.loadBalancerName}"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    frontend_ip_configuration {
        name                 = azurerm_public_ip.main.name
        public_ip_address_id = azurerm_public_ip.main.id
    }
}

resource "azurerm_lb_backend_address_pool" "main" {
    resource_group_name = azurerm_resource_group.main.name
    loadbalancer_id     = azurerm_lb.main.id
    name                = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "main" {
    resource_group_name            = azurerm_resource_group.main.name
    loadbalancer_id                = azurerm_lb.main.id
    name                           = "http"
    protocol                       = "Tcp"
    frontend_port                  = "${var.applicationPort}"
    backend_port                   = "${var.applicationPort}"
    backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
    frontend_ip_configuration_name = azurerm_public_ip.main.name
}

resource "azurerm_virtual_machine_scale_set" "main" {
    name                = "${var.vmssName}"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    upgrade_policy_mode = "${var.vmssUpgradePolicy}"

    sku {
        name     = "${var.vmssVMsize}"
        tier     = "Standard"
        capacity = "${var.vmssVMcapacity}"
    }

    storage_profile_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }
    
    storage_profile_os_disk {
        name              = ""
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_profile_data_disk {
        lun            = 0
        caching        = "ReadWrite"
        create_option  = "Empty"
        disk_size_gb   = 10
    }

    os_profile {
        computer_name_prefix = "VMSS-Lab"
        admin_username       = "${var.credentials["userName"]}"
        admin_password       = "${var.credentials["password"]}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    network_profile {
        name    = "LinuxNetworkProfile"
        primary = true

        ip_configuration {
            name                                   = "IPConfiguration"
            subnet_id                              = azurerm_subnet.main.id
            load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]
            primary = true
        }
    }
}