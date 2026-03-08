variable "rg_name" {
    type = string
    description = "name of the resource group"
    default = "devops_resourcegroup"
}

variable "vm_name" {
    type = string
    description = "name of the virtual machine"
    default = "mydevops_vm"
}

variable "rg_location" {
    type = string
    description = "location of resource group"
    default = "us-east2"
}