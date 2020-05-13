variable "resourceGroupName" {
    default = "AZ-1000302-RG"
}

variable "vNetConfig" {
    type = "map"
    default = {
        "vnetName" = "az1000301-RG-vnet"
        "addressSpace" = "10.0.0.0/16"
    }
}

variable "subnetConfig" {
    type = "map"
    default = {
        "subnetName" = "subnet0"
        "addressSpace" = "10.0.1.0/24"
    }
}

variable "vmConfig" {
    type = "map"
    default = {
        "vmName" = "az1000302-vm"
        "vmNic" = "az1000302-nic"
        "vmSize" = "Standard_DS2_v2"
    }
}

variable "publicIP" {
    default = "az1000302-ip"
}