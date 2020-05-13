variable "resourceGroup" {
    type = "map"
    default = {
        "resourceGroupName" = "Terraform-VMSS-NCUS"
        "location" = "North Central US"
    }
}

variable "vNet" {
    type = "map"
    default = {
        "vNetName" = "VMSS-vNet-NCUS"
        "addressSpace" = "10.203.0.0/16"
    }
}

variable "subnet0" {
    type = "map"
    default = {
        "subnetName" = "subnbet0"
        "addressPrefix" = "10.203.0.0/24"
    }
}

variable "publicIP" {
    type = "map"
    default = {
        "domainName" = "partlycloudy"
        "allocation" = "Static"
        "IPaddressName" = "VMSS-PubIP-NCUS"
    }
}

variable "publicLB" {
    type = "map"
    default = {
        "lbName" = "VMSS-PublicLB-NCUS"
    }
}

variable "vmss" {
    type = "map"
    default = {
        "vmssName" = "VMSS-MCVMSS-NCUS"
        "upgradePolicy" = "Manual"
        "VMsize" = "Standard_DS2_v2"
        "capacity" = "1"
    }
}

variable "credentials" {
    type = "map"
    default = {
        "userName" = "Student"
        "password" = "Pa55w.rd1234"
    }
}

variable "applicationPort"          {}