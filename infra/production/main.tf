terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.6.0"
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

provider "ssh" {}

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


resource "ssh_resource" "db_init" {
  depends_on = [ module.db_server ]
  when = "create"

  host         = ncloud_public_ip.db.public_ip
  user         = "lion"
  password = var.password

  timeout     = "2m"
  retry_delay = "5s"

  file {
    source = "${path.module}/set_db_server.sh"
    destination = "/home/lion/set_db_server.sh"
    permissions = "0700"
  }

  commands = [
    "/home/lion/set_db_server.sh"
  ]
}

# TODO: set_be_server.sh ncp로그인 정보와 이미지 주소 수정 필요
# resource "ssh_resource" "be_init" {
#   depends_on = [ module.be_server ]
#   when = "create"

#   host         = ncloud_public_ip.be.public_ip
#   user         = "lion"
#   password = var.password

#   timeout     = "2m"
#   retry_delay = "5s"

#   file {
#     source = "${path.module}/set_be_server.sh"
#     destination = "set_be_server.sh"
#     permissions = "0700"
#   }

#   commands = [
#     "/home/lion/set_be_server.sh"
#   ]
# }
