terraform {
  backend "local" {
    path = "/Users/junyoung_kim/DRF_study/terraform_study/states/staging.tfstate"
  }
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

// Configure the ncloud provider
provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "KR"
  site = "PUBLIC"
  support_vpc = true
}

locals {
  env = "prod"
}

module "network" {
  source = "../modules/network"
  access_key = var.access_key
  secret_key = var.secret_key
  env = local.env
}
