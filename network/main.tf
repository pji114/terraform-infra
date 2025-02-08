terraform {
  backend "s3" {}
}

locals {
  subnets   = var.subnets
  vpc-cidr  = var.vpc-cidr
  vpc-name  = var.vpc-name
}

module "eks-network" {
  source = "../../terraform-module/module/pji/computing-networks"
  subnets = local.subnets
  vpc-cidr = local.vpc-cidr
  vpc-name = local.vpc-name
}