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

module "be_server" {
  source = "../modules/server"

  access_key = var.access_key
  secret_key = var.secret_key
  env = local.env
  name = "be"

  subnet_no = module.network.subnet_no
  vpc_no = module.network.vpc_no
  acg_port_range = "8000"

  server_image_product_code = data.ncloud_server_products.sm.server_image_product_code
  product_code = data.ncloud_server_products.sm.product_code

  init_script_path = "be_init_script.tftpl"
  init_script_envs = {
    access_key = var.access_key
    secret_key = var.secret_key
    password = var.password
    DB_HOST = ncloud_public_ip.db.public_ip
    POSTGRES_DB = var.POSTGRES_DB
    POSTGRES_USER = var.POSTGRES_USER
    POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
    POSTGRES_PORT = var.POSTGRES_PORT
    DJANGO_SETTINGS_MODULE = var.DJANGO_SETTINGS_MODULE
    DJANGO_SECRET_KEY = var.DJANGO_SECRET_KEY
  }
}

module "db_server" {
  source = "../modules/server"

  access_key = var.access_key
  secret_key = var.secret_key
  env = local.env
  name = "db"

  subnet_no = module.network.subnet_no
  vpc_no = module.network.vpc_no
  acg_port_range = "5432"

  server_image_product_code = data.ncloud_server_products.sm.server_image_product_code
  product_code = data.ncloud_server_products.sm.product_code

  init_script_path = "db_init_script.tftpl"
  init_script_envs = {
    password = var.password
    POSTGRES_DB = var.POSTGRES_DB
    POSTGRES_USER = var.POSTGRES_USER
    POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
    POSTGRES_PORT = var.POSTGRES_PORT
  }
}

resource "ncloud_public_ip" "be" {
    server_instance_no = module.be_server.instance_no
}

resource "ncloud_public_ip" "db" {
    server_instance_no = module.db_server.instance_no
}

data "ncloud_server_products" "sm" {
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  product_code = "SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002"
}
