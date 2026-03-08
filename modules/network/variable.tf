variable "rg_name" {
    type = string
    description = "name of the resource group"
}

variable "location" {
    type = string
    description = "location of resource group"
    default = "East US"
}