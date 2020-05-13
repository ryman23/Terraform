resource "azurerm_resource_group" "main" {
    name     = "${var.resourceGroup["resourceGroupName"]}"
    location = "${var.resourceGroup["location"]}"
}

resource "azurerm_virtual_network" "main" {
    name                = "${var.vNet["vNetName"]}"
    address_space       = ["${var.vNet["addressSpace"]}"]
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
    name                 = "${var.subnet0["subnetName"]}"
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefix       = "${var.subnet0["addressPrefix"]}"
}

resource "azurerm_public_ip" "main" {
    name                         = "${var.publicIP["IPaddressName"]}"
    location                     = azurerm_resource_group.main.location
    resource_group_name          = azurerm_resource_group.main.name
    allocation_method            = "${var.publicIP["allocation"]}"
    domain_name_label            = "${var.publicIP["domainName"]}"
}

resource "azurerm_lb" "main" {
    name                = "${var.publicLB["lbName"]}"
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
    name                = "${var.vmss["vmssName"]}"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    upgrade_policy_mode = "${var.vmss["upgradePolicy"]}"

    sku {
        name     = "${var.vmss["VMsize"]}"
        tier     = "Standard"
        capacity = "${var.vmss["capacity"]}"
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
        lun          = 0
        caching        = "ReadWrite"
        create_option  = "Empty"
        disk_size_gb   = 10
    }

    os_profile {
        computer_name_prefix = "VMSS-Lab"
        admin_username       = "${var.credentials["userName"]}"
        admin_password       = "${var.credentials["password"]}"
        custom_data          = file("web.conf")
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    network_profile {
        name    = "LinuxNetworkProfile"
        primary = true

        ip_configuration {
            name                                   = "IPConfiguration"
            subnet_id                              = azurerm_subnet.internal.id
            load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]
            primary = true
        }
    }
}