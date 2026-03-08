variable "rg_name" {
    type = string
    description = "name of the resource group"
}

variable "vm_name" {
    type = string
    description = "name of the virtual machine"
}

variable "rg_location" {
    type = string
    description = "location of resource group"
    default = "us-east2"
}