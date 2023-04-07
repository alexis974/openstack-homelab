# -------------------------------------------------------------- Variables --- #

variable "project_name" {
  type = string
}

variable "project_description" {
  type = string
}

variable "network_cidr" {
  type = string
}

variable "user_list" {
  type = map(string)
}

variable "user_description" {
  type = string
}

variable "ext_net_name" {
  type = string
}

variable "ext_net_cidr" {
  type = string
}

variable "ext_net_subnet_name" {
  type = string
}

variable "default_user_password" {
  sensitive = true
  type      = string
}