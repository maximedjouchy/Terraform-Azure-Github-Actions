variable "rg_name" {
    type = string
    description = "name of the resource group"
}

variable "vm_name" {
    type = string
    description = "name of the virtual machine"
}

variable "vm_size" {
    type = string
    description = "size of the virtual machine"
    default = "Standard_B1s"
}

variable "location" {
    type = string
    description = "location of resource group"
    default = "East US"
}

variable "subnet_id" {
  description = "ID du subnet provenant du module network"
  type        = string
}

variable "ssh_public_key" {
  description = "ssh public key for github"
  type        = string
}