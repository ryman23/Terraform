variable "resourceGroupName" {
    description =   "The name of the resource group to be created"
    type        =   "string"
}

variable "primaryRegion" {
    description =   "The primary region for 6 VM's (12 vCPU cores max per region = 6 VM's)"
    type        =   "string"
}

variable "secondaryRegion" {
    description =   "The secondary region for 6 VM's (12 vCPU cores max per region = 6 VM's)"
    type        =   "string"
}

variable "tertiaryRegion" {
    description =   "The tertiary region for 6 VM's (12 vCPU cores max per region = 6 VM's)"
    type        =   "string"
}

variable "quaternaryRegion" {
    description =   "The tertiary region for 6 VM's (12 vCPU cores max per region = 6 VM's)"
    type        =   "string"
}

variable "virtualNetworkName1" {
    description =   "The name of virtual network 1 the VM's will be on"
    type        =   "string"
}

variable "virtualNetworkName2" {
    description =   "The name of virtual network 2 the VM's will be on"
    type        =   "string"
}

variable "virtualNetworkName3" {
    description =   "The name of virtual network 3 the VM's will be on"
    type        =   "string"
}

variable "virtualNetworkName4" {
    description =   "The name of virtual network 4 the VM's will be on"
    type        =   "string"
}

variable "vnet1AddressSpace" {
    description =   "The address space of virtual network 1 the VM's will be attached to"
    type        =   "list"
}

variable "vnet2AddressSpace" {
    description =   "The address space of virtual network 2 the VM's will be attached to"
    type        =   "list"
}

variable "vnet3AddressSpace" {
    description =   "The address space of virtual network 3 the VM's will be attached to"
    type        =   "list"
}

variable "vnet4AddressSpace" {
    description =   "The address space of virtual network 4 the VM's will be attached to"
    type        =   "list"
}

variable "subnetName1" {
    description =   "The name of the subnet the VM's will be attached to on virtual network 1"
    type        =   "string"
}

variable "subnetName2" {
    description =   "The name of the subnet the VM's will be attached to on virtual network 2"
    type        =   "string"
}

variable "subnetName3" {
    description =   "The name of the subnet the VM's will be attached to on virtual network 3"
    type        =   "string"
}

variable "subnetName4" {
    description =   "The name of the subnet the VM's will be attached to on virtual network 4"
    type        =   "string"
}

variable "subnetAddressSpace1" {
    description =   "The address space of subnet 1 the VM's will be attached to"
    type        =   "string"
}

variable "subnetAddressSpace2" {
    description =   "The address space of subnet 2 the VM's will be attached to"
    type        =   "string"
}

variable "subnetAddressSpace3" {
    description =   "The address space of subnet 3 the VM's will be attached to"
    type        =   "string"
}

variable "subnetAddressSpace4" {
    description =   "The address space of subnet 4 the VM's will be attached to"
    type        =   "string"
}

variable "virtualMachineSize" {
    description =   "The size of the virtual machines"
    type        =   "string"
}

variable "vmUserName" {
    description =   "The local admin credentials to the VM"
    type        =   "string"
}

variable "vmPassword" {
    description =   "The password associated with the local admin credentials"
    type        =   "string"
}