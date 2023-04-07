# -------------------------------------------------------------- Variables --- #

variable "network_cidr" {
  type = string
}

variable "project_name" {
  type = string
}

variable "controller_number" {
  type = number
}

variable "controller_flavor" {
  type    = string
  default = "m1.large"
}

variable "controller_volume_size" {
  type    = number
  default = "30"
}

variable "worker_number" {
  type = number
}

variable "worker_flavor" {
  type    = string
  default = "m1.large"
}

variable "worker_volume_size" {
  type    = number
  default = "50"
}