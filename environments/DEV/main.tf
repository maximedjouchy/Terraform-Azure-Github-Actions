module "network" {
  source = "../../modules/network"
}

module "vm_dev" {
  source  = "../../modules/compute"
  vm_name = "vm-dev-01"
  rg_name = "rg-dev"
  # ...
}