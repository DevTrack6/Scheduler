variable "access_key" {
  type = string
  sensitive = true
}

variable "secret_key" {
  type = string
  sensitive = true
}

variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "subnet_no" {
  type = string
}

variable "vpc_no" {
  type = string
}

variable "server_image_product_code" {
  type = string
}

variable "product_code" {
  type = string
}

variable "init_script_path" {
  type = string
}

variable "init_script_envs" {
  type = map(any)
}

variable "acg_port_range" {
  type = string
}
