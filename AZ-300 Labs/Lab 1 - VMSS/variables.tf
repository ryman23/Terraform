variable "resourceGroupName" {
    description = "The name of the resource group to be used in this lab"
    type = "string"
}
variable "resourceGroupLocation" {
    description = "The location of the resource group to be used in this lab"
    type = "string"
}
variable "vNetName" {
    description = "The name of the virutal network to be used in this lab"
    type = "string"
}
variable "vNetAddressSpace" {
    description = "The address space of the virutal network to be used in this lab"
    type = "string"
}
variable "subnet_1_name" {
    description = "The name of subnet 1 to be used in this lab"
    type = "string"
}
variable "subnet_1_addressPrefix" {
    description = "The name of subnet 1 to be used in this lab"
    type = "string"
}
variable "publicIPaddressName" {
    description = "The name of the public IP address to be used in this lab"
    type = "string"
}
variable "publicIPallocation" {
    description = "The allocation method of the public IP address to be used in this lab"
    type = "string"
}
variable "loadBalancerName" {
    description = "The name of the load balancer to be used in this lab"
    type = "string"
}
variable "applicationPort" {
    description = "The port of the backend pool of the load balancer to be used in this lab"
    type = "string"
}
variable "vmssName" {
    description = "The name of the virtual machine scale set to be used in this lab"
    type = "string"
}
variable "vmssUpgradePolicy" {
    description = "The upgrade polciy of the virtual machine scale set to be used in this lab"
    type = "string"
}
variable "vmssVMsize" {
    description = "The VM size of the virtual machine scale set to be used in this lab"
    type = "string"
}
variable "vmssVMcapacity" {
    description = "The number of VM's of the virtual machine scale set to be used in this lab"
    type = "string"
    default = "1"
}
variable "credentials" {
    type = "map"
    default = {
        "userName" = "Riley-Admin"
        "password" = "G0odPa55w.rd1234!"
    }
}