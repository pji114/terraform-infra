locals {
  vpc_name = var.vpc_name
}


module "pji-eks" {
  source = "../../terraform-module/module/pji/computings"

  vpc_name = local.vpc_name
}